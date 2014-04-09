Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbaDILLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:11:16 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:11078 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932761AbaDILLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:11:12 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-06-53452ace876f
Message-id: <53452ACA.1040008@samsung.com>
Date: Wed, 09 Apr 2014 13:11:06 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org, kishon@ti.com
Cc: gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        k.debski@samsung.com, jg1.han@samsung.com,
        sylvester.nawrocki@gmail.com
Subject: Re: [PATCH V4 3/5] dt: exynos5420: Enable support for DWC3 controller
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-4-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396967803-28868-4-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsVy+t/xy7rntFyDDY6s4LM4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymZx4WkPm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCwW
	LWtltpj3eSeTA5/Hzll32T32z13D7rF5Sb1H35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjf
	LoEro33bI/aCW3wVzVe+szQwruXuYuTkkBAwkfj+bT8bhC0mceHeeiCbi0NIYCmjxNu5TewQ
	zmdGiUftPYwgVbwCWhIP1q0G62ARUJV4+eAQO4jNJqAm8bnhEVicH6hmTdN1FhBbVCBC4l7j
	YVaIXkGJH5PvsYAMFRH4ySjxrrEHLMEs0McocfqELYgtLOAncWjKPVaIze1Am+9uA9vAKeAp
	cfjfFWaIBmuJlZO2MULY8hKb17xlnsAoOAvJkllIymYhKVvAyLyKUTS1NLmgOCk911CvODG3
	uDQvXS85P3cTIySevuxgXHzM6hCjAAejEg+vgqVLsBBrYllxZe4hRgkOZiUR3udsrsFCvCmJ
	lVWpRfnxRaU5qcWHGJk4OKUaGHkff8o5dld0wvNzV3X1O99d0PptMM/u2EvPfRNXVNy6fCDR
	+1zwS9fnL1xfyr6vNnhr+271hA3yV6I9nOUE5rs/vHyePeqfSlzhR4PGwqKe1VsrGxsqM7r/
	ad5h/zNd01DKxUTA/d76x5tLTsQ0Pon/7c+1Juh9C9Mf/krd6f9iF1w/tG3JySdKLMUZiYZa
	zEXFiQBUo9C4hQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2014 16:36, Vivek Gautam wrote:
> Add device tree nodes for DWC3 controller present on
> Exynos 5420 SoC, to enable support for USB 3.0.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>   arch/arm/boot/dts/exynos5420.dtsi |   34 ++++++++++++++++++++++++++++++++++
>   1 file changed, 34 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index a6efb52..20c2d0b 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -653,6 +653,23 @@
>   		clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>   	};
>
> +	usb@12000000 {
> +		compatible = "samsung,exynos5250-dwusb3";
> +		clocks = <&clock 366>;
> +		clock-names = "usbdrd30";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		dwc3 {
> +			compatible = "synopsys,dwc3";
> +			reg = <0x12000000 0x10000>;
> +			interrupts = <0 72 0>;
> +			phys = <&usbdrd_phy0 0>, <&usbdrd_phy0 1>;
> +			phy-names = "usb2-phy", "usb3-phy";
> +		};
> +	};
> +
>   	usbdrd_phy0: phy@12100000 {
>   		compatible = "samsung,exynos5420-usbdrd-phy";
>   		reg = <0x12100000 0x100>;
> @@ -663,6 +680,23 @@
>   		#phy-cells = <1>;
>   	};
>
> +	usb@12400000 {
> +		compatible = "samsung,exynos5250-dwusb3";
> +		clocks = <&clock 367>;
> +		clock-names = "usbdrd30";
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		ranges;
> +
> +		dwc3 {
> +			compatible = "synopsys,dwc3";
> +			reg = <0x12400000 0x10000>;
> +			interrupts = <0 73 0>;
> +			phys = <&usbdrd_phy1 0>, <&usbdrd_phy1 1>;
> +			phy-names = "usb2-phy", "usb3-phy";
> +		};
> +	};
> +
>   	usbdrd_phy1: phy@12500000 {
>   		compatible = "samsung,exynos5420-usbdrd-phy";
>   		reg = <0x12500000 0x100>;
>

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz

