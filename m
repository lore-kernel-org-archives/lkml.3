Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758670AbaD3KZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 06:25:24 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:33461 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbaD3KZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 06:25:22 -0400
Message-ID: <5360CF8A.5010809@gmail.com>
Date: Wed, 30 Apr 2014 15:55:14 +0530
From: Arun Kumar K <arunkk.samsung@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
CC: devicetree@vger.kernel.org, k.debski@samsung.com, kgene.kim@samsung.com,
        p.paneri@samsung.com, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org, kishon@ti.com, stern@rowland.harvard.edu,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] ARM: dts: Add usb2phy support on exynos5420
References: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com> <1398848110-6152-4-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1398848110-6152-4-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 04/30/14 14:25, Vivek Gautam wrote:
> Add required device node for usb2phy to let enable USB 2.0
> support.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index cfa3755..16b860a 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -737,4 +737,14 @@
>  		clock-names = "secss";
>  		samsung,power-domain = <&g2d_pd>;
>  	};
> +
> +	phy@12130000 {

As we will be changing over to reference-based updation of nodes in the
board dts files, it would be good to add node reference also while
adding new nodes. Like : usb_phy: phy@12130000 {

Regards
Arun

> +		compatible = "samsung,exynos5250-usb2-phy";
> +		reg = <0x12130000 0x100>;
> +		clocks = <&clock CLK_USBH20>, <&clock CLK_SCLK_USBPHY300>;
> +		clock-names = "phy", "ref";
> +		#phy-cells = <1>;
> +		samsung,sysreg-phandle = <&sysreg_system_controller>;
> +		samsung,pmureg-phandle = <&pmu_system_controller>;
> +	};
>  };
> 
