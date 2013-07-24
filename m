Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab3GXOR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:17:28 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:46186 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189Ab3GXORY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:17:24 -0400
MIME-Version: 1.0
In-Reply-To: <000101ce5c51$887309f0$99591dd0$@samsung.com>
References: <000101ce5c51$887309f0$99591dd0$@samsung.com>
Date: Wed, 24 Jul 2013 23:17:23 +0900
Message-ID: <CADoNuNeax8N1TNRN66-k1fnxxpZCPRUH4Me2VehSDfJzfyq+Zg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: dts: Add USB Host nodes to Exynos4210
From: Dongjin Kim <tobetter@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,

I had submitted another patch almost similar contents, but my patch
contains both EHCI and OHCI USB host devices node in exynos4.dtsi
since I had tested on Exynos4412 and their register map are same with
Exynos4210.

[1] https://patchwork.kernel.org/patch/2832779

On Wed, May 29, 2013 at 6:47 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> Add device nodes for USB Host EHCI and OHCI controllers to Exynos4210.
>
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> ---
> Tested on Exynos4210.
>
>  arch/arm/boot/dts/exynos4210.dtsi |   18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
>
> diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
> index 366795a..3c173c7 100644
> --- a/arch/arm/boot/dts/exynos4210.dtsi
> +++ b/arch/arm/boot/dts/exynos4210.dtsi
> @@ -117,6 +117,24 @@
>                 status = "disabled";
>         };
>
> +       usb@12580000 {
> +               compatible = "samsung,exynos4210-ehci";
> +               reg = <0x12580000 0x100>;
> +               interrupts = <0 70 0>;
> +
> +               clocks = <&clock 304>;
> +               clock-names = "usbhost";
> +       };
> +
> +       usb@12590000 {
> +               compatible = "samsung,exynos4210-ohci";
> +               reg = <0x12590000 0x100>;
> +               interrupts = <0 70 0>;
> +
> +               clocks = <&clock 304>;
> +               clock-names = "usbhost";
> +       };
> +
>         g2d@12800000 {
>                 compatible = "samsung,s5pv210-g2d";
>                 reg = <0x12800000 0x1000>;
> --
> 1.7.10.4
>
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
