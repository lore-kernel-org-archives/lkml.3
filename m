Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbaCTLvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 07:51:06 -0400
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:54707 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932755AbaCTLu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 07:50:58 -0400
X-Greylist: delayed 98869 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 07:50:58 EDT
MIME-Version: 1.0
In-Reply-To: <1395173924-3648-9-git-send-email-b.brezillon.dev@gmail.com>
References: <1395173924-3648-1-git-send-email-b.brezillon.dev@gmail.com>
	<1395173924-3648-9-git-send-email-b.brezillon.dev@gmail.com>
Date: Thu, 20 Mar 2014 10:22:51 +0100
Message-ID: <CACh+v5Ngvdt=FnyzMz4Q0i1U7kNmrgXWDavzi4xvLDJR0qh0WA@mail.gmail.com>
Subject: Re: [PATCH 08/11] ARM: at91/dt: move at91sam9261 SoC to the new main
 clock model
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Boris BREZILLON <brezillonboris@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mike Turquette <mturquette@linaro.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Boris BREZILLON <b.brezillon.dev@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 12929271582361213069
X-Ovh-Remote: 209.85.220.41 (mail-pa0-f41.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejuddrfeefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-03-18 21:18 GMT+01:00 Boris BREZILLON <brezillonboris@gmail.com>:
>
> Signed-off-by: Boris BREZILLON <b.brezillon.dev@gmail.com>
> ---
>  arch/arm/boot/dts/at91sam9261.dtsi |   10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/boot/dts/at91sam9261.dtsi b/arch/arm/boot/dts/at91sam9261.dtsi
> index e21dda0..e00fabc 100644
> --- a/arch/arm/boot/dts/at91sam9261.dtsi
> +++ b/arch/arm/boot/dts/at91sam9261.dtsi
> @@ -45,6 +45,14 @@
>                 reg = <0x20000000 0x08000000>;
>         };
>
> +       clocks {
> +               main_xtal: main_xtal {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <0>;
> +               };
> +       };
> +
>         ahb {
>                 compatible = "simple-bus";
>                 #address-cells = <1>;
> @@ -534,7 +542,7 @@
>                                         compatible = "atmel,at91rm9200-clk-main";
>                                         #clock-cells = <0>;
>                                         interrupts-extended = <&pmc AT91_PMC_MOSCS>;
> -                                       clocks = <&clk32k>;
> +                                       clocks = <&main_xtal>;
>                                 };
>
>                                 plla: pllack {
> --
> 1.7.9.5
>

Acked-by: Jean-Jacques HIBLOT <jjhiblot@traphandler.com>
