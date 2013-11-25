Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab3KYPvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:51:00 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:33542 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3KYPu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:50:58 -0500
MIME-Version: 1.0
In-Reply-To: <1385387745-7162-1-git-send-email-rogerq@ti.com>
References: <1385387745-7162-1-git-send-email-rogerq@ti.com>
Date: Mon, 25 Nov 2013 09:50:55 -0600
X-Google-Sender-Auth: omtcgJSAaQctf0XWCBXYpdhgHd4
Message-ID: <CAGo_u6ryFJvBwd=S9A-nJw+eoGguPj0jMOtgMiZ7mXXAbh4i+w@mail.gmail.com>
Subject: Re: [PATCH] ARM: dts: omap3-beagle: Fix USB host on beagle boards
 (for 3.13)
From: Nishanth Menon <nm@ti.com>
To: Roger Quadros <rogerq@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, Benoit Cousson <bcousson@baylibre.com>,
        dt list <devicetree@vger.kernel.org>, linux-usb@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>, balbi@ti.com,
        linux-omap <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 7:55 AM, Roger Quadros <rogerq@ti.com> wrote:
> Beagle (rev. C4) and Beagle-XM (all revs) need VAUX2 1.8V supply
> for the USB PHY.
>
> As the generic PHY driver can't handle more than one supply
> at the moment, we configure this supply to be always on.
> This will cause a very small power impact if the USB host subsystem
> is not in use, about 76.86 micro-W + LDO power.

>
> Older Beagle boards (prior to C4) don't have VAUX2 connected anywhere,
> so there won't be any functional impact on those boards other than
> some additional LDO power consumption.
>
> Reported-by: Nishanth Menon <nm@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Tested-by: Nishanth Menon <nm@ti.com>

I might suggest though that the better alternative might be to get phy
driver to handle multiple regulators considering that DT is supposed
to represent the h/w topology.

> ---
>  arch/arm/boot/dts/omap3-beagle-xm.dts | 8 ++++++++
>  arch/arm/boot/dts/omap3-beagle.dts    | 8 ++++++++
>  2 files changed, 16 insertions(+)
>
> diff --git a/arch/arm/boot/dts/omap3-beagle-xm.dts b/arch/arm/boot/dts/omap3-beagle-xm.dts
> index 31a632f..b39918e 100644
> --- a/arch/arm/boot/dts/omap3-beagle-xm.dts
> +++ b/arch/arm/boot/dts/omap3-beagle-xm.dts
> @@ -215,3 +215,11 @@
>  &usbhsehci {
>         phys = <0 &hsusb2_phy>;
>  };
> +
> +&vaux2 {
> +       regulator-name = "usb_1v8";
> +       regulator-min-microvolt = <1800000>;
> +       regulator-max-microvolt = <1800000>;
> +       regulator-always-on;
> +};
> +
> diff --git a/arch/arm/boot/dts/omap3-beagle.dts b/arch/arm/boot/dts/omap3-beagle.dts
> index fa532aa..9764556 100644
> --- a/arch/arm/boot/dts/omap3-beagle.dts
> +++ b/arch/arm/boot/dts/omap3-beagle.dts
> @@ -178,3 +178,11 @@
>         mode = <3>;
>         power = <50>;
>  };
> +
> +&vaux2 {
> +       regulator-name = "vdd_ehci";
> +       regulator-min-microvolt = <1800000>;
> +       regulator-max-microvolt = <1800000>;
> +       regulator-always-on;
> +};
> +
> --
> 1.8.3.2
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
