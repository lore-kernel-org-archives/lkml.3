Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab3LFVJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 16:09:50 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56597 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab3LFVJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:09:47 -0500
MIME-Version: 1.0
In-Reply-To: <1386350983-13281-8-git-send-email-wens@csie.org>
References: <1386350983-13281-1-git-send-email-wens@csie.org> <1386350983-13281-8-git-send-email-wens@csie.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Date: Fri, 6 Dec 2013 13:09:06 -0800
Message-ID: <CAGVrzcb_r9_p4urz4XkE2A-G85KAHJa4PJ=Gt9a4RPYQNJ6j0g@mail.gmail.com>
Subject: Re: [PATCH 07/10] ARM: dts: sun7i: cubietruck: Enable the GMAC
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
> The CubieTruck uses the GMAC with an RGMII phy.
>
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun7i-a20-cubietruck.dts | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> index 8a1009d..af212a2 100644
> --- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> +++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
> @@ -33,6 +33,14 @@
>                         pinctrl-0 = <&uart0_pins_a>;
>                         status = "okay";
>                 };
> +
> +               gmac: ethernet@01c50000 {
> +                       pinctrl-names = "default";
> +                       pinctrl-0 = <&gmac_pins_rgmii>;
> +                       snps,phy-addr = <1>;

What is this snps,phy-addr property? Why is not a standard device tree
node for an Ethernet PHY node used?

> +                       phy-mode = "rgmii";

Especially since you use the relatively standard "phy-mode" property here?
--
Florian
