Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843Ab3I1DN6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 23:13:58 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57327 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754639Ab3I1DNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 23:13:53 -0400
MIME-Version: 1.0
In-Reply-To: <1379010935-25943-2-git-send-email-koen@dominion.thruhere.net>
References: <1379010935-25943-1-git-send-email-koen@dominion.thruhere.net>
	<1379010935-25943-2-git-send-email-koen@dominion.thruhere.net>
Date: Fri, 27 Sep 2013 23:13:50 -0400
Message-ID: <CA+T6QPk=Z+u2eo63-2T4dZcyaZ=yL=+rBck5r5y14MiQK_w00w@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] ARM: dts: am335x-bone: add CD for mmc1
From: Jason Kridner <jkridner@beagleboard.org>
To: Koen Kooi <koen@dominion.thruhere.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Rob Herring <rob.herring@calxeda.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Alexander Holler <holler@ahsoftware.de>,
        OMAP List <linux-omap@vger.kernel.org>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 2:35 PM, Koen Kooi <koen@dominion.thruhere.net> wrote:
> From: Alexander Holler <holler@ahsoftware.de>
>
> This enables the use of MMC cards even when no card was inserted at boot.
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> Signed-off-by: Koen Kooi <koen@dominion.thruhere.net>

Acked-by: Jason Kridner <jdk@ti.com>

> ---
>  arch/arm/boot/dts/am335x-bone-common.dtsi | 14 ++++++++++++++
>  arch/arm/boot/dts/am335x-bone.dts         |  1 -
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/am335x-bone-common.dtsi b/arch/arm/boot/dts/am335x-bone-common.dtsi
> index 2f66ded..0d95d54 100644
> --- a/arch/arm/boot/dts/am335x-bone-common.dtsi
> +++ b/arch/arm/boot/dts/am335x-bone-common.dtsi
> @@ -107,6 +107,12 @@
>                                 0x14c (PIN_INPUT_PULLDOWN | MUX_MODE7)
>                         >;
>                 };
> +
> +               mmc1_pins: pinmux_mmc1_pins {
> +                       pinctrl-single,pins = <
> +                               0x160 (PIN_INPUT | MUX_MODE7) /* GPIO0_6 */
> +                       >;
> +               };
>         };
>
>         ocp {
> @@ -260,3 +266,11 @@
>         pinctrl-0 = <&davinci_mdio_default>;
>         pinctrl-1 = <&davinci_mdio_sleep>;
>  };
> +
> +&mmc1 {
> +       status = "okay";
> +       pinctrl-names = "default";
> +       pinctrl-0 = <&mmc1_pins>;
> +       cd-gpios = <&gpio0 6 GPIO_ACTIVE_HIGH>;
> +       cd-inverted;
> +};
> diff --git a/arch/arm/boot/dts/am335x-bone.dts b/arch/arm/boot/dts/am335x-bone.dts
> index d5f43fe..0d63348 100644
> --- a/arch/arm/boot/dts/am335x-bone.dts
> +++ b/arch/arm/boot/dts/am335x-bone.dts
> @@ -17,6 +17,5 @@
>  };
>
>  &mmc1 {
> -       status = "okay";
>         vmmc-supply = <&ldo3_reg>;
>  };
> --
> 1.8.2.1
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
