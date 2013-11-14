Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363Ab3KNGmS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 01:42:18 -0500
Received: from ozlabs.org ([203.10.76.45]:37850 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094Ab3KNGmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 01:42:07 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 11/17] kernel/param: Consolidate __{start,stop}___param[] in <linux/moduleparam.h>
In-Reply-To: <1384285347-13506-12-git-send-email-geert@linux-m68k.org>
References: <1384285347-13506-1-git-send-email-geert@linux-m68k.org> <1384285347-13506-12-git-send-email-geert@linux-m68k.org>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 14 Nov 2013 14:31:30 +1030
Message-ID: <87habfy6lh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> writes:
> Consolidate the various external const and non-const declarations of
> __start___param[] and __stop___param in <linux/moduleparam.h>.
> This requires making a few struct kernel_param pointers in kernel/params.c
> const.
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks!
Rusty.

> ---
>  include/linux/moduleparam.h |    2 ++
>  init/main.c                 |    2 --
>  kernel/params.c             |    7 +++----
>  3 files changed, 5 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index c3eb102a9cc8..77ccfca0c4ba 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -68,6 +68,8 @@ struct kernel_param {
>  	};
>  };
>  
> +extern const struct kernel_param __start___param[], __stop___param[];
> +
>  /* Special one for strings we want to copy into */
>  struct kparam_string {
>  	unsigned int maxlen;
> diff --git a/init/main.c b/init/main.c
> index 15ed159b681b..f2c4901f90d1 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -469,7 +469,6 @@ static void __init mm_init(void)
>  asmlinkage void __init start_kernel(void)
>  {
>  	char * command_line;
> -	extern const struct kernel_param __start___param[], __stop___param[];
>  
>  	/*
>  	 * Need to run as early as possible, to initialize the
> @@ -737,7 +736,6 @@ static char *initcall_level_names[] __initdata = {
>  
>  static void __init do_initcall_level(int level)
>  {
> -	extern const struct kernel_param __start___param[], __stop___param[];
>  	initcall_t *fn;
>  
>  	strcpy(static_command_line, saved_command_line);
> diff --git a/kernel/params.c b/kernel/params.c
> index c00d5b502aa4..54e05ffb7d24 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -19,6 +19,7 @@
>  #include <linux/string.h>
>  #include <linux/errno.h>
>  #include <linux/module.h>
> +#include <linux/moduleparam.h>
>  #include <linux/device.h>
>  #include <linux/err.h>
>  #include <linux/slab.h>
> @@ -506,8 +507,6 @@ EXPORT_SYMBOL(param_ops_string);
>  #define to_module_attr(n) container_of(n, struct module_attribute, attr)
>  #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
>  
> -extern struct kernel_param __start___param[], __stop___param[];
> -
>  struct param_attribute
>  {
>  	struct module_attribute mattr;
> @@ -766,7 +765,7 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
>  }
>  
>  static void __init kernel_add_sysfs_param(const char *name,
> -					  struct kernel_param *kparam,
> +					  const struct kernel_param *kparam,
>  					  unsigned int name_skip)
>  {
>  	struct module_kobject *mk;
> @@ -801,7 +800,7 @@ static void __init kernel_add_sysfs_param(const char *name,
>   */
>  static void __init param_sysfs_builtin(void)
>  {
> -	struct kernel_param *kp;
> +	const struct kernel_param *kp;
>  	unsigned int name_len;
>  	char modname[MODULE_NAME_LEN];
>  
> -- 
> 1.7.9.5
