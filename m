Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751914AbaDYG1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:27:18 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:54327 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbaDYG1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:27:15 -0400
Message-ID: <535A0039.3040307@linaro.org>
Date: Fri, 25 Apr 2014 11:57:05 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: kgene.kim@samsung.com, gregkh@linuxfoundation.org, t.figa@samsung.com,
        jg1.han@samsung.com, linux-kernel@vger.kernel.org, balbi@ti.com,
        robh+dt@kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 1/9] dt: exynos5420: Enable support for USB 3.0 PHY
 controller
References: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com> <1398263451-18023-2-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1398263451-18023-2-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 08:00 PM, Vivek Gautam wrote:
> Add device tree nodes for USB 3.0 PHY present alongwith
> USB 3.0 controller Exynos 5420 SoC. This phy driver is
> based on generic phy framework.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index c3a9a66..f69745f 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -732,4 +732,24 @@
>  		clock-names = "secss";
>  		samsung,power-domain = <&g2d_pd>;
>  	};
> +
> +	usbdrd_phy0: phy@12100000 {
> +		compatible = "samsung,exynos5420-usbdrd-phy";
> +		reg = <0x12100000 0x100>;
> +		clocks = <&clock CLK_USBD300>, <&clock CLK_SCLK_USBPHY300>;
> +		clock-names = "phy", "ref";
> +		samsung,pmu-syscon = <&pmu_system_controller>;

Should the property name be samsung,syscon-phandle as used elsewhere?

samsung,syscon-phandle = <&pmu_system_controller>;

> +		samsung,pmu-offset = <0x704>;
> +		#phy-cells = <1>;
> +	};
> +
> +	usbdrd_phy1: phy@12500000 {
> +		compatible = "samsung,exynos5420-usbdrd-phy";
> +		reg = <0x12500000 0x100>;
> +		clocks = <&clock CLK_USBD301>, <&clock CLK_SCLK_USBPHY301>;
> +		clock-names = "phy", "ref";
> +		samsung,pmu-syscon = <&pmu_system_controller>;

ditto

> +		samsung,pmu-offset = <0x708>;
> +		#phy-cells = <1>;
> +	};
>  };
> 


-- 
Tushar Behera
