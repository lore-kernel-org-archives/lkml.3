Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758911Ab3LFVLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:11:09 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:35592 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758064Ab3LFVLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:11:01 -0500
MIME-Version: 1.0
In-Reply-To: <1386350983-13281-9-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-9-git-send-email-wens@csie.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 6 Dec 2013 13:10:19 -0800
Message-ID: <CAGVrzcYhA1S17AP8tO8m0Mjt3z=qq6feziOkwi2BwEuSPU=9Rw@mail.gmail.com>
Subject: Re: [PATCH 08/10] ARM: dts: sun7i: cubieboard2: Enable GMAC instead
 of EMAC
To: Chen-Yu Tsai <wens@csie.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        netdev <netdev@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/6 Chen-Yu Tsai <wens@csie.org>:
> GMAC has better performance and fewer hardware issues.
> Use the GMAC in MII mode for ethernet instead of the EMAC.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun7i-a20-cubieboard2.dts | 23 ++++++++---------------
>  1 file changed, 8 insertions(+), 15 deletions(-)
>
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> index 5c51cb8..9ef5848 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubieboard2.dts
> @@ -19,21 +19,6 @@
>         compatible = "cubietech,cubieboard2", "allwinner,sun7i-a20";
>
>         soc@01c00000 {
> -               emac: ethernet@01c0b000 {
> -                       pinctrl-names = "default";
> -                       pinctrl-0 = <&emac_pins_a>;
> -                       phy = <&phy1>;
> -                       status = "okay";
> -               };
> -
> -               mdio@01c0b080 {
> -                       status = "okay";
> -
> -                       phy1: ethernet-phy@1 {
> -                               reg = <1>;
> -                       };
> -               };
> -
>                 pinctrl@01c20800 {
>                         led_pins_cubieboard2: led_pins@0 {
>                                 allwinner,pins = "PH20", "PH21";
> @@ -60,6 +45,14 @@
>                         pinctrl-0 = <&i2c1_pins_a>;
>                         status = "okay";
>                 };
> +
> +               gmac: ethernet@01c50000 {
> +                       pinctrl-names = "default";
> +                       pinctrl-0 = <&gmac_pins_mii>;
> +                       snps,phy-addr = <1>;

Same here, this is a custom property which has no reason to exist,
keep the existing ethernet PHY node please.
-- 
Florian
