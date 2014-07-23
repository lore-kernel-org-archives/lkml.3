Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaGWF4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:56:37 -0400
Received: from ozlabs.org ([103.22.144.67]:59322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaGWF4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:56:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Petr Mladek <pmladek@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: [PATCH 2/2] module: return bool from within_module*()
In-Reply-To: <1406032090-16151-3-git-send-email-pmladek@suse.cz>
References: <1406032090-16151-1-git-send-email-pmladek@suse.cz> <1406032090-16151-3-git-send-email-pmladek@suse.cz>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Jul 2014 15:09:13 +0930
Message-ID: <87bnsgzla6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Mladek <pmladek@suse.cz> writes:
> The within_module*() functions return only true or false. Let's use bool as
> the return type.
>
> Note that it should not change kABI because these are inline functions.
>
> Signed-off-by: Petr Mladek <pmladek@suse.cz>

Thanks, applied both.

Cheers,
Rusty.

> ---
>  include/linux/module.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 61d8fb2d0873..71f282a4e307 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -396,19 +396,21 @@ bool is_module_address(unsigned long addr);
>  bool is_module_percpu_address(unsigned long addr);
>  bool is_module_text_address(unsigned long addr);
>  
> -static inline int within_module_core(unsigned long addr, const struct module *mod)
> +static inline bool within_module_core(unsigned long addr,
> +				      const struct module *mod)
>  {
>  	return (unsigned long)mod->module_core <= addr &&
>  	       addr < (unsigned long)mod->module_core + mod->core_size;
>  }
>  
> -static inline int within_module_init(unsigned long addr, const struct module *mod)
> +static inline bool within_module_init(unsigned long addr,
> +				      const struct module *mod)
>  {
>  	return (unsigned long)mod->module_init <= addr &&
>  	       addr < (unsigned long)mod->module_init + mod->init_size;
>  }
>  
> -static inline int within_module(unsigned long addr, const struct module *mod)
> +static inline bool within_module(unsigned long addr, const struct module *mod)
>  {
>  	return within_module_init(addr, mod) || within_module_core(addr, mod);
>  }
> -- 
> 1.8.4
