Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934098Ab3IDAnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 20:43:40 -0400
Received: from tundra.namei.org ([65.99.196.166]:50928 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761445Ab3IDAnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 20:43:39 -0400
Date: Wed, 4 Sep 2013 10:45:01 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
Subject: Re: [PATCH V3 01/11] Add secure_modules() call
In-Reply-To: <1378252218-18798-2-git-send-email-matthew.garrett@nebula.com>
Message-ID: <alpine.LRH.2.02.1309041044340.20116@tundra.namei.org>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com> <1378252218-18798-2-git-send-email-matthew.garrett@nebula.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Sep 2013, Matthew Garrett wrote:

> Provide a single call to allow kernel code to determine whether the system
> has been configured to either disable module loading entirely or to load
> only modules signed with a trusted key.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Reviewed-by: James Morris <jmorris@namei.org>


> ---
>  include/linux/module.h |  7 +++++++
>  kernel/module.c        | 10 ++++++++++
>  2 files changed, 17 insertions(+)
> 
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46f1ea0..0c266b2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -509,6 +509,8 @@ int unregister_module_notifier(struct notifier_block * nb);
>  
>  extern void print_modules(void);
>  
> +extern bool secure_modules(void);
> +
>  #else /* !CONFIG_MODULES... */
>  
>  /* Given an address, look for it in the exception tables. */
> @@ -619,6 +621,11 @@ static inline int unregister_module_notifier(struct notifier_block * nb)
>  static inline void print_modules(void)
>  {
>  }
> +
> +static inline bool secure_modules(void)
> +{
> +	return false;
> +}
>  #endif /* CONFIG_MODULES */
>  
>  #ifdef CONFIG_SYSFS
> diff --git a/kernel/module.c b/kernel/module.c
> index 2069158..0e94acf 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3852,3 +3852,13 @@ void module_layout(struct module *mod,
>  }
>  EXPORT_SYMBOL(module_layout);
>  #endif
> +
> +bool secure_modules(void)
> +{
> +#ifdef CONFIG_MODULE_SIG
> +	return (sig_enforce || modules_disabled);
> +#else
> +	return modules_disabled;
> +#endif
> +}
> +EXPORT_SYMBOL(secure_modules);
> -- 
> 1.8.3.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
James Morris
<jmorris@namei.org>
