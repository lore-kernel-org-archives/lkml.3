Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab3IECNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 22:13:30 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:54543 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab3IECN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 22:13:29 -0400
Subject: Re: [PATCH V3 01/11] Add secure_modules() call
From: joeyli <jlee@suse.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        keescook@chromium.org, hpa@zytor.com
In-Reply-To: <1378252218-18798-2-git-send-email-matthew.garrett@nebula.com>
References: <1378252218-18798-1-git-send-email-matthew.garrett@nebula.com>
	 <1378252218-18798-2-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Sep 2013 10:14:18 +0800
Message-ID: <1378347258.6380.77.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 二，2013-09-03 於 19:50 -0400，Matthew Garrett 提到：
> Provide a single call to allow kernel code to determine whether the system
> has been configured to either disable module loading entirely or to load
> only modules signed with a trusted key.
> 
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

Tested-by: Lee, Chun-Yi <jlee@suse.com>

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


