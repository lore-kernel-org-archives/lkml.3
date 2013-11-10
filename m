Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab3KJOyT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 09:54:19 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:58523 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3KJOyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 09:54:16 -0500
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org,
        k.debski@samsung.com, kgene.kim@samsung.com, linux-doc@vger.kernel.org,
        gregkh@linuxfoundation.org, t.figa@samsung.com, jg1.han@samsung.com,
        linux-kernel@vger.kernel.org, balbi@ti.com, kishon@ti.com,
        s.nawrocki@samsung.com, jwerner@chromium.org
Subject: Re: [PATCH 2/4] dt: exynos5250: Enable support for generic USB 3.0 phy
Date: Sun, 10 Nov 2013 15:54:13 +0100
Message-ID: <1538612.pj7iqCuQ7M@flatron>
User-Agent: KMail/4.11.3 (Linux/3.12.0-gentoo; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1383205544-32244-3-git-send-email-gautam.vivek@samsung.com>
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com> <1383205544-32244-3-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Thursday 31 of October 2013 13:15:42 Vivek Gautam wrote:
> Update device tree bindings for DWC3 controller and
> USB 3.0 phy present on Exynos 5250 SoC, to start using
> the phy driver based on generic phy framework.
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5250.dtsi |   17 ++++++-----------
>  1 files changed, 6 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
> index bbac42a..31a6595 100644
> --- a/arch/arm/boot/dts/exynos5250.dtsi
> +++ b/arch/arm/boot/dts/exynos5250.dtsi
> @@ -472,22 +472,17 @@
>  			compatible = "synopsys,dwc3";
>  			reg = <0x12000000 0x10000>;
>  			interrupts = <0 72 0>;
> -			usb-phy = <&usb2_phy &usb3_phy>;
> +			phys = <&usb3_phy>;
> +			phy-names = "usb3-phy";

Does the driver already support generic PHY framework?

Also it looks like originally it required two PHYs, while your patch
changes it to just one.

>  		};
>  	};
>  
>  	usb3_phy: usbphy@12100000 {
>  		compatible = "samsung,exynos5250-usb3phy";

Hmm, this is not fully right. The new bindings should have new compatible
value. This is also a comment to patch 1/1. This is because a device tree
binding associated with specific compatible value is an ABI and should not
be changed in a way that breaks backwards compatibility.

Best regards,
Tomasz

