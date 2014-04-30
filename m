Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946076AbaD3Qpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:45:33 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33175 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759392AbaD3QpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:45:20 -0400
MIME-Version: 1.0
In-Reply-To: <1398848110-6152-5-git-send-email-gautam.vivek@samsung.com>
References: <1398848110-6152-1-git-send-email-gautam.vivek@samsung.com>
	<1398848110-6152-5-git-send-email-gautam.vivek@samsung.com>
Date: Wed, 30 Apr 2014 22:15:19 +0530
Message-ID: <CAK9yfHzxLei60hFQges6Vk0nzRUjLDdC3io8FHrT0zkuU65vgA@mail.gmail.com>
Subject: Re: [PATCH 4/4] ARM: dts: Add usb 2.0 support on exynos5420
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 April 2014 14:25, Vivek Gautam <gautam.vivek@samsung.com> wrote:
> Add required device node for ehci and ohci controllers to
> enable USB 2.0 support.
>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>  arch/arm/boot/dts/exynos5420.dtsi |   36 +++++++++++++++++++++++++++++++++++-
>  1 file changed, 35 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
> index 16b860a..392d340 100644
> --- a/arch/arm/boot/dts/exynos5420.dtsi
> +++ b/arch/arm/boot/dts/exynos5420.dtsi
> @@ -738,7 +738,41 @@
>                 samsung,power-domain = <&g2d_pd>;
>         };
>
> -       phy@12130000 {
> +       usb@12110000 {
> +               compatible = "samsung,exynos4210-ehci";
> +               reg = <0x12110000 0x100>;
> +               interrupts = <0 71 0>;
> +
> +               clocks = <&clock CLK_USBH20>;
> +               clock-names = "usbhost";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               port@0 {
> +                       reg = <0>;
> +                       phys = <&usb2_phy_gen 1>;
> +                       phy-names = "host";
> +                       status = "ok";
s/ok/okay

> +               };
> +       };
> +
> +       usb@12120000 {
> +               compatible = "samsung,exynos4210-ohci";
> +               reg = <0x12120000 0x100>;
> +               interrupts = <0 71 0>;
> +
> +               clocks = <&clock CLK_USBH20>;
> +               clock-names = "usbhost";
> +               #address-cells = <1>;
> +               #size-cells = <0>;
> +               port@0 {
> +                       reg = <0>;
> +                       phys = <&usb2_phy_gen 1>;
> +                       phy-names = "host";
> +                       status = "ok";

ditto

-- 
With warm regards,
Sachin
