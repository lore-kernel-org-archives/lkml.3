Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752611Ab3FXQAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 12:00:32 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:52030
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751784Ab3FXQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 12:00:30 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Mon, 24 Jun 2013 08:58:16 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk/zynq/clkc: Add CLK_SET_RATE_PARENT flag to ethernet
 muxes
References: <1371509260-2340-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1371509260-2340-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b79e12d1-dd4b-407c-b3c1-46d7d66292e8@CO1EHSMHS017.ehs.local>
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Mon, Jun 17, 2013 at 03:47:40PM -0700, Soren Brinkmann wrote:
> Zynq's Ethernet clocks are created by the following hierarchy:
> 	mux0 ---> div0 ---> div1 ---> mux1 ---> gate
> Rate change requests on the gate have to propagate all the way up to
> div0 to properly leverage all dividers. Mux1 was missing the
> CLK_SET_RATE_PARENT flag, which is required to achieve this.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  drivers/clk/zynq/clkc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/clk/zynq/clkc.c b/drivers/clk/zynq/clkc.c
> index 515a573..089d3e3 100644
> --- a/drivers/clk/zynq/clkc.c
> +++ b/drivers/clk/zynq/clkc.c
> @@ -365,8 +365,9 @@ static void __init zynq_clk_setup(struct device_node *np)
>  			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 20, 6,
>  			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
>  			&gem0clk_lock);
> -	clk = clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2, 0,
> -			SLCR_GEM0_CLK_CTRL, 6, 1, 0, &gem0clk_lock);
> +	clk = clk_register_mux(NULL, "gem0_emio_mux", gem0_mux_parents, 2,
> +			CLK_SET_RATE_PARENT, SLCR_GEM0_CLK_CTRL, 6, 1, 0,
> +			&gem0clk_lock);
>  	clks[gem0] = clk_register_gate(NULL, clk_output_name[gem0],
>  			"gem0_emio_mux", CLK_SET_RATE_PARENT,
>  			SLCR_GEM0_CLK_CTRL, 0, 0, &gem0clk_lock);
> @@ -387,8 +388,9 @@ static void __init zynq_clk_setup(struct device_node *np)
>  			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 20, 6,
>  			CLK_DIVIDER_ONE_BASED | CLK_DIVIDER_ALLOW_ZERO,
>  			&gem1clk_lock);
> -	clk = clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2, 0,
> -			SLCR_GEM1_CLK_CTRL, 6, 1, 0, &gem1clk_lock);
> +	clk = clk_register_mux(NULL, "gem1_emio_mux", gem1_mux_parents, 2,
> +			CLK_SET_RATE_PARENT, SLCR_GEM1_CLK_CTRL, 6, 1, 0,
> +			&gem1clk_lock);
>  	clks[gem1] = clk_register_gate(NULL, clk_output_name[gem1],
>  			"gem1_emio_mux", CLK_SET_RATE_PARENT,
>  			SLCR_GEM1_CLK_CTRL, 0, 0, &gem1clk_lock);
> -- 
> 1.8.3.1
> 
> 


