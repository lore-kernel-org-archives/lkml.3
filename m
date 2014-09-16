Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757790AbaIPAkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 20:40:19 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34647 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbaIPAkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 20:40:16 -0400
Date: Tue, 16 Sep 2014 09:40:06 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: shmobile: r8a7740 legacy: Add missing INTCA
 clock for irqpin module
Message-ID: <20140916004006.GC26557@verge.net.au>
References: <1410527720-18061-1-git-send-email-geert+renesas@glider.be>
 <1410527720-18061-4-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410527720-18061-4-git-send-email-geert+renesas@glider.be>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 03:15:19PM +0200, Geert Uytterhoeven wrote:
> This clock drives the irqpin controller modules.
> Before, it was assumed enabled by the bootloader or reset state.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Thanks, I have queued this up.

> ---
>  arch/arm/mach-shmobile/clock-r8a7740.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-shmobile/clock-r8a7740.c b/arch/arm/mach-shmobile/clock-r8a7740.c
> index 0794f0426e70..6cb1de220612 100644
> --- a/arch/arm/mach-shmobile/clock-r8a7740.c
> +++ b/arch/arm/mach-shmobile/clock-r8a7740.c
> @@ -455,7 +455,7 @@ enum {
>  	MSTP128, MSTP127, MSTP125,
>  	MSTP116, MSTP111, MSTP100, MSTP117,
>  
> -	MSTP230,
> +	MSTP230, MSTP229,
>  	MSTP222,
>  	MSTP218, MSTP217, MSTP216, MSTP214,
>  	MSTP207, MSTP206, MSTP204, MSTP203, MSTP202, MSTP201, MSTP200,
> @@ -479,6 +479,7 @@ static struct clk mstp_clks[MSTP_NR] = {
>  	[MSTP100] = SH_CLK_MSTP32(&div4_clks[DIV4_B],	SMSTPCR1,  0, 0), /* LCDC0 */
>  
>  	[MSTP230] = SH_CLK_MSTP32(&div6_clks[DIV6_SUB],	SMSTPCR2, 30, 0), /* SCIFA6 */
> +	[MSTP229] = SH_CLK_MSTP32(&div6_clks[DIV4_HP],	SMSTPCR2, 29, 0), /* INTCA */
>  	[MSTP222] = SH_CLK_MSTP32(&div6_clks[DIV6_SUB],	SMSTPCR2, 22, 0), /* SCIFA7 */
>  	[MSTP218] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],  SMSTPCR2, 18, 0), /* DMAC1 */
>  	[MSTP217] = SH_CLK_MSTP32(&div4_clks[DIV4_HP],  SMSTPCR2, 17, 0), /* DMAC2 */
> @@ -575,6 +576,10 @@ static struct clk_lookup lookups[] = {
>  	CLKDEV_DEV_ID("sh-dma-engine.0",	&mstp_clks[MSTP218]),
>  	CLKDEV_DEV_ID("sh-sci.7",		&mstp_clks[MSTP222]),
>  	CLKDEV_DEV_ID("e6cd0000.serial",	&mstp_clks[MSTP222]),
> +	CLKDEV_DEV_ID("renesas_intc_irqpin.0",	&mstp_clks[MSTP229]),
> +	CLKDEV_DEV_ID("renesas_intc_irqpin.1",	&mstp_clks[MSTP229]),
> +	CLKDEV_DEV_ID("renesas_intc_irqpin.2",	&mstp_clks[MSTP229]),
> +	CLKDEV_DEV_ID("renesas_intc_irqpin.3",	&mstp_clks[MSTP229]),
>  	CLKDEV_DEV_ID("sh-sci.6",		&mstp_clks[MSTP230]),
>  	CLKDEV_DEV_ID("e6cc0000.serial",	&mstp_clks[MSTP230]),
>  
> -- 
> 1.9.1
> 
