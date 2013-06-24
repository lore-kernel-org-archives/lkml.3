Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044Ab3FXP6V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:58:21 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:50627
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750973Ab3FXP6S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:58:18 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh146fI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Mon, 24 Jun 2013 08:58:05 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk/zynq/clkc: Add dedicated spinlock for the SWDT
References: <1371506626-3892-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1371506626-3892-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <fe16e203-47cf-4465-8a9d-3c3e516d2d5e@VA3EHSMHS028.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Mon, Jun 17, 2013 at 03:03:46PM -0700, Soren Brinkmann wrote:
> The clk_mux for the system watchdog timer reused the register lock
> dedicated to the Ethernet module - for no apparent reason.
> Add a lock dedicated to the SWDT's clock register to remove this
> wrong dependency.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> I don't know how this slipped in...
> Anyway, the fix depends on armsoc/zynq/clk.
> 
> 	Sören
> 
>  drivers/clk/zynq/clkc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index 5c205b6..515a573 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -71,6 +71,7 @@ static DEFINE_SPINLOCK(armpll_lock);
>  static DEFINE_SPINLOCK(ddrpll_lock);
>  static DEFINE_SPINLOCK(iopll_lock);
>  static DEFINE_SPINLOCK(armclk_lock);
> +static DEFINE_SPINLOCK(swdtclk_lock);
>  static DEFINE_SPINLOCK(ddrclk_lock);
>  static DEFINE_SPINLOCK(dciclk_lock);
>  static DEFINE_SPINLOCK(gem0clk_lock);
> @@ -293,7 +294,7 @@ static void __init zynq_clk_setup(struct device_node *np)
>  	}
>  	clks[swdt] = clk_register_mux(NULL, clk_output_name[swdt],
>  			swdt_ext_clk_mux_parents, 2, CLK_SET_RATE_PARENT,
> -			SLCR_SWDT_CLK_SEL, 0, 1, 0, &gem0clk_lock);
> +			SLCR_SWDT_CLK_SEL, 0, 1, 0, &swdtclk_lock);
>  
>  	/* DDR clocks */
>  	clk = clk_register_divider(NULL, "ddr2x_div", "ddrpll", 0,
> -- 
> 1.8.3.1
> 
> 

