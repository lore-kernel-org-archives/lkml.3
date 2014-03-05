Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaCEMn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 07:43:57 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38580 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbaCEMnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 07:43:52 -0500
Message-ID: <53171BC9.8050808@ti.com>
Date: Wed, 5 Mar 2014 18:12:49 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <bcousson@baylibre.com>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <george.cherian@ti.com>, <heikki.krogerus@linux.intel.com>,
        <rogerq@ti.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <devicetree@vger.kernel.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <linux@arm.linux.org.uk>, <gregkh@linuxfoundation.org>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>
Subject: Re: [PATCH v5 6/6] arm/dts: added dt properties to adapt to the new
 phy framwork
References: <1393846695-14644-1-git-send-email-kishon@ti.com> <1393846695-14644-7-git-send-email-kishon@ti.com>
In-Reply-To: <1393846695-14644-7-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony/Benoit,

On Monday 03 March 2014 05:08 PM, Kishon Vijay Abraham I wrote:
> Added device tree bindings for dwc3, usb2 and usb3 PHYs. The documentation
> of these can be found at Documentation/devicetree/bindings/phy/phy-bindings.txt
> and Documentation/devicetree/bindings/phy/ti-phy.txt.

Can this patch be queued for 3.15 merge window?

Thanks
Kishon

>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   arch/arm/boot/dts/omap5.dtsi |    5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index a72813a..1c68558 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -732,7 +732,8 @@
>   				compatible = "snps,dwc3";
>   				reg = <0x4a030000 0x10000>;
>   				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
> -				usb-phy = <&usb2_phy>, <&usb3_phy>;
> +				phys = <&usb2_phy>, <&usb3_phy>;
> +				phy-names = "usb2-phy", "usb3-phy";
>   				dr_mode = "peripheral";
>   				tx-fifo-resize;
>   			};
> @@ -749,6 +750,7 @@
>   				compatible = "ti,omap-usb2";
>   				reg = <0x4a084000 0x7c>;
>   				ctrl-module = <&omap_control_usb2phy>;
> +				#phy-cells = <0>;
>   			};
>
>   			usb3_phy: usb3phy@4a084400 {
> @@ -758,6 +760,7 @@
>   				      <0x4a084c00 0x40>;
>   				reg-names = "phy_rx", "phy_tx", "pll_ctrl";
>   				ctrl-module = <&omap_control_usb3phy>;
> +				#phy-cells = <0>;
>   			};
>   		};
>
>
