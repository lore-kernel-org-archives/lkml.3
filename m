Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3LUDzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 22:55:16 -0500
Received: from ozlabs.org ([203.10.76.45]:46702 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859Ab3LUDzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 22:55:14 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Seunghun Lee <waydi1@gmail.com>
Cc: linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: Re: [PATCH] module: fix coding style
In-Reply-To: <1387381612-15968-1-git-send-email-waydi1@gmail.com>
References: <1387381612-15968-1-git-send-email-waydi1@gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Sat, 21 Dec 2013 11:23:19 +1030
Message-ID: <87zjnvkosf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seunghun Lee <waydi1@gmail.com> writes:
> Fix coding style of module.h

Thanks, applied.

Cheers,
Rusty.

>
> Signed-off-by: Seunghun Lee <waydi1@gmail.com>
> ---
>  include/linux/module.h |   62 ++++++++++++++++++++++++------------------------
>  1 file changed, 31 insertions(+), 31 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 46e548f..eaf60ff 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -29,8 +29,7 @@
>  
>  #define MODULE_NAME_LEN MAX_PARAM_PREFIX_LEN
>  
> -struct modversion_info
> -{
> +struct modversion_info {
>  	unsigned long crc;
>  	char name[MODULE_NAME_LEN];
>  };
> @@ -84,12 +83,12 @@ void sort_main_extable(void);
>  void trim_init_extable(struct module *m);
>  
>  #ifdef MODULE
> -#define MODULE_GENERIC_TABLE(gtype,name)			\
> +#define MODULE_GENERIC_TABLE(gtype, name)			\
>  extern const struct gtype##_id __mod_##gtype##_table		\
>    __attribute__ ((unused, alias(__stringify(name))))
>  
>  #else  /* !MODULE */
> -#define MODULE_GENERIC_TABLE(gtype,name)
> +#define MODULE_GENERIC_TABLE(gtype, name)
>  #endif
>  
>  /* Generic info of form tag = "info" */
> @@ -126,7 +125,7 @@ extern const struct gtype##_id __mod_##gtype##_table		\
>   * is a GPL combined work.
>   *
>   * This exists for several reasons
> - * 1.	So modinfo can show license info for users wanting to vet their setup 
> + * 1.	So modinfo can show license info for users wanting to vet their setup
>   *	is free
>   * 2.	So the community can ignore bug reports including proprietary modules
>   * 3.	So vendors can do likewise based on their own policies
> @@ -138,27 +137,29 @@ extern const struct gtype##_id __mod_##gtype##_table		\
>   * authors use multiple MODULE_AUTHOR() statements/lines.
>   */
>  #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)
> -  
> +
>  /* What your module does. */
>  #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
>  
> -#define MODULE_DEVICE_TABLE(type,name)		\
> -  MODULE_GENERIC_TABLE(type##_device,name)
> +#define MODULE_DEVICE_TABLE(type, name)		\
> +  MODULE_GENERIC_TABLE(type##_device, name)
>  
>  /* Version of form [<epoch>:]<version>[-<extra-version>].
> -   Or for CVS/RCS ID version, everything but the number is stripped.
> -  <epoch>: A (small) unsigned integer which allows you to start versions
> -           anew. If not mentioned, it's zero.  eg. "2:1.0" is after
> -	   "1:2.0".
> -  <version>: The <version> may contain only alphanumerics and the
> -           character `.'.  Ordered by numeric sort for numeric parts,
> -	   ascii sort for ascii parts (as per RPM or DEB algorithm).
> -  <extraversion>: Like <version>, but inserted for local
> -           customizations, eg "rh3" or "rusty1".
> -
> -  Using this automatically adds a checksum of the .c files and the
> -  local headers in "srcversion".
> -*/
> + * Or for CVS/RCS ID version, everything but the number is stripped.
> + * <epoch>: A (small) unsigned integer which allows you to start versions
> + * anew. If not mentioned, it's zero.  eg. "2:1.0" is after
> + * "1:2.0".
> +
> + * <version>: The <version> may contain only alphanumerics and the
> + * character `.'.  Ordered by numeric sort for numeric parts,
> + * ascii sort for ascii parts (as per RPM or DEB algorithm).
> +
> + * <extraversion>: Like <version>, but inserted for local
> + * customizations, eg "rh3" or "rusty1".
> +
> + * Using this automatically adds a checksum of the .c files and the
> + * local headers in "srcversion".
> + */
>  
>  #if defined(MODULE) || !defined(CONFIG_SYSFS)
>  #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
> @@ -226,8 +227,7 @@ struct module_ref {
>  	unsigned long decs;
>  } __attribute((aligned(2 * sizeof(unsigned long))));
>  
> -struct module
> -{
> +struct module {
>  	enum module_state state;
>  
>  	/* Member of list of modules */
> @@ -480,8 +480,8 @@ static inline void module_put(struct module *module)
>  static inline void __module_get(struct module *module)
>  {
>  }
> -#define symbol_put(x) do { } while(0)
> -#define symbol_put_addr(p) do { } while(0)
> +#define symbol_put(x) do { } while (0)
> +#define symbol_put_addr(p) do { } while (0)
>  
>  #endif /* CONFIG_MODULE_UNLOAD */
>  int ref_module(struct module *a, struct module *b);
> @@ -507,8 +507,8 @@ int lookup_module_symbol_attrs(unsigned long addr, unsigned long *size, unsigned
>  /* For extable.c to search modules' exception tables. */
>  const struct exception_table_entry *search_module_extables(unsigned long addr);
>  
> -int register_module_notifier(struct notifier_block * nb);
> -int unregister_module_notifier(struct notifier_block * nb);
> +int register_module_notifier(struct notifier_block *nb);
> +int unregister_module_notifier(struct notifier_block *nb);
>  
>  extern void print_modules(void);
>  
> @@ -548,8 +548,8 @@ static inline bool is_module_text_address(unsigned long addr)
>  
>  /* Get/put a kernel symbol (calls should be symmetric) */
>  #define symbol_get(x) ({ extern typeof(x) x __attribute__((weak)); &(x); })
> -#define symbol_put(x) do { } while(0)
> -#define symbol_put_addr(x) do { } while(0)
> +#define symbol_put(x) do { } while (0)
> +#define symbol_put_addr(x) do { } while (0)
>  
>  static inline void __module_get(struct module *module)
>  {
> @@ -606,13 +606,13 @@ static inline int module_kallsyms_on_each_symbol(int (*fn)(void *, const char *,
>  	return 0;
>  }
>  
> -static inline int register_module_notifier(struct notifier_block * nb)
> +static inline int register_module_notifier(struct notifier_block *nb)
>  {
>  	/* no events will happen anyway, so this can always succeed */
>  	return 0;
>  }
>  
> -static inline int unregister_module_notifier(struct notifier_block * nb)
> +static inline int unregister_module_notifier(struct notifier_block *nb)
>  {
>  	return 0;
>  }
> -- 
> 1.7.9.5
