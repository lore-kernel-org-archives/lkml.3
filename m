Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaFXKSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 06:18:11 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53638 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752533AbaFXKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 06:18:08 -0400
Date: Tue, 24 Jun 2014 11:18:02 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: addy ke <addy.ke@rock-chips.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "yzq@rock-chips.com" <yzq@rock-chips.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "zhenfu.fang@rock-chips.com" <zhenfu.fang@rock-chips.com>,
        "olof@lixom.net" <olof@lixom.net>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/2] documentation: add rockchip spi documentation
Message-ID: <20140624101802.GE5856@leverpostej>
References: <1403582324-9485-1-git-send-email-addy.ke@rock-chips.com>
 <1403582324-9485-2-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403582324-9485-2-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 04:58:43AM +0100, addy ke wrote:
> Signed-off-by: addy ke <addy.ke@rock-chips.com>
> ---
>  .../devicetree/bindings/spi/spi-rockchip.txt       | 51 ++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/spi/spi-rockchip.txt
> 
> diff --git a/Documentation/devicetree/bindings/spi/spi-rockchip.txt b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
> new file mode 100644
> index 0000000..ce9c881
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/spi/spi-rockchip.txt
> @@ -0,0 +1,51 @@
> +* Rockchip SPI Controller
> +
> +The Rockchip SPI controller is used to interface with various devices such as flash
> +and display controllers using the SPI communication interface.
> +
> +Required SoC Specific Properties:
> +
> +- compatible: should be one of the following.
> +    - rockchip,rk3066-spi: for rk3066, rk3188 and rk3288 platforms.

Are you sure you don't want specifc strings for rk3188 and rk3288 (in
addtion to the common "rockchip,rk3066-spi")?

> +- reg: physical base address of the controller and length of memory mapped
> +       region.
> +- interrupts: The interrupt number to the cpu. The interrupt specifier format
> +              depends on the interrupt controller.
> +- clocks: Must contain an entry for each entry in clock-names.
> +- clock-names: Shall be "spiclk" for the transfer-clock, and "apb_pclk" for
> +			   the peripheral clock.
> +
> +Optional properties:
> +- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
> +		Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names: DMA request names should include "tx" and "rx" if present.
> +
> +Example:
> +
> +- SoC Specific Portion:
> +
> +	spi0: spi@ff110000 {
> +		compatible = "rockchip,rockchip-spi";

This does not match the description of the compatible property.

> +		reg = <0xff110000 0x1000>;
> +		dmas = <&pdma1 11>, <&pdma1 12>;
> +		dma-names = "tx", "rx";
> +		#address-cells = <1>;
> +		#size-cells = <0>;

These weren't mentioned.

> +		interrupts = <GIC_SPI 44 IRQ_TYPE_LEVEL_HIGH>;
> +		pinctrl-names = "default";
> +		pinctrl-0 = <&spi0_clk &spi0_tx &spi0_rx &spi0_cs0 &spi0_cs1>;

pinctrl was not mentioned.

> +		clocks = <&cru SCLK_SPI0>, <&cru PCLK_SPI0>;
> +		clock-names = "spiclk", "apb_pclk";
> +		status = "disabled";

Any reason for the status?

> +	};
> +
> +- Board Specific Portion:
> +
> +	&spi0 {
> +		status = "okay";
> +		spi_test@00 {
> +			compatible = "rockchip,spi_test";

Huh?

Mark.
