Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaDYGbP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:31:15 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:36038 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaDYGbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:31:12 -0400
Message-ID: <535A0125.9020207@linaro.org>
Date: Fri, 25 Apr 2014 12:01:01 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: kgene.kim@samsung.com, gregkh@linuxfoundation.org, t.figa@samsung.com,
        jg1.han@samsung.com, linux-kernel@vger.kernel.org, balbi@ti.com,
        robh+dt@kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5 3/9] dt: exynos5250: Enable support for generic USB
 DRD phy
References: <1398263451-18023-1-git-send-email-gautam.vivek@samsung.com> <1398263451-18023-4-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1398263451-18023-4-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2014 08:00 PM, Vivek Gautam wrote:
> Add device tree node for new usbdrd-phy driver, which
> is based on generic phy framework.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 3742331..d4254c0 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -551,6 +551,16 @@
>  		};
>  	};
>  
> +	usbdrd_phy: phy@12100000 {
> +		compatible = "samsung,exynos5250-usbdrd-phy";
> +		reg = <0x12100000 0x100>;
> +		clocks = <&clock CLK_USB3>, <&clock CLK_FIN_PLL>;
> +		clock-names = "phy", "ref";
> +		samsung,pmu-syscon = <&pmu_system_controller>;

Replace samsung,pmu-syscon by samsung,syscon-phandle ?

> +		samsung,pmu-offset = <0x704>;
> +		#phy-cells = <1>;
> +	};
> +
>  	usb@12110000 {
>  		compatible = "samsung,exynos4210-ehci";
>  		reg = <0x12110000 0x100>;
> 


-- 
Tushar Behera
