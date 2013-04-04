Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933123Ab3DDDIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 23:08:48 -0400
Received: from ozlabs.org ([203.10.76.45]:47645 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759809Ab3DDDIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 23:08:46 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sebastian Wankerl <sisewank@cip.cs.fau.de>, linux-kernel@vger.kernel.org
Cc: Sebastian Wankerl <sisewank@cip.cs.fau.de>,
        Philip Kranz <philip.kranz@googlemail.com>
Subject: Re: [PATCH] Add non-zero module sections to sysfs
In-Reply-To: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de>
References: <1364994499-23708-1-git-send-email-sisewank@cip.cs.fau.de>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 04 Apr 2013 11:30:38 +1030
Message-ID: <87mwtf3ya1.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Wankerl <sisewank@cip.cs.fau.de> writes:
> Add non-zero module sections to sysfs on architectures unequal to PARISC.
> KGDB needs all module sections for proper module debugging. Therefore, commit 
> 35dead4235e2b67da7275b4122fed37099c2f462 is revoked except for PARISC
> architecture.

#ifdef CONFIG_PARISC in the middle of kernel/module.c is super-ugly, and
wrong.

My preference would be to fix kgdb.  If the section is empty, what need
does it have to examine it?

Thanks,
Rusty.

> Signed-off-by: Sebastian Wankerl <sisewank@cip.cs.fau.de>
> Signed-off-by: Philip Kranz <philip.kranz@googlemail.com>
>
> ---
>  kernel/module.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/module.c b/kernel/module.c
> index 3c2c72d..5393a54 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -1316,7 +1316,11 @@ resolve_symbol_wait(struct module *mod,
>  #ifdef CONFIG_KALLSYMS
>  static inline bool sect_empty(const Elf_Shdr *sect)
>  {
> +#if defined(CONFIG_PARISC)
>  	return !(sect->sh_flags & SHF_ALLOC) || sect->sh_size == 0;
> +#else
> +	return !(sect->sh_flags & SHF_ALLOC);
> +#endif
>  }
>  
>  struct module_sect_attr
> -- 
> 1.7.10.4
