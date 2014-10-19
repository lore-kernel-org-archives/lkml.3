Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaJTAgE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 20:36:04 -0400
Received: from ozlabs.org ([103.22.144.67]:54398 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbaJTAem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 20:34:42 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ionut Alexa <ionut.m.alexa@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ionut Alexa <ionut.m.alexa@gmail.com>
Subject: Re: [PATCH] kernel:module Fix coding style errors and warnings.
In-Reply-To: <1413534771-746-1-git-send-email-ionut.m.alexa@gmail.com>
References: <1413534771-746-1-git-send-email-ionut.m.alexa@gmail.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Mon, 20 Oct 2014 10:27:46 +1030
Message-ID: <877fzva9z9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ionut Alexa <ionut.m.alexa@gmail.com> writes:
> Fixed codin style errors and warnings. Changes printk with
> print_debug/warn. Changed seq_printf to seq_puts.
>
> Signed-off-by: Ionut Alexa <ionut.m.alexa@gmail.com>

Removed the last hunk, and applied.

Thanks!
Rusty.


> ---
>  kernel/module.c |   58 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 30 insertions(+), 28 deletions(-)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 65586ff..b19ea41 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -158,13 +158,13 @@ static BLOCKING_NOTIFIER_HEAD(module_notify_list);
>   * Protected by module_mutex. */
>  static unsigned long module_addr_min = -1UL, module_addr_max = 0;
>  
> -int register_module_notifier(struct notifier_block * nb)
> +int register_module_notifier(struct notifier_block *nb)
>  {
>  	return blocking_notifier_chain_register(&module_notify_list, nb);
>  }
>  EXPORT_SYMBOL(register_module_notifier);
>  
> -int unregister_module_notifier(struct notifier_block * nb)
> +int unregister_module_notifier(struct notifier_block *nb)
>  {
>  	return blocking_notifier_chain_unregister(&module_notify_list, nb);
>  }
> @@ -740,8 +740,7 @@ static inline int try_force_unload(unsigned int flags)
>  }
>  #endif /* CONFIG_MODULE_FORCE_UNLOAD */
>  
> -struct stopref
> -{
> +struct stopref {
>  	struct module *mod;
>  	int flags;
>  	int *forced;
> @@ -877,8 +876,10 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
>  
>  	seq_printf(m, " %lu ", module_refcount(mod));
>  
> -	/* Always include a trailing , so userspace can differentiate
> -           between this and the old multi-field proc format. */
> +	/*
> +	 * Always include a trailing , so userspace can differentiate
> +	 * between this and the old multi-field proc format.
> +	 */
>  	list_for_each_entry(use, &mod->source_list, source_list) {
>  		printed_something = 1;
>  		seq_printf(m, "%s,", use->source->name);
> @@ -886,11 +887,11 @@ static inline void print_unload_info(struct seq_file *m, struct module *mod)
>  
>  	if (mod->init != NULL && mod->exit == NULL) {
>  		printed_something = 1;
> -		seq_printf(m, "[permanent],");
> +		seq_puts(m, "[permanent],");
>  	}
>  
>  	if (!printed_something)
> -		seq_printf(m, "-");
> +		seq_puts(m, "-");
>  }
>  
>  void __symbol_put(const char *symbol)
> @@ -978,7 +979,7 @@ EXPORT_SYMBOL(module_put);
>  static inline void print_unload_info(struct seq_file *m, struct module *mod)
>  {
>  	/* We don't know the usage count, or what modules are using. */
> -	seq_printf(m, " - -");
> +	seq_puts(m, " - -");
>  }
>  
>  static inline void module_unload_free(struct module *mod)
> @@ -1131,7 +1132,7 @@ static unsigned long maybe_relocated(unsigned long crc,
>  static int check_version(Elf_Shdr *sechdrs,
>  			 unsigned int versindex,
>  			 const char *symname,
> -			 struct module *mod, 
> +			 struct module *mod,
>  			 const unsigned long *crc,
>  			 const struct module *crc_owner)
>  {
> @@ -1165,7 +1166,7 @@ static int check_version(Elf_Shdr *sechdrs,
>  	return 0;
>  
>  bad_version:
> -	printk("%s: disagrees about version of symbol %s\n",
> +	pr_warn("%s: disagrees about version of symbol %s\n",
>  	       mod->name, symname);
>  	return 0;
>  }
> @@ -1200,7 +1201,7 @@ static inline int same_magic(const char *amagic, const char *bmagic,
>  static inline int check_version(Elf_Shdr *sechdrs,
>  				unsigned int versindex,
>  				const char *symname,
> -				struct module *mod, 
> +				struct module *mod,
>  				const unsigned long *crc,
>  				const struct module *crc_owner)
>  {
> @@ -1288,15 +1289,13 @@ static inline bool sect_empty(const Elf_Shdr *sect)
>  	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
>  }
>  
> -struct module_sect_attr
> -{
> +struct module_sect_attr {
>  	struct module_attribute mattr;
>  	char *name;
>  	unsigned long address;
>  };
>  
> -struct module_sect_attrs
> -{
> +struct module_sect_attrs {
>  	struct attribute_group grp;
>  	unsigned int nsections;
>  	struct module_sect_attr attrs[0];
> @@ -1550,7 +1549,8 @@ static int module_add_modinfo_attrs(struct module *mod)
>  		    (attr->test && attr->test(mod))) {
>  			memcpy(temp_attr, attr, sizeof(*temp_attr));
>  			sysfs_attr_init(&temp_attr->attr);
> -			error = sysfs_create_file(&mod->mkobj.kobj,&temp_attr->attr);
> +			error = sysfs_create_file(&mod->mkobj.kobj,
> +					&temp_attr->attr);
>  			++temp_attr;
>  		}
>  	}
> @@ -1566,7 +1566,7 @@ static void module_remove_modinfo_attrs(struct module *mod)
>  		/* pick a field to test for end of list */
>  		if (!attr->attr.name)
>  			break;
> -		sysfs_remove_file(&mod->mkobj.kobj,&attr->attr);
> +		sysfs_remove_file(&mod->mkobj.kobj, &attr->attr);
>  		if (attr->free)
>  			attr->free(mod);
>  	}
> @@ -1953,7 +1953,7 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
>  			/* We compiled with -fno-common.  These are not
>  			   supposed to happen.  */
>  			pr_debug("Common symbol: %s\n", name);
> -			printk("%s: please compile with -fno-common\n",
> +			pr_warn("%s: please compile with -fno-common\n",
>  			       mod->name);
>  			ret = -ENOEXEC;
>  			break;
> @@ -2257,7 +2257,7 @@ static char elf_type(const Elf_Sym *sym, const struct load_info *info)
>  }
>  
>  static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
> -                           unsigned int shnum)
> +			unsigned int shnum)
>  {
>  	const Elf_Shdr *sec;
>  
> @@ -2733,7 +2733,7 @@ static int find_module_sections(struct module *mod, struct load_info *info)
>  		 * This shouldn't happen with same compiler and binutils
>  		 * building all parts of the module.
>  		 */
> -		printk(KERN_WARNING "%s: has both .ctors and .init_array.\n",
> +		pr_warn("%s: has both .ctors and .init_array.\n",
>  		       mod->name);
>  		return -EINVAL;
>  	}
> @@ -3021,8 +3021,10 @@ static int do_init_module(struct module *mod)
>  	if (mod->init != NULL)
>  		ret = do_one_initcall(mod->init);
>  	if (ret < 0) {
> -		/* Init routine failed: abort.  Try to protect us from
> -                   buggy refcounters. */
> +		/*
> +		 * Init routine failed: abort.  Try to protect us from
> +		 * buggy refcounters.
> +		 */
>  		mod->state = MODULE_STATE_GOING;
>  		synchronize_sched();
>  		module_put(mod);
> @@ -3174,7 +3176,7 @@ out:
>  
>  static int unknown_module_param_cb(char *param, char *val, const char *modname)
>  {
> -	/* Check for magic 'dyndbg' arg */ 
> +	/* Check for magic 'dyndbg' arg */
>  	int ret = ddebug_dyndbg_module_param_cb(param, val, modname);
>  	if (ret != 0)
>  		pr_warn("%s: unknown parameter '%s' ignored\n", modname, param);
> @@ -3657,8 +3659,8 @@ static int m_show(struct seq_file *m, void *p)
>  
>  	/* Informative for users. */
>  	seq_printf(m, " %s",
> -		   mod->state == MODULE_STATE_GOING ? "Unloading":
> -		   mod->state == MODULE_STATE_COMING ? "Loading":
> +		   mod->state == MODULE_STATE_GOING ? "Unloading" :
> +		   mod->state == MODULE_STATE_COMING ? "Loading" :
>  		   "Live");
>  	/* Used by oprofile and other similar tools. */
>  	seq_printf(m, " 0x%pK", mod->module_core);
> @@ -3667,7 +3669,7 @@ static int m_show(struct seq_file *m, void *p)
>  	if (mod->taints)
>  		seq_printf(m, " %s", module_flags(mod, buf));
>  
> -	seq_printf(m, "\n");
> +	seq_puts(m, "\n");
>  	return 0;
>  }
>  
> @@ -3816,7 +3818,7 @@ void print_modules(void)
>  	struct module *mod;
>  	char buf[8];
>  
> -	printk(KERN_DEFAULT "Modules linked in:");
> +	pr_warn("Modules linked in:");
>  	/* Most callers should already have preempt disabled, but make sure */
>  	preempt_disable();
>  	list_for_each_entry_rcu(mod, &modules, list) {
> -- 
> 1.7.10.4
