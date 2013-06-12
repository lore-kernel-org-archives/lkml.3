Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757561Ab3FLRrB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 13:47:01 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45943 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab3FLRq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 13:46:59 -0400
Date: Wed, 12 Jun 2013 10:46:58 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/3] ARM: msm: Move debug-macro.S to include/debug
Message-ID: <20130612174658.GC10823@codeaurora.org>
References: <1371001686-15985-1-git-send-email-sboyd@codeaurora.org>
 <1371001686-15985-2-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371001686-15985-2-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11, Stephen Boyd wrote:
> diff --git a/arch/arm/mach-msm/io.c b/arch/arm/mach-msm/io.c
> index efa113e..284cc56 100644
> --- a/arch/arm/mach-msm/io.c
> +++ b/arch/arm/mach-msm/io.c
> @@ -52,10 +52,6 @@ static struct map_desc msm_io_desc[] __initdata = {
>  	MSM_CHIP_DEVICE_TYPE(GPIO1, MSM7X00, MT_DEVICE_NONSHARED),
>  	MSM_CHIP_DEVICE_TYPE(GPIO2, MSM7X00, MT_DEVICE_NONSHARED),
>  	MSM_DEVICE_TYPE(CLK_CTL, MT_DEVICE_NONSHARED),
> -#if defined(CONFIG_DEBUG_MSM_UART1) || defined(CONFIG_DEBUG_MSM_UART2) || \
> -	defined(CONFIG_DEBUG_MSM_UART3)
> -	MSM_DEVICE_TYPE(DEBUG_UART, MT_DEVICE_NONSHARED),
> -#endif

Hmm debug_ll_io_init() uses MT_DEVICE so I think I'll add a dummy
entry here and fill in the address with debug_ll_addr.

>  	{
>  		.virtual =  (unsigned long) MSM_SHARED_RAM_BASE,
>  		.pfn = __phys_to_pfn(MSM_SHARED_RAM_PHYS),
> @@ -71,6 +67,7 @@ void __init msm_map_common_io(void)
>  	 * pages are peripheral interface or not.
>  	 */
>  	asm("mcr p15, 0, %0, c15, c2, 4" : : "r" (0));
> +	debug_ll_io_init();
>  	iotable_init(msm_io_desc, ARRAY_SIZE(msm_io_desc));
>  }
>  #endif

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
