Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaIZIN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 04:13:26 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:48525 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785AbaIZINJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 04:13:09 -0400
MIME-Version: 1.0
In-Reply-To: <1411662520-22795-11-git-send-email-geert+renesas@glider.be>
References: <1411662520-22795-1-git-send-email-geert+renesas@glider.be>
	<1411662520-22795-11-git-send-email-geert+renesas@glider.be>
Date: Fri, 26 Sep 2014 10:13:06 +0200
X-Google-Sender-Auth: 3IcOEIP8g-5XV4OGN1K8qZpyyFg
Message-ID: <CAMuHMdWfyL3eju+GF1M_h9gvTLsO=3NniFjhP6SRgiQ_-H2gyw@mail.gmail.com>
Subject: Re: [PATCH v3 10/13] ARM: shmobile: r8a7740 dtsi: Add PM domain support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Simon Horman <horms@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Philipp Zabel <philipp.zabel@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 6:28 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Add a device node for the System Controller, with subnodes that
> represent the hardware power area hierarchy.
> Hook up all devices to their respective PM domains.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

> diff --git a/arch/arm/boot/dts/r8a7740.dtsi b/arch/arm/boot/dts/r8a7740.dtsi
> index 502483f4dccb2f45..4fead480a405bebe 100644
> --- a/arch/arm/boot/dts/r8a7740.dtsi
> +++ b/arch/arm/boot/dts/r8a7740.dtsi

> @@ -383,6 +408,7 @@
>                         compatible = "renesas,r8a7740-cpg-clocks";
>                         reg = <0xe6150000 0x10000>;
>                         clocks = <&extal1_clk>, <&extalr_clk>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <1>;
>                         clock-output-names = "system", "pllc0", "pllc1",
>                                              "pllc2", "r",
> @@ -397,6 +423,7 @@
>                         compatible = "renesas,r8a7740-div6-clock", "renesas,cpg-div6-clock";
>                         reg = <0xe6150080 4>;
>                         clocks = <&pllc1_div2_clk>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <0>;
>                         clock-output-names = "sub";
>                 };
> @@ -405,6 +432,7 @@
>                 pllc1_div2_clk: pllc1_div2_clk {
>                         compatible = "fixed-factor-clock";
>                         clocks = <&cpg_clocks R8A7740_CLK_PLLC1>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <0>;
>                         clock-div = <2>;
>                         clock-mult = <1>;
> @@ -413,6 +441,7 @@
>                 extal1_div2_clk: extal1_div2_clk {
>                         compatible = "fixed-factor-clock";
>                         clocks = <&extal1_clk>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <0>;
>                         clock-div = <2>;
>                         clock-mult = <1>;
> @@ -424,6 +453,7 @@
>                         compatible = "renesas,r8a7740-mstp-clocks", "renesas,cpg-mstp-clocks";
>                         reg = <0xe6150080 4>;
>                         clocks = <&sub_clk>, <&sub_clk>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_SUBCK R8A7740_CLK_SUBCK2
> @@ -439,6 +469,7 @@
>                                  <&cpg_clocks R8A7740_CLK_B>,
>                                  <&sub_clk>, <&sub_clk>,
>                                  <&cpg_clocks R8A7740_CLK_B>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_CEU21 R8A7740_CLK_CEU20 R8A7740_CLK_TMU0
> @@ -460,6 +491,7 @@
>                                  <&sub_clk>, <&sub_clk>, <&sub_clk>,
>                                  <&sub_clk>, <&sub_clk>, <&sub_clk>,
>                                  <&sub_clk>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_SCIFA6 R8A7740_CLK_INTCA
> @@ -489,6 +521,7 @@
>                                  <&cpg_clocks R8A7740_CLK_HP>,
>                                  <&cpg_clocks R8A7740_CLK_HP>,
>                                  <&cpg_clocks R8A7740_CLK_HP>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_CMT1 R8A7740_CLK_FSI R8A7740_CLK_IIC1
> @@ -506,6 +539,7 @@
>                                  <&cpg_clocks R8A7740_CLK_HP>,
>                                  <&cpg_clocks R8A7740_CLK_HP>,
>                                  <&cpg_clocks R8A7740_CLK_HP>;
> +                       power-domains = <&pd_c5>;
>                         #clock-cells = <1>;
>                         renesas,clock-indices = <
>                                 R8A7740_CLK_USBH R8A7740_CLK_SDHI2

Woosh, looks like I've been too eager adding links to the pd_c5 "always on"
PM domain to any node that has a clocks property. This must not be done for
the clocks. They are not instantiated as platform devices.

Thanks to Grygorii for questioning me.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
