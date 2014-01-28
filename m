Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755450AbaA1Sj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 13:39:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45216 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755412AbaA1Sj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 13:39:26 -0500
Date: Tue, 28 Jan 2014 18:38:51 +0000
From: Will Deacon <will.deacon@arm.com>
To: Christopher Covington <cov@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: hw_breakpoint: Add ARMv8 support
Message-ID: <20140128183851.GK2885@mudshark.cambridge.arm.com>
References: <1390415365-17230-1-git-send-email-cov@codeaurora.org>
 <1390933583-1278-1-git-send-email-cov@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390933583-1278-1-git-send-email-cov@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:26:23PM +0000, Christopher Covington wrote:
> Add the trivial support necessary to get hardware breakpoints
> working for GDB on ARMv8 simulators running in AArch32 mode.
> 
> Signed-off-by: Christopher Covington <cov@codeaurora.org>
> ---
> 
>  v2: modify debug_exception_updates_fsr
> 
>  arch/arm/include/asm/hw_breakpoint.h | 1 +
>  arch/arm/kernel/hw_breakpoint.c      | 3 ++-
>  2 files changed, 3 insertions(+), 1 deletion(-)
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
> index 3d44660..a711b27 100644
> --- a/arch/arm/kernel/hw_breakpoint.c
> +++ b/arch/arm/kernel/hw_breakpoint.c
> @@ -167,7 +167,7 @@ static int debug_arch_supported(void)
>  /* Can we determine the watchpoint access type from the fsr? */
>  static int debug_exception_updates_fsr(void)
>  {
> -	return 0;
> +	return get_debug_arch() == ARM_DEBUG_ARCH_V8;

I'd probably make that >= to save on future changes.

With that change:

  Acked-by: Will Deacon <will.deacon@arm.com>

Will
