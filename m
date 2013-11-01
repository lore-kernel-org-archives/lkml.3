Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022Ab3KAT4l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 15:56:41 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:61360 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab3KAT4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 15:56:39 -0400
Message-ID: <52741581.9020106@cogentembedded.com>
Date: Fri, 01 Nov 2013 23:56:33 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Matt Porter <matt.porter@linaro.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Paul Zimmerman <paulz@synopsys.com>
CC: Linux USB List <linux-usb@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linaro Patches <patches@linaro.org>
Subject: Re: [PATCH v2 9/9] ARM: dts: add usb udc support to bcm281xx
References: <1383335158-19730-1-git-send-email-matt.porter@linaro.org> <1383335158-19730-10-git-send-email-matt.porter@linaro.org>
In-Reply-To: <1383335158-19730-10-git-send-email-matt.porter@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/01/2013 10:45 PM, Matt Porter wrote:

> Adds USB OTG/PHY and clock support to BCM281xx and enables
> UDC support on the bcm11351-brt and bcm28155-ap boards.

> Signed-off-by: Matt Porter <matt.porter@linaro.org>
> Reviewed-by: Markus Mayer <markus.mayer@linaro.org>
> Reviewed-by: Tim Kryger <tim.kryger@linaro.org>
> ---
>   arch/arm/boot/dts/bcm11351-brt.dts |  6 ++++++
>   arch/arm/boot/dts/bcm11351.dtsi    | 18 ++++++++++++++++++
>   arch/arm/boot/dts/bcm28155-ap.dts  |  8 ++++++++
>   3 files changed, 32 insertions(+)

[...]
> diff --git a/arch/arm/boot/dts/bcm11351.dtsi b/arch/arm/boot/dts/bcm11351.dtsi
> index 0755f43..247f9fd 100644
> --- a/arch/arm/boot/dts/bcm11351.dtsi
> +++ b/arch/arm/boot/dts/bcm11351.dtsi
> @@ -284,4 +284,22 @@
>   			#clock-cells = <0>;
>   		};
>   	};
> +
> +	usbotg: usbotg@3f120000 {

    According to ePAPR spec [1], the node name should be "usb@3f120000".


> +		compatible = "snps,dwc2";
> +		reg = <0x3f120000 0x10000>;
> +		interrupts = <GIC_SPI 47 IRQ_TYPE_LEVEL_HIGH>;
> +		clocks = <&usb_otg_ahb_clk>;
> +		clock-names = "otg";
> +		phys = <&usbphy>;
> +		phy-names = "usb2-phy";
> +		status = "disabled";
> +	};
> +
> +	usbphy: usbphy@3f130000 {

    This one should probably be named "usb-phy@3f130000", just like 
"ethernet-phy" from the ePAPR spec.

> +		compatible = "brcm,kona-usb2-phy";
> +		reg = <0x3f130000 0x28>;
> +		#phy-cells = <0>;
> +		status = "disabled";
> +	};
>   };

[1] http://www.power.org/resources/downloads/Power_ePAPR_APPROVED_v1.0.pdf

WBR, Sergei

