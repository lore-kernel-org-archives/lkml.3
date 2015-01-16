Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763AbbAPL4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:56:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52215 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754490AbbAPL4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:56:38 -0500
Date: Fri, 16 Jan 2015 12:56:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 07/23] x86/x2apic: Move code in conditional region
Message-ID: <20150116115635.GH18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.795388613@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.795388613@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:19PM -0000, Thomas Gleixner wrote:
> No point in having try_to_enable_x2apic() outside of the
> CONFIG_X86_X2APIC section and having inline functions and more ifdefs
> to deal with it. Move the code into the existing ifdef section and
> remove the inline cruft.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/include/asm/apic.h |   20 ++-----------
>  arch/x86/kernel/apic/apic.c |   65 +++++++++++++++++++++-----------------------
>  2 files changed, 35 insertions(+), 50 deletions(-)

...

> +#ifdef CONFIG_X86_IO_APIC
> +	if (!x2apic_enabled() && skip_ioapic_setup) {
> +		pr_info("Skipped enabling intr-remap because of skipping "
> +			"io-apic setup\n");

Let's correct this message while we're here:

		pr_info("Not enabling interrupt remapping due to skipped IO-APIC setup.\n");

> +		return -1;
> +	}
>  #endif
> +	return irq_remapping_enable();
>  }
>  
>  void __init enable_IR_x2apic(void)
> 
> 
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
