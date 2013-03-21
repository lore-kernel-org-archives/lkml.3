Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab3CUNzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 09:55:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60012 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334Ab3CUNzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 09:55:40 -0400
Message-ID: <514B1154.1020100@ti.com>
Date: Thu, 21 Mar 2013 15:55:32 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <balbi@ti.com>, <rnayak@ti.com>, <t-kristo@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP4: clock: Initialize USB DPLL
References: <1363873705-3224-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1363873705-3224-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2013 03:48 PM, Roger Quadros wrote:
> If the bootloader doesn't configure USB DPLL (e.g. in u-boot,
> disable CONFIG_USB_EHCI_OMAP), then we get all sorts of problems
> like
> - division by zero errors at boot [1]
> - USB DPLL fails to enter locked state
> - USB EHCI Host is non functional
> - Device can't enter OFF mode
> 
> Initializing the USB DPLL fixes all these issues.
> 
> [1]
> 
> [    0.000000] clock: dpll_usb_ck failed transition to 'locked'
> [    0.000000] Division by zero in kernel.
> [    0.000000] [<c001b00c>] (unwind_backtrace+0x0/0xf0) from [<c02b2378>] (Ldiv0+0x8/0x10)
> [    0.000000] [<c02b2378>] (Ldiv0+0x8/0x10) from [<c041cf3c>] (clk_divider_set_rate+0x10/0x124)
> [    0.000000] [<c041cf3c>] (clk_divider_set_rate+0x10/0x124) from [<c041bfc4>] (clk_change_rate+0x3c/0xb4)
> [    0.000000] [<c041bfc4>] (clk_change_rate+0x3c/0xb4) from [<c041c028>] (clk_change_rate+0xa0/0xb4)
> 
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  arch/arm/mach-omap2/cclock44xx_data.c |   19 +++++++++++++++++++
>  1 files changed, 19 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/cclock44xx_data.c b/arch/arm/mach-omap2/cclock44xx_data.c
> index bfc46c1..6127bb9 100644
> --- a/arch/arm/mach-omap2/cclock44xx_data.c
> +++ b/arch/arm/mach-omap2/cclock44xx_data.c
> @@ -53,6 +53,12 @@
>   */
>  #define OMAP4_DPLL_ABE_DEFFREQ				98304000
>  
> +/*
> + * OMAP4450 TRM Rev X, section "3.6.3.9.5 DPLL_USB Preferred Settings"

4460 actually.

cheers,
-roger
