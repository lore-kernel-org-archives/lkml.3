Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab3HUBRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 21:17:50 -0400
Received: from ozlabs.org ([203.10.76.45]:46898 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413Ab3HUBRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 21:17:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Chen Gang <gang.chen@asianux.com>, jg1.han@samsung.com, khali@linux-fr.org,
        David.Woodhouse@intel.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/params.c: use scnprintf() instead of sprintf()
In-Reply-To: <5212DFB0.8070902@asianux.com>
References: <5212DFB0.8070902@asianux.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 20 Aug 2013 15:35:22 +0930
Message-ID: <87siy4gan1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chen Gang <gang.chen@asianux.com> writes:

> For some strings (e.g. version string), they are permitted to be larger
> than PAGE_SIZE (although meaningless), so recommend to use scnprintf()
> instead of sprintf().

Applied.

Thanks,
Rusty.

>
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  kernel/params.c |    7 ++++---
>  1 files changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/params.c b/kernel/params.c
> index 1f228a3..4da300f 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -241,7 +241,8 @@ int parse_args(const char *doing,
>  	}								\
>  	int param_get_##name(char *buffer, const struct kernel_param *kp) \
>  	{								\
> -		return sprintf(buffer, format, *((type *)kp->arg));	\
> +		return scnprintf(buffer, PAGE_SIZE, format,		\
> +				*((type *)kp->arg));			\
>  	}								\
>  	struct kernel_param_ops param_ops_##name = {			\
>  		.set = param_set_##name,				\
> @@ -285,7 +286,7 @@ EXPORT_SYMBOL(param_set_charp);
>  
>  int param_get_charp(char *buffer, const struct kernel_param *kp)
>  {
> -	return sprintf(buffer, "%s", *((char **)kp->arg));
> +	return scnprintf(buffer, PAGE_SIZE, "%s", *((char **)kp->arg));
>  }
>  EXPORT_SYMBOL(param_get_charp);
>  
> @@ -827,7 +828,7 @@ ssize_t __modver_version_show(struct module_attribute *mattr,
>  	struct module_version_attribute *vattr =
>  		container_of(mattr, struct module_version_attribute, mattr);
>  
> -	return sprintf(buf, "%s\n", vattr->version);
> +	return scnprintf(buf, PAGE_SIZE, "%s\n", vattr->version);
>  }
>  
>  extern const struct module_version_attribute *__start___modver[];
> -- 
> 1.7.7.6
