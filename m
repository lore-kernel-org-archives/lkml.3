Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab3HUBRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:17:49 -0400
Received: from ozlabs.org ([203.10.76.45]:40993 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab3HUBRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:17:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module.c: use scnprintf() instead of sprintf()
In-Reply-To: <5212DEC3.9070007@asianux.com>
References: <5212DEC3.9070007@asianux.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 20 Aug 2013 15:34:42 +0930
Message-ID: <87vc30gao5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

> For some strings, they are permitted to be larger than PAGE_SIZE, so
> need use scnprintf() instead of sprintf(), or it will cause issue.
>
> One case is:
>
>   if a module version is crazy defined (length more than PAGE_SIZE),
>   'modinfo' command is still OK (print full contents),
>   but for "cat /sys/modules/'modname'/version", will cause issue in kernel.

Applied!

Thanks,
Rusty.

>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/module.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..0618e63 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -603,7 +603,7 @@ static void setup_modinfo_##field(struct module *mod, const char *s)  \
>  static ssize_t show_modinfo_##field(struct module_attribute *mattr,   \
>  			struct module_kobject *mk, char *buffer)      \
>  {                                                                     \
> -	return sprintf(buffer, "%s\n", mk->mod->field);               \
> +	return scnprintf(buffer, PAGE_SIZE, "%s\n", mk->mod->field);  \
>  }                                                                     \
>  static int modinfo_##field##_exists(struct module *mod)               \
>  {                                                                     \
> -- 
> 1.7.7.6
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
