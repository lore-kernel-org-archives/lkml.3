Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757057Ab3FCCcn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 22:32:43 -0400
Received: from ozlabs.org ([203.10.76.45]:41155 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756662Ab3FCCcc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 22:32:32 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] There is no /sys/parameters
In-Reply-To: <20130531091029.5c5074bc@endymion.delvare>
References: <20130531091029.5c5074bc@endymion.delvare>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Jun 2013 10:51:06 +0930
Message-ID: <87vc5wt2f1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare <khali@linux-fr.org> writes:

> There is no such path as /sys/parameters, module parameters live in
> /sys/module/*/parameters.

Thanks, applied!

Cheers,
Rusty.

> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  include/linux/moduleparam.h |    2 +-
>  kernel/params.c             |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> --- linux-3.10-rc3.orig/include/linux/moduleparam.h	2013-04-29 02:36:01.000000000 +0200
> +++ linux-3.10-rc3/include/linux/moduleparam.h	2013-05-30 10:41:37.417314420 +0200
> @@ -439,7 +439,7 @@ extern struct kernel_param_ops param_ops
>  extern int param_set_copystring(const char *val, const struct kernel_param *);
>  extern int param_get_string(char *buffer, const struct kernel_param *kp);
>  
> -/* for exporting parameters in /sys/parameters */
> +/* for exporting parameters in /sys/module/.../parameters */
>  
>  struct module;
>  
> --- linux-3.10-rc3.orig/kernel/params.c	2013-05-13 15:27:49.883223693 +0200
> +++ linux-3.10-rc3/kernel/params.c	2013-05-30 10:43:40.411316243 +0200
> @@ -787,7 +787,7 @@ static void __init kernel_add_sysfs_para
>  }
>  
>  /*
> - * param_sysfs_builtin - add contents in /sys/parameters for built-in modules
> + * param_sysfs_builtin - add sysfs parameters for built-in modules
>   *
>   * Add module_parameters to sysfs for "modules" built into the kernel.
>   *
>
>
> -- 
> Jean Delvare
