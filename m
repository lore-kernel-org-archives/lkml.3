Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaLAPlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 10:41:10 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:55257 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685AbaLAPlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 10:41:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Peter Griffin <peter.griffin@linaro.org>, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, peppe.cavallaro@st.com, kishon@ti.com,
        netdev@vger.kernel.org, lee.jones@linaro.org, alexandre.torgue@st.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH 4/7] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Date: Mon, 01 Dec 2014 16:40:35 +0100
Message-ID: <4736928.ouoSJRV5Ml@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1416385632-5832-5-git-send-email-peter.griffin@linaro.org>
References: <1416385632-5832-1-git-send-email-peter.griffin@linaro.org> <1416385632-5832-5-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:51kk32WVQxpXlJSMDhYMtHLtsY7mZ2bAOVJQ6gQtDj+
 Lh8PhxLX2tSeCRGVOZfoJ1K1T0b14eF6TKgxvyfObOLLqDBHqR
 baPRTQZG2Vc3n/SLoX199UxjnvH3hhhmn0j9HhZFIQmQzi232p
 Ofojau3EHStjGG8M3CYNa0R8zA2LWjJugqXPYsfT4DBrQQGFwI
 fF3tzT7dJ8v3i2BCXCxWBI/71xFJoE5DcPIKyuv8tJU41qQzO5
 cWZ/kkwfT4NzJFy3IVvSBApoc2gLrizOnQi+DvhTYkBgogwVKv
 c60mBMiV6u0bbhqRkyc0YBe8Mui7SSNwZNpmzlh1wU4yzWDZlv
 oQlIJloleNVFYhtSl9mE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 November 2014 08:27:09 Peter Griffin wrote:
> +       soc {
> +               usb2_picophy1: phy@1 {
> +                       compatible = "st,stih407-usb2-phy";
> +                       #phy-cells = <0>;
> +                       st,syscfg = <&syscfg_core 0xf8 0xf4>;
> +                       resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
> +                                <&picophyreset STIH407_PICOPHY0_RESET>;
> +                       reset-names = "global", "port";
> +               };
>  
> +               usb2_picophy2: phy@2 {
> +                       compatible = "st,stih407-usb2-phy";
> +                       #phy-cells = <0>;
> +                       st,syscfg = <&syscfg_core 0xfc 0xf4>;
> +                       resets = <&softreset STIH407_PICOPHY_SOFTRESET>,
> +                                <&picophyreset STIH407_PICOPHY1_RESET>;
> +                       reset-names = "global", "port";
> +               };
> +       };

In theory the unit-address (the @1 and @2 part of the name) is supposed to
match the 'reg' property value, but of course that doesn't work any
more with the changed binding. The same problem keeps coming up, so
I wonder if anyone has an idea how this is supposed to be handled properly.

Should we just make up unit-address numbers? I guess a more elaborate
variant would be to have a parent node with #address-cells = <1> and
no ranges, to make up a new address space with arbitrarily assigned
reg values, like

	phys {
		#address-cells = <1>; /* just counting the nodes */
		#size-cells = <0>;

               usb2_picophy1: phy@0 {
                       compatible = "st,stih407-usb2-phy";
			reg = <0>;
                       #phy-cells = <0>;
                       st,syscfg = <&syscfg_core 0xf8 0xf4>;
               };

               usb2_picophy2: phy@1 {
                       compatible = "st,stih407-usb2-phy";
			reg = <0>;
                       #phy-cells = <0>;
                       st,syscfg = <&syscfg_core 0xf8 0xf4>;
               };
	}

Should we try to do it like this, or is that overcomplicating
things?

	Arnd
