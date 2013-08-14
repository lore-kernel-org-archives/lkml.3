Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562Ab3HNORP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 10:17:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:40104 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757871Ab3HNORO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 10:17:14 -0400
Message-ID: <520B9144.5000701@ti.com>
Date: Wed, 14 Aug 2013 19:46:36 +0530
From: George Cherian <george.cherian@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, <benoit.cousson@linaro.org>,
        <a-kishore@ti.com>, <afzal@ti.com>, <linux-kernel@vger.kernel.org>,
        <balbi@ti.com>, <bcousson@baylibre.com>
Subject: Re: [PATCH v3] arm: dts: AM43x: Add usb DT nodes for AM4372
References: <1373444082-4169-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373444082-4169-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Benoit
  If you dont have any comments, can you take this for 3.12?

Regards
-George

On 7/10/2013 1:44 PM, George Cherian wrote:

> This patch adds
> 	- HS USB nodes
> 	- phy nodes
> 	- usb control module nodes.
>
> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>
> changes from v2
> change synopsis to snps
> use simple node names
> add both USB and PHY instances
> add usbctrl node
>
> changes from v1
> renamed synopsis to snps
> removed flag tx-fifo-resize
>
>   arch/arm/boot/dts/am4372.dtsi | 58 +++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 58 insertions(+)
>
> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index ddc1df7..37f196f 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -64,5 +64,63 @@
>   			compatible = "ti,am4372-counter32k","ti,omap-counter32k";
>   			reg = <0x44e86000 0x40>;
>   		};
> +
> +		phy1: usbphy1 {
> +			compatible = "ti,am4372-usb2";
> +			#phy-cells = <0>;
> +			id = <0>;
> +			status = "disabled";
> +		};
> +
> +		phy2: usbphy2 {
> +			compatible = "ti,am4372-usb2";
> +			#phy-cells = <0>;
> +			id = <1>;
> +			status = "disabled";
> +		};
> +
> +		usbctrl: omap-control-usb@44e10620 {
> +			compatible = "ti,omap-control-usb";
> +			reg = <0x44e10620 0x10>;
> +			reg-names = "control_dev_conf";
> +			ti,type = <3>;
> +			status = "disabled";
> +		};
> +
> +		usb1: am4372_dwc3@48380000 {
> +			status = "disabled";
> +			compatible = "ti,am4372-dwc3";
> +			reg = <0x48380000 0x200>;
> +			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <1>;
> +			ranges;
> +			dwc3@48390000 {
> +				compatible = "snps,dwc3";
> +				reg = <0x48390000 0xd000>;
> +				interrupts = <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
> +				phys = <&phy1>;
> +				phy-names = "am4372-usb1";
> +			};
> +		};
> +
> +		usb2: am4372_dwc3@483c0000 {
> +			status = "disabled";
> +			compatible = "ti,am4372-dwc3";
> +			reg = <0x483c0000 0x200>;
> +			interrupts = <GIC_SPI 178 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <1>;
> +			ranges;
> +			dwc3@483d0000 {
> +				compatible = "snps,dwc3";
> +				reg = <0x483d0000 0xd000>;
> +				interrupts = <GIC_SPI  174 IRQ_TYPE_LEVEL_HIGH>;
> +				phys = <&phy2>;
> +				phy-names = "am4372-usb2";
> +			};
> +		};
>   	};
>   };


-- 
-George

