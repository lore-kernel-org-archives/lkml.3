Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbbAPLSD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 06:18:03 -0500
Received: from mail.skyhub.de ([78.46.96.112]:53258 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507AbbAPLSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 06:18:01 -0500
Date: Fri, 16 Jan 2015 12:17:58 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 05/23] x86/apic: Make disable x2apic work really
Message-ID: <20150116111758.GF18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.621431109@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.621431109@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:16PM -0000, Thomas Gleixner wrote:
> If x2apic_preenabled is not enabled, then disable_x2apic() is not
> called from various places which results in x2apic_disabled not being
> set. So other code pathes can happily reenable the x2apic.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  arch/x86/kernel/apic/apic.c |   14 +++++---------
>  1 file changed, 5 insertions(+), 9 deletions(-)
> 
> Index: tip/arch/x86/kernel/apic/apic.c
> ===================================================================
> --- tip.orig/arch/x86/kernel/apic/apic.c
> +++ tip/arch/x86/kernel/apic/apic.c
> @@ -1479,8 +1479,6 @@ static bool nox2apic __initdata;
>  
>  #ifdef CONFIG_X86_X2APIC
>  int x2apic_mode;
> -/* x2apic enabled before OS handover */
> -static int x2apic_preenabled;
>  static int x2apic_disabled;
>  static int __init setup_nox2apic(char *str)
>  {
> @@ -1535,18 +1533,19 @@ static __init void disable_x2apic(void)
>  			setup_clear_cpu_cap(X86_FEATURE_X2APIC);
>  		}
>  
> -		x2apic_disabled = 1;
>  		x2apic_mode = 0;

Should we move out that write to x2apic_mode too?

>  
>  		register_lapic_address(mp_lapic_addr);
>  	}
> +
> +	x2apic_disabled = 1;

i.e., here?

Just in case.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
