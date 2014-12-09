Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756500AbaLIK1n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 05:27:43 -0500
Received: from gloria.sntech.de ([95.129.55.99]:49210 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755326AbaLIK1l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 05:27:41 -0500
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Yunzhi Li <lyz@rock-chips.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 4/5] ARM: dts: add rk3288 usb PHY
Date: Tue, 09 Dec 2014 11:26:21 +0100
Message-ID: <1433902.kJO8gnlzYm@phil>
User-Agent: KMail/4.14.2 (Linux/3.16-3-amd64; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1418093554-30671-1-git-send-email-lyz@rock-chips.com>
References: <1418093554-30671-1-git-send-email-lyz@rock-chips.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Am Dienstag, 9. Dezember 2014, 10:52:34 schrieb Yunzhi Li:
> This patch adds a device_node for RK3288 SoC usb phy. It also
> defines the phy to be used by three usb controllers: usb_host0/1
> and usb_otg.
> 
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> 
> ---
> 
> Changes in v4:
> - Add phy subnodes.
> 
> Changes in v3: None
> 
>  arch/arm/boot/dts/rk3288.dtsi | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
> index 874e66d..2db2d12 100644
> --- a/arch/arm/boot/dts/rk3288.dtsi
> +++ b/arch/arm/boot/dts/rk3288.dtsi
> @@ -329,12 +329,35 @@
>  		status = "disabled";
>  	};
> 
> +	usbphy: phy {

the nodes in the dts are ordered by address, please move it accordingly. I 
guess a good position might be to have the "phy" before the "pinctrl" node.

Also please reorder the properties a bit to have the "compatible" at the top 
of the list, like

		compatible = "rockchip,rk3288-usb-phy";
		rockchip,grf = <&grf>;
		#phy-cells = <1>;
		#address-cells = <1>;
		#size-cells = <0>;
		status = "disabled";

		subnodes...


Thanks
Heiko

> +		#phy-cells = <1>;
> +		#address-cells = <1>;
> +		#size-cells = <0>;
> +		compatible = "rockchip,rk3288-usb-phy";
> +		rockchip,grf = <&grf>;
> +		status = "disabled";
> +
> +		usb-phy@0 {
> +			reg = <0>;
> +		};
> +
> +		usb-phy@1 {
> +			reg = <1>;
> +		};
> +
> +		usb-phy@2 {
> +			reg = <2>;
> +		};
> +	};
> +
>  	usb_host0_ehci: usb@ff500000 {
>  		compatible = "generic-ehci";
>  		reg = <0xff500000 0x100>;
>  		interrupts = <GIC_SPI 24 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks = <&cru HCLK_USBHOST0>;
>  		clock-names = "usbhost";
> +		phys = <&usbphy 1>;
> +		phy-names = "usb";
>  		status = "disabled";
>  	};
> 
> @@ -347,6 +370,8 @@
>  		interrupts = <GIC_SPI 25 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks = <&cru HCLK_USBHOST1>;
>  		clock-names = "otg";
> +		phys = <&usbphy 2>;
> +		phy-names = "usb2-phy";
>  		status = "disabled";
>  	};
> 
> @@ -357,6 +382,8 @@
>  		interrupts = <GIC_SPI 23 IRQ_TYPE_LEVEL_HIGH>;
>  		clocks = <&cru HCLK_OTG0>;
>  		clock-names = "otg";
> +		phys = <&usbphy 0>;
> +		phy-names = "usb2-phy";
>  		status = "disabled";
>  	};

