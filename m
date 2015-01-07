Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbbAGQZq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 11:25:46 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:60908 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbAGQZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 11:25:44 -0500
MIME-Version: 1.0
In-Reply-To: <1420601123-25859-5-git-send-email-jamesjj.liao@mediatek.com>
References: <1420601123-25859-1-git-send-email-jamesjj.liao@mediatek.com>
	<1420601123-25859-5-git-send-email-jamesjj.liao@mediatek.com>
Date: Wed, 7 Jan 2015 17:25:41 +0100
Message-ID: <CABuKBeL34hV63t+zDy3Nbz_V4qAvCF87+=hV=eUUCTrKybBFjA@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] dts: mediatek: Enable clock support for Mediatek MT8135.
From: Matthias Brugger <matthias.bgg@gmail.com>
To: James Liao <jamesjj.liao@mediatek.com>
Cc: Rob Herring <robh+dt@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        srv_heupstream <srv_heupstream@mediatek.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        huang eddie <eddie.huang@mediatek.com>,
        HenryC Chen <henryc.chen@mediatek.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vladimir Murzin <vladimir.murzin@arm.com>,
        Ashwin Chaugule <ashwin.chaugule@linaro.org>,
        "Joe.C" <yingjoe.chen@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-07 4:25 GMT+01:00 James Liao <jamesjj.liao@mediatek.com>:
> This patch adds MT8135 clock controllers into device tree.
>
> Change-Id: I9c5bab9289bbd6eb444aad97d015b8f26ca88a8a
> Signed-off-by: James Liao <jamesjj.liao@mediatek.com>
> ---
>  arch/arm/boot/dts/mt8135.dtsi | 47 +++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 47 insertions(+)
>
> diff --git a/arch/arm/boot/dts/mt8135.dtsi b/arch/arm/boot/dts/mt8135.dtsi
> index ec83e69..09fcf0d 100644
> --- a/arch/arm/boot/dts/mt8135.dtsi
> +++ b/arch/arm/boot/dts/mt8135.dtsi
> @@ -12,6 +12,7 @@
>   * GNU General Public License for more details.
>   */
>
> +#include <dt-bindings/clock/mt8135-clk.h>
>  #include <dt-bindings/interrupt-controller/irq.h>
>  #include <dt-bindings/interrupt-controller/arm-gic.h>
>  #include "skeleton64.dtsi"
> @@ -92,6 +93,24 @@
>                         clock-frequency = <26000000>;
>                         #clock-cells = <0>;
>                 };
> +
> +               clk_null: clk_null {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <0>;
> +               };
> +
> +               clk26m: clk26m {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <26000000>;
> +               };
> +
> +               rtc32k: rtc32k {
> +                       compatible = "fixed-clock";
> +                       #clock-cells = <0>;
> +                       clock-frequency = <32000>;
> +               };

Why do you add this clocks here?
This clocks are not represented by the clock tree? If so, what are the
consumers of this clocks?

>         };
>
>         soc {
> @@ -100,6 +119,28 @@
>                 compatible = "simple-bus";
>                 ranges;
>
> +               topckgen: topckgen@10000000 {
> +                       compatible = "mediatek,mt8135-topckgen";
> +                       reg = <0 0x10000000 0 0x1000>;
> +                       #clock-cells = <1>;
> +               };
> +
> +               infracfg: syscon@10001000 {
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       compatible = "mediatek,mt8135-infracfg", "syscon";
> +                       reg = <0 0x10001000 0 0x1000>;
> +                       #clock-cells = <1>;
> +               };
> +
> +               pericfg: syscon@10003000 {
> +                       #address-cells = <1>;
> +                       #size-cells = <1>;
> +                       compatible = "mediatek,mt8135-pericfg", "syscon";
> +                       reg = <0 0x10003000 0 0x1000>;
> +                       #clock-cells = <1>;
> +               };
> +
>                 timer: timer@10008000 {
>                         compatible = "mediatek,mt8135-timer",
>                                         "mediatek,mt6577-timer";
> @@ -128,6 +169,12 @@
>                               <0 0x10216000 0 0x2000>;
>                 };
>
> +               apmixedsys: apmixedsys@10209000 {
> +                       compatible = "mediatek,mt8135-apmixedsys";
> +                       reg = <0 0x10209000 0 0x1000>;
> +                       #clock-cells = <1>;
> +               };
> +
>                 uart0: serial@11006000 {
>                         compatible = "mediatek,mt8135-uart","mediatek,mt6577-uart";
>                         reg = <0 0x11006000 0 0x400>;
> --
> 1.8.1.1.dirty
>



-- 
motzblog.wordpress.com
