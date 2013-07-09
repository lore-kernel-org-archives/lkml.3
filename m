Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3GIOH5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:07:57 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:54711 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab3GIOHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 10:07:55 -0400
Message-ID: <51DC1937.9080302@cogentembedded.com>
Date: Tue, 09 Jul 2013 18:07:51 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        afzal@ti.com, linux@arm.linux.org.uk, balbi@ti.com,
        linux-kernel@vger.kernel.org, benoit.cousson@linaro.org
Subject: Re: [PATCH v2] arm: dts: AM43x: Add usb_otg_hs node
References: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
In-Reply-To: <1373361446-30050-1-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-07-2013 13:17, George Cherian wrote:

> Adds device node for HS USB Host module for AM437x

> changes from v1

> renamed synopsis to snps
> removed flag tx-fifo-resize

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   arch/arm/boot/dts/am4372.dtsi | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)

> diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
> index ddc1df7..c9e0da8 100644
> --- a/arch/arm/boot/dts/am4372.dtsi
> +++ b/arch/arm/boot/dts/am4372.dtsi
> @@ -64,5 +64,23 @@
>   			compatible = "ti,am4372-counter32k","ti,omap-counter32k";
>   			reg = <0x44e86000 0x40>;
>   		};
> +
> +		usb_otg_hs1: am4372_dwc3@48380000 {

    See http://www.devicetree.org/Device_Tree_Usage, "Node Names" section.

> +			compatible = "ti,am437x-dwc3";
> +			reg = <0x48380000 0x1ff>;
> +			interrupts = <GIC_SPI 172 IRQ_TYPE_LEVEL_HIGH>;
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			utmi-mode = <1>;
> +			ranges;
> +
> +			dwc3@48390000 {

    The same comment.

> +				compatible = "snps,dwc3";
> +				reg = <0x48390000 0xcfff>;
> +				interrupts = <GIC_SPI  168 IRQ_TYPE_LEVEL_HIGH>;
> +			};
> +
> +		};
> +		

WBR, Sergei


