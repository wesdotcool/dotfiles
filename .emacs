(package-initialize)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(setq-default js2-basic-offset 2)
(tool-bar-mode -1)
(load-library "flycheck")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes '(wheatgrass))
 '(midnight-mode t)
 '(org-agenda-files '("~/.notes" "/Users/whunt/Dropbox/pers/1.org"))
 '(package-selected-packages
   '(go-mode lsp-mode js-comint csv-mode php-mode pretty-hydra hydra tide prettier-js company-go ruby-end tdd ruby-refactor ruby-hash-syntax minitest rubocop rspec-mode flymake-ruby rbenv robe yari helm-projectile projectile-rails popup-kill-ring ido-vertical-mode smex ido-ubiquitous haml-mode dired-details dired-subtree dash-at-point fill-column-indicator coffee-mode company ace-window flx-ido volatile-highlights undo-tree paredit rainbow-mode move-text projectile guru-mode gitignore-mode gitconfig-mode gist flycheck expand-region epl elisp-slime-nav diminish dash browse-kill-ring anzu ack-and-a-half ace-jump-mode lua-mode rjsx-mode nyan-mode ack-menu web-mode multi-web-mode magit ag)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(use-package go-mode
  :mode "\\.go\\'"
  :config
  (defun my/go-mode-setup ()
    "Basic Go mode setup."
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
  (add-hook 'go-mode-hook #'my/go-mode-setup))

(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-mode lsp-deferred)
  :hook ((rust-mode python-mode go-mode) . lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil
        lsp-enable-indentation nil
        lsp-enable-on-type-formatting nil
        lsp-rust-server 'rust-analyzer)
  ;; for filling args placeholders upon function completion candidate selection
  ;; lsp-enable-snippet and company-lsp-enable-snippet should be nil with
  ;; yas-minor-mode is enabled: https://emacs.stackexchange.com/q/53104
  (lsp-modeline-code-actions-mode)
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (add-to-list 'lsp-file-watch-ignored "\\.vscode\\'"))

(setq-default indent-tabs-mode nil)

(setq auto-mode-alist
  (append
   ;; File name ends with .jsx
   '(("\\.jsx" . rjsx-mode))
   auto-mode-alist))
(setq auto-mode-alist
  (append
   ;; File name ends with .jsx
   '(("\\.js" . rjsx-mode))
   auto-mode-alist))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(setq auto-mode-alist
  (append
   ;; .env file
   '(("\\.env" . sh-mode))
   auto-mode-alist))

;; Add brew packages to the emacs path
(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

(add-hook 'before-save-hook 'delete-trailing-whitespace)
(column-number-mode 1)

(defun dont-close-emacs () "This won't close emacs"
       (interactive)
       (message "HAHA YOU CAN'T CLOSE EMACS"))
(global-set-key (kbd "C-x C-c") 'dont-close-emacs)
(global-set-key (kbd "C-c p") 'prettier-js)

(global-set-key (kbd "C-;") 'magit-blame)

(global-set-key (kbd "M-5") 'replace-string)

(set-face-attribute 'default nil :height 140)

(setq js2-mode-show-strict-warnings nil)
(add-hook `rjsx-mode-hook `prettier-js-mode)

(setq inhibit-splash-screen t)

(setq-default js2-basic-offset 2)
;; TYPESCRIPT

(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)


(add-hook 'before-save-hook 'tide-format-before-save)

(add-hook 'typescript-mode-hook #'setup-tide-mode)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; enable typescript-tslint checker
(flycheck-add-mode 'typescript-tslint 'web-mode)

;;(setq-default typescript-indent-level 2)
(setq tide-format-options '(:indentSize 2))
