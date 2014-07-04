Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742AbaGDQzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:55:41 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41085 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752836AbaGDQzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:55:39 -0400
Date: Fri, 4 Jul 2014 17:55:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: jianqun <xjq@rock-chips.com>
Cc: "heiko@sntech.de" <heiko@sntech.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "perex@perex.cz" <perex@perex.cz>, "tiwai@suse.de" <tiwai@suse.de>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "zhangqing@rock-chips.com" <zhangqing@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "yzq@rock-chips.com" <yzq@rock-chips.com>,
        "zhenfu.fang@rock-chips.com" <zhenfu.fang@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "kfx@rock-chips.com" <kfx@rock-chips.com>
Subject: Re: [PATCH v2 1/2] ASoC: dt-bindings: add rockchip i2s bindings
Message-ID: <20140704165531.GD7106@leverpostej>
References: <1404203860-30712-2-git-send-email-xjq@rock-chips.com>
 <1404458796-6818-1-git-send-email-xjq@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404458796-6818-1-git-send-email-xjq@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 08:26:36AM +0100, jianqun wrote:
> From: Jianqun Xu <xjq@rock-chips.com>
> 
> Add devicetree bindings for i2s controller found on
> rk3066, rk3188 and rk3288 processors from rockchip.
> 
> Signed-off-by: Jianqun Xu <xjq@rock-chips.com>
> ---
> Changes since v1:
> - modify the description of clock-names property, adviced by Mark Rutland.
> - modify the example to fit for rk3288.
> 
>  .../devicetree/bindings/sound/rockchip-i2s.txt     |   36 ++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/sound/rockchip-i2s.txt
> 
> diff --git a/Documentation/devicetree/bindings/sound/rockchip-i2s.txt b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
> new file mode 100644
> index 0000000..9fc577d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/sound/rockchip-i2s.txt
> @@ -0,0 +1,36 @@
> +* Rockchip I2S controller
> +
> +The I2S bus (Inter-IC sound bus) is a serial link for digital
> +audio data transfer between devices in the system.
> +
> +Required properties:
> +
> +- compatible: should be one of the followings
> +   - "rockchip,rk3066-i2s": for rk3066
> +   - "rockchip,rk3188-i2s", "rockchip,rk3066-i2s": for rk3188
> +   - "rockchip,rk3288-i2s", "rockchip,rk3066-i2s": for rk3288
> +- reg: physical base address of the controller and length of memory mapped
> +  region.
> +- interrupts: The interrupt number to the cpu. The interrupt specifier format
> +  depends on the interrupt controller.

Just state _which_ interrupt this is from the view of the device.

> +- #address-cells: should be 1.
> +- #size-cells: should be 0.
> +- dmas: DMA specifiers for tx and rx dma. See the DMA client binding,
> +	Documentation/devicetree/bindings/dma/dma.txt
> +- dma-names: DMA request names should include "tx" and "rx" if present.

Just say:

- dma-names: should include "tx" and "rx"

If we need more DMAs or descriptions thereof, expand into a bulleted
list.

> +- clocks: a list of phandle + clock-specifer pairs, one for each entry in clock-names.
> +- clock-names: Shall be "i2s_hclk" for I2S bus and "i2s_clk" for master clock

This was easier to read as a bulleted list than inline:

- clock-names: should include:
  - "i2s_hclk" for the I2S bus clock
  - "i2s_clk" for the master clock

> +
> +Example, for rk3288 I2S controller:
> +
> +i2s0: i2s@ff890000 {
> +	compatible = "rockchip,rk3066-i2s", "rockchip,rk3288-i2s";

This is the wrong way around per the documentation of the compatible
string.

Thanks,
Mark.

> +	reg = <0xff890000 0x10000>;
> +	interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
> +	#address-cells = <1>;
> +	#size-cells = <0>;
> +	dmas = <&pdma1 0>, <&pdma1 1>;
> +	dma-names = "rx", "tx";
> +	clock-names = "i2s_hclk", "i2s_clk";
> +	clocks = <&cru HCLK_I2S0>, <&cru SCLK_I2S0>;
> +};
> -- 
> 1.7.9.5
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
