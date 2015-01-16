Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbbAPKuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:50:21 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49633 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249AbbAPKuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:50:18 -0500
Date: Fri, 16 Jan 2015 11:50:15 +0100
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiang Liu <jiang.liu@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Tony Luck <tony.luck@intel.com>
Subject: Re: [patch 02/23] x86/apic: Make x2apic_mode depend on
 CONFIG_X86_X2APIC
Message-ID: <20150116105015.GB18880@pd.tnic>
References: <20150115210458.625399149@linutronix.de>
 <20150115211702.363274310@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150115211702.363274310@linutronix.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 09:22:11PM -0000, Thomas Gleixner wrote:
> No point in having a static variable around which is always 0. Let the
> compiler optimize code out if disabled.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <bp@suse.de>

> ---
>  arch/x86/include/asm/apic.h |    8 ++++----
>  arch/x86/kernel/apic/apic.c |    2 +-
>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> Index: tip/arch/x86/include/asm/apic.h
> ===================================================================
> --- tip.orig/arch/x86/include/asm/apic.h
> +++ tip/arch/x86/include/asm/apic.h
> @@ -106,8 +106,6 @@ extern u32 native_safe_apic_wait_icr_idl
>  extern void native_apic_icr_write(u32 low, u32 id);
>  extern u64 native_apic_icr_read(void);
>  
> -extern int x2apic_mode;
> -
>  static inline bool apic_is_x2apic_enabled(void)
>  {
>  	u64 msr;
> @@ -177,6 +175,7 @@ static inline u64 native_x2apic_icr_read
>  	return val;
>  }
>  
> +extern int x2apic_mode;
>  extern int x2apic_phys;
>  extern int x2apic_preenabled;
>  extern void check_x2apic(void);
> @@ -209,8 +208,9 @@ static inline void x2apic_force_phys(voi
>  {
>  }
>  
> -#define	x2apic_preenabled 0
> -#define	x2apic_supported()	0
> +#define x2apic_mode		(0)
> +#define	x2apic_preenabled	(0)

Btw, while you're at it, you can kill this yet another knob
x2apic_preenabled and use check_x2apic() directly. There are just too
many useless knobs in there.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
