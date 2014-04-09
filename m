Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933089AbaDILLk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 07:11:40 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:18104 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932560AbaDILLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 07:11:34 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-5f-53452ae2ae31
Message-id: <53452ADE.2000609@samsung.com>
Date: Wed, 09 Apr 2014 13:11:26 +0200
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
Subject: Re: [PATCH V4 4/5] dt: exynos5250: Enable support for generic USB DRD
 phy
References: <1396967803-28868-1-git-send-email-gautam.vivek@samsung.com>
 <1396967803-28868-5-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1396967803-28868-5-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xK7qPtFyDDf6/Z7M4eL/eYv6Rc6wW
	bVcOsls0L17PZnF54SVWix+vL7BZ9C64ymZx4WkPm8Wmx9dYLRa2LWGxuLxrDpvFjPP7mCwW
	LWtltpj3eSeTA5/Hzll32T32z13D7rF5Sb1H35ZVjB7Hb2xn8vi8SS6ALYrLJiU1J7MstUjf
	LoErY/LEmIKFHBU9uy+wNTBeYOti5OCQEDCROH5XpIuRE8gUk7hwbz1QmItDSGApo8TyrRPY
	IZzPjBILX3xlA6niFdCSWDV1KSuIzSKgKjHzTi+YzSagJvG54RFYDT9QzZqm6ywgtqhAhMS9
	xsOsEL2CEj8m32MBGSoi8JNR4l1jD1iCWaCPUeL0CVsQW1ggRKLn1R2oM9oZJX6t/sMIkuAU
	8JSYsPscM0SDtcTKSdsYIWx5ic1r3jJPYBSchWTJLCRls5CULWBkXsUomlqaXFCclJ5rqFec
	mFtcmpeul5yfu4kREktfdjAuPmZ1iFGAg1GJh1fB0iVYiDWxrLgy9xCjBAezkgjvczbXYCHe
	lMTKqtSi/Pii0pzU4kOMTBycUg2MGQvviz38krJMv3bF5eCZP4TPLexIfFSacl+8MbtoNVPe
	Le2OG4pByo9u/o4rb2C5ef+Snayt678j2yfz+59L9ymyjvq3xDpV/MSytKS3xsYvP3zfK6Jw
	XOelirTPrP/TOOZsfm1lGFz28Un6pudzlpxTnmq+7/1K+YROn6yLmVfZ2K7P0+MwV2Ipzkg0
	1GIuKk4EAK7hOlaDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.04.2014 16:36, Vivek Gautam wrote:
> Add device tree node for new usbdrd-phy driver, which
> is based on generic phy framework.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>   arch/arm/boot/dts/exynos5250.dtsi |   10 ++++++++++
>   1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index b7dec41..92c6fcd 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -530,6 +530,16 @@
>   		};
>   	};
>
> +	usbdrd_phy: phy@12100000 {
> +		compatible = "samsung,exynos5250-usbdrd-phy";
> +		reg = <0x12100000 0x100>;
> +		clocks = <&clock 286>, <&clock 1>;
> +		clock-names = "phy", "ref";
> +		samsung,syscon-phandle = <&pmu_system_controller>;
> +		samsung,pmu-offset = <0x704>;
> +		#phy-cells = <1>;
> +	};
> +
>   	usb@12110000 {
>   		compatible = "samsung,exynos4210-ehci";
>   		reg = <0x12110000 0x100>;
>

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

--
Best regards,
Tomasz
