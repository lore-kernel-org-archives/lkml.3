Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161062AbaDPNLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:11:38 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:56696 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756041AbaDPNLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:11:36 -0400
Date: Wed, 16 Apr 2014 15:09:15 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, chris@printf.net, anton@enomsg.org,
        zmxu@marvell.com, jszhang@marvell.com, devicetree@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@free-electrons.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: dts: berlin: add the SDHCI nodes for the BG2Q
Message-ID: <20140416130915.GC11310@lunn.ch>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397652011-21284-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1397652011-21284-4-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2014 at 02:40:10PM +0200, Antoine Ténart wrote:
> Add the SDHCI nodes for the Marvell Berlin BG2Q, using the berlin-sdhci
> driver.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  arch/arm/boot/dts/berlin2q.dtsi | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/berlin2q.dtsi b/arch/arm/boot/dts/berlin2q.dtsi
> index 5925e6a16749..8f897d461460 100644
> --- a/arch/arm/boot/dts/berlin2q.dtsi
> +++ b/arch/arm/boot/dts/berlin2q.dtsi
> @@ -67,6 +67,14 @@
>  		clock-div = <3>;
>  	};
>  
> +	sdio1clk: sdio1clk {
> +		compatible = "fixed-factor-clock";
> +		#clock-cells = <0>;
> +		clocks = <&syspll>;
> +		clock-mult = <1>;
> +		clock-div = <4>;
> +	};
> +
>  	soc {
>  		compatible = "simple-bus";
>  		#address-cells = <1>;
> @@ -75,6 +83,38 @@
>  		ranges = <0 0xf7000000 0x1000000>;
>  		interrupt-parent = <&gic>;
>  
> +		sdhci0: sdhci@ab0000 {
> +			compatible = "marvell,berlin2q-sdhci";
> +			reg = <0xab0000 0x200>;
> +			clocks = <&sdio1clk>;
> +			interrupts = <GIC_SPI 17 IRQ_TYPE_LEVEL_HIGH>;
> +			keep-power-in-suspend;
> +			enable-sdio-wakeup;
> +			broken-cd;

Hi Antoine

I would expect these three last properties to be a property of the
board, not the SoC. Or am i missing something?

       Thanks
	Andrew
