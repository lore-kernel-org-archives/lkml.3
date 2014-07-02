Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaGBHSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:18:24 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:35513 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaGBHSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:18:22 -0400
Message-ID: <53B3B233.5000307@hitachi.com>
Date: Wed, 02 Jul 2014 16:18:11 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Tony Luck <tony.luck@gmail.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, rdunlap@infradead.org,
        Anoop Thomas Mathew <atm@profoundis.com>,
        Arnd Bergmann <arnd@arndb.de>, akataria@vmware.com,
        yrl.pp-manager.tt@hitachi.com,
        Linus Torvalds <torvalds@linux-foundation.org>, sparse@chrisli.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        anil.s.keshavamurthy@intel.com,
        "David S. Miller" <davem@davemloft.net>,
        Chris Wright <chrisw@sous-sol.org>, linux-tip-commits@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, dl9pf@gmx.de,
        Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v5 1/2] kprobes/powerpc: Fix arch_deref_entry_point
 to support ABIv2
References: <1404276081.7254.1.camel@concordia> <20140702070022.14689.7254.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140702070022.14689.7254.stgit@kbuild-fedora.novalocal>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/02 16:00), Masami Hiramatsu wrote:
> Since PowerPC64 ABIv2 doesn't have function descriptor
> any more, arch_deref_entry_point(), which returns function
> entry point from function descriptor, should be updated.

Please ignore this patch, since it is already fixed by Michael

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2f0143c91d30823f6f6e7d94d7fa818f7ab18a18

We only need 2/2.

Thank you,



> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Anoop Thomas Mathew <atm@profoundis.com>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/kernel/kprobes.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/kernel/kprobes.c b/arch/powerpc/kernel/kprobes.c
> index 90fab64..72a1034 100644
> --- a/arch/powerpc/kernel/kprobes.c
> +++ b/arch/powerpc/kernel/kprobes.c
> @@ -491,7 +491,12 @@ int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
>  	return ret;
>  }
>  
> -#ifdef CONFIG_PPC64
> +#if defined(CONFIG_PPC64) && (!defined(_CALL_ELF) || _CALL_ELF == 1)
> +/*
> + * On PPC64 ABIv1 the function pointer actually points to the
> + * function's descriptor. The first entry in the descriptor is the
> + * address of the function text.
> + */
>  unsigned long arch_deref_entry_point(void *entry)
>  {
>  	return ((func_descr_t *)entry)->entry;
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


