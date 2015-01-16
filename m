Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbbAPTB7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 14:01:59 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49544 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752885AbbAPTB5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 14:01:57 -0500
Date: Fri, 16 Jan 2015 20:01:54 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 13/23] x86/smpboot: Move smpboot inlines to code
Message-ID: <20150116190154.GN18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211703.304126687@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211703.304126687@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:29PM -0000, Thomas Gleixner wrote:
> No point for a seperate header file.

s/seperate/separate/

> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/smpboot_hooks.h |   68 -----------------------------------
>  arch/x86/kernel/smpboot.c            |   67 +++++++++++++++++++++++++++++++++-
>  2 files changed, 66 insertions(+), 69 deletions(-)

...

> +static inline void __init smpboot_setup_io_apic(void)
> +{
> +#ifdef CONFIG_X86_IO_APIC
> +	/*
> +	 * Here we can be sure that there is an IO-APIC in the system. Let's
> +	 * go and set it up:
> +	 */
> +	if (!skip_ioapic_setup && nr_ioapics)
> +		setup_IO_APIC();
> +	else {
> +		nr_ioapics = 0;
> +	}

No need for those braces.

> +#endif
> +}
> +
> +static inline void smpboot_clear_io_apic(void)
> +{
> +#ifdef CONFIG_X86_IO_APIC
> +	nr_ioapics = 0;
> +#endif
> +}
> +
>  /*
>   * Report back to the Boot Processor during boot time or to the caller processor
>   * during CPU online.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
