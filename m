Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129AbaAXP61 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:58:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49522 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776AbaAXP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:58:26 -0500
Date: Fri, 24 Jan 2014 15:57:52 +0000
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Add ARMv8 support
Message-ID: <20140124155752.GC31040@mudshark.cambridge.arm.com>
References: <1390415365-17230-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390415365-17230-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Wed, Jan 22, 2014 at 06:29:25PM +0000, Christopher Covington wrote:
> Add the trivial support necessary to get hardware breakpoints
> working for GDB on ARMv8 simulators running in AArch32 mode.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
>  arch/arm/include/asm/hw_breakpoint.h | 1 +
>  arch/arm/kernel/hw_breakpoint.c      | 1 +
>  2 files changed, 2 insertions(+)
> 
> diff --git a/arch/arm/include/asm/hw_breakpoint.h b/arch/arm/include/asm/hw_breakpoint.h
> index eef55ea..8e427c7 100644
> --- a/arch/arm/include/asm/hw_breakpoint.h
> +++ b/arch/arm/include/asm/hw_breakpoint.h
> @@ -51,6 +51,7 @@ static inline void decode_ctrl_reg(u32 reg,
>  #define ARM_DEBUG_ARCH_V7_ECP14	3
>  #define ARM_DEBUG_ARCH_V7_MM	4
>  #define ARM_DEBUG_ARCH_V7_1	5
> +#define ARM_DEBUG_ARCH_V8	6
>  
>  /* Breakpoint */
>  #define ARM_BREAKPOINT_EXECUTE	0
> diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
> index 3d44660..45fbcaf 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -257,6 +257,7 @@ static int enable_monitor_mode(void)
>  		break;
>  	case ARM_DEBUG_ARCH_V7_ECP14:
>  	case ARM_DEBUG_ARCH_V7_1:
> +	case ARM_DEBUG_ARCH_V8:
>  		ARM_DBG_WRITE(c0, c2, 2, (dscr | ARM_DSCR_MDBGEN));
>  		isb();
>  		break;

I'm slightly uneasy about this, mainly because I've not spent much time
looking at the AArch32 side of ARMv8 debug and I know that a fair amount
has changed since 7.1. Furthermore, the arch/arm/ kernel hasn't grown any v8
features yet and it's not clear whether that's a road down which people wish
to take it.

Anyway, assuming this works, can you please update debug_exception_updates_fsr
to return true for ARMv8 cores?

Will
