Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab3LDMui (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 07:50:38 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60569 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3LDMug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 07:50:36 -0500
X-AuditID: cbfee61a-b7f796d000004313-cf-529f25193e0e
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        rob.herring@calxeda.com, kgene.kim@samsung.com, kishon@ti.com,
        jg1.han@samsung.com, s.nawrocki@samsung.com, t.figa@samsung.com,
        jwerner@chromium.org, k.debski@samsung.com
Subject: Re: [PATCH v2 2/4] dt: exynos5250: Enable support for generic USB 3.0
 phy
Date: Wed, 04 Dec 2013 13:50:12 +0100
Message-id: <2442031.907VFG2eGN@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <1386151747-3209-3-git-send-email-gautam.vivek@samsung.com>
References: <1386151747-3209-1-git-send-email-gautam.vivek@samsung.com>
 <1386151747-3209-3-git-send-email-gautam.vivek@samsung.com>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEIsWRmVeSWpSXmKPExsVy+t9jQV0p1flBBgt3slscvF9vcWD2Q1aL
	tisH2S2aF69ns7i88BKrRcehx0wWP15fYLPoXXCVzeLC0x42i4VtS1gsLu+aw2Yx4/w+JotF
	y1qZLQ6vOMBkcfhNO6vF+hmvWRwEPBZ8vsLuMbvhIovH/rlr2D3Oz1jI6NG3ZRWjx/Eb25k8
	Pm+SC2CP4rJJSc3JLEst0rdL4Mo41jKfveATT8WpZcUNjH1cXYycHBICJhIf189mhLDFJC7c
	W8/WxcjFISQwnVHi/P4NLBBOC5PEmdnTWUGq2ASsJCa2rwLrEBHQltg+dxIrSBGzwD8miV3n
	7oIVCQuESPxunsfUxcjBwSKgKvHvAjtImFdAU+L6jxksILaogKfEju0r2UBsTgEPiZ4b79gh
	lrUySjR/WQXVICjxY/I9sAZmAXmJffunskLYOhL7W6exTWAUmIWkbBaSsllIyhYwMq9iFE0t
	SC4oTkrPNdQrTswtLs1L10vOz93ECI6pZ1I7GFc2WBxiFOBgVOLhTeCcFyTEmlhWXJl7iFGC
	g1lJhLdPcX6QEG9KYmVValF+fFFpTmrxIUZpDhYlcd4DrdaBQgLpiSWp2ampBalFMFkmDk6p
	Bsapx7pctG1mb4pK+aB9YA9rNauzvfmW5m17mabIs2wRXvL08jPn6CqGiPdbXh28GnFdc6m2
	fdUtOZmabr/3q98c+yhncTRB5tDmzbedygQVDkXv7l/KFBFV9GjiN6UGz3l78hWb7lTuV74h
	ckfk6HXl7HDFf0ZubVbLNt9Y88HGfdLUD4LNlXOVWIozEg21mIuKEwFkzwD1pQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Does the old phy-samsung-usb3 driver currently work on Exynos5250?  If yes,
then this patch should be merged with patch #1 to preserve bisectability.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

On Wednesday, December 04, 2013 03:39:05 PM Vivek Gautam wrote:
> Update device tree bindings for DWC3 controller and
> USB 3.0 phy present on Exynos 5250 SoC, to start using
> the phy driver based on generic phy framework.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   16 ++++++----------
>  1 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index 9db5047..7444717 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -475,22 +475,18 @@
>  			compatible = "synopsys,dwc3";
>  			reg = <0x12000000 0x10000>;
>  			interrupts = <0 72 0>;
> -			usb-phy = <&usb2_phy &usb3_phy>;
> +			phys = <&usb3_phy>;
> +			phy-names = "usb3-phy";
>  		};
>  	};
>  
>  	usb3_phy: usbphy@12100000 {
>  		compatible = "samsung,exynos5250-usb3phy";
>  		reg = <0x12100000 0x100>;
> -		clocks = <&clock 1>, <&clock 286>;
> -		clock-names = "ext_xtal", "usbdrd30";
> -		#address-cells = <1>;
> -		#size-cells = <1>;
> -		ranges;
> -
> -		usbphy-sys {
> -			reg = <0x10040704 0x8>;
> -		};
> +		clocks = <&clock 286>, <&clock 1>;
> +		clock-names = "phy", "usb3phy_refclk";
> +		samsung,syscon-phandle = <&pmu_syscon>;
> +		#phy-cells = <0>;
>  	};
>  
>  	usb@12110000 {

