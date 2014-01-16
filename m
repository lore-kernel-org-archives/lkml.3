Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751756AbaAPSSV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:18:21 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:48071 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbaAPSST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:18:19 -0500
Date: Thu, 16 Jan 2014 12:15:28 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-sunxi@googlegroups.com, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] ARM: sun6i: dt: Add PLL6 and SPI module clocks
Message-ID: <20140116181528.GY8153@joshc.qualcomm.com>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
 <1389892285-11745-3-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389892285-11745-3-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 06:11:23PM +0100, Maxime Ripard wrote:
> The module clocks in the A31 are still compatible with the A10 one. Add the SPI
> module clocks and the PLL6 in the device tree to allow their use by the SPI
> controllers.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  arch/arm/boot/dts/sun6i-a31.dtsi | 48 +++++++++++++++++++++++++++++++---------
>  1 file changed, 38 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/sun6i-a31.dtsi b/arch/arm/boot/dts/sun6i-a31.dtsi
> index 5256ad9..ae058eb 100644
> --- a/arch/arm/boot/dts/sun6i-a31.dtsi
> +++ b/arch/arm/boot/dts/sun6i-a31.dtsi
> @@ -73,16 +73,12 @@
>  			clocks = <&osc24M>;
>  		};
>  
> -		/*
> -		 * This is a dummy clock, to be used as placeholder on
> -		 * other mux clocks when a specific parent clock is not
> -		 * yet implemented. It should be dropped when the driver
> -		 * is complete.
> -		 */
> -		pll6: pll6 {
> -			#clock-cells = <0>;
> -			compatible = "fixed-clock";
> -			clock-frequency = <0>;
> +		pll6: clk@01c20028 {
> +			#clock-cells = <1>;
> +			compatible = "allwinner,sun6i-a31-pll6-clk";
> +			reg = <0x01c20028 0x4>;
> +			clocks = <&osc24M>;
> +			clock-output-names = "pll6";
>  		};
>  
>  		cpu: cpu@01c20050 {
> @@ -182,6 +178,38 @@
>  					"apb2_uart1", "apb2_uart2", "apb2_uart3",
>  					"apb2_uart4", "apb2_uart5";
>  		};
> +
> +		spi0_clk: clk@01c200a0 {
> +			#clock-cells = <0>;
> +			compatible = "allwinner,sun4i-mod0-clk";
> +			reg = <0x01c200a0 0x4>;
> +			clocks = <&osc24M>, <&pll6>;

This looks weird.  You've set the pll6 #clock-cells = <1>, but you
aren't using a specifier here.  Same below, as well.  The binding
documentation indicates that #clock-cells should be 0 for the pll6 node.

  Josh

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
