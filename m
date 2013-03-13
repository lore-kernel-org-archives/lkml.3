Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755153Ab3CMGcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 02:32:00 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:58139 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3CMGb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 02:31:59 -0400
Date: Wed, 13 Mar 2013 07:31:57 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-next@vger.kernel.org
Subject: Re: [RFC -next] linux/linkage.h: fix symbol prefix handling
Message-ID: <20130313063157.GB19681@merkur.ravnborg.org>
References: <1362656642-2693-1-git-send-email-james.hogan@imgtec.com> <87sj46wyf2.fsf@rustcorp.com.au> <5139AC39.90805@imgtec.com> <874ngiwije.fsf@rustcorp.com.au> <20130311230731.0c610d86569d09f6e23b8e61@canb.auug.org.au> <87ppz5usts.fsf@rustcorp.com.au> <20130312233300.9d86d47bb5369923ad520a21@canb.auug.org.au> <87ehfkuq27.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ehfkuq27.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> actually, y'know, proof-read it.
Hmm..


> +                   $(KERNELRELEASE) "$(patsubst y,_,$(CONFIG_HAVE_SYMBOL_PREFIX_UNDERSCORE))"
>  
> +config HAVE_UNDERSCORE_SYMBOL_PREFIX

HAVE_UNDERSCORE_... or HAVE_SYMBOL_... confusion.
I prefer the HAVE_SYMBOL_... variant but no strong feelings..

> + *
> + * If you think the above arrogance just encourages more people to add
> + * random crap to this file, you're not alone.
Kill this.

>  /* Some toolchains use a `_' prefix for all user symbols. */
> -#ifdef CONFIG_SYMBOL_PREFIX
> -#define MODULE_SYMBOL_PREFIX CONFIG_SYMBOL_PREFIX
> +#ifdef CONFIG_HAVE_UNDERSCORE_SYMBOL_PREFIX
> +#define __VMLINUX_SYMBOL(x) _##x
> +#define __VMLINUX_SYMBOL_STR(x) "_" #x
> +#define VMLINUX_SYMBOL_PREFIX_STR "_"
>  #else
> -#define MODULE_SYMBOL_PREFIX ""
> +#define __VMLINUX_SYMBOL(x) x
> +#define __VMLINUX_SYMBOL_STR(x) #x
> +#define VMLINUX_SYMBOL_PREFIX_STR ""
>  #endif

We know the prefix is an underscore. No benefits from defining
VMLINUX_SYMBOL_PREFIX_STR. The config name even syas so.
Skipping the above give us only one way to check
for the prefix - today we mix the two.

	Sam

