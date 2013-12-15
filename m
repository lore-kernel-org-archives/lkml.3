Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362Ab3LONPg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 08:15:36 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37449 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab3LONPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 08:15:34 -0500
Message-ID: <52ADAB0E.4020800@ti.com>
Date: Sun, 15 Dec 2013 18:43:50 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        <linux-gpio@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v6 6/6] ARM: davinci: da850 evm: add GPIO pinumux entries
 DT node
References: <1385057731-4348-1-git-send-email-prabhakar.csengg@gmail.com> <1385057731-4348-7-git-send-email-prabhakar.csengg@gmail.com>
In-Reply-To: <1385057731-4348-7-git-send-email-prabhakar.csengg@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 November 2013 11:45 PM, Prabhakar Lad wrote:
> From: KV Sujith <sujithkv@ti.com>
> 
> Add GPIO DT node and pinmux entries for DA850 EVM. GPIO is
> configurable differently on different boards. So add GPIO
> pinmuxing in dts file.
> 
> Signed-off-by: KV Sujith <sujithkv@ti.com>
> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
> ---
>  arch/arm/boot/dts/da850-evm.dts |   20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
> index 588ce58..f82c129 100644
> --- a/arch/arm/boot/dts/da850-evm.dts
> +++ b/arch/arm/boot/dts/da850-evm.dts
> @@ -17,6 +17,21 @@
>  	soc {
>  		pmx_core: pinmux@1c14120 {
>  			status = "okay";
> +
> +			gpio_pins: pinmux_gpio_pins {
> +				pinctrl-single,bits = <
> +					/* GPIO2_4 GPIO2_6 */
> +					0x18 0x00008080 0x0000f0f0
> +					/* GPIO2_8 GPIO2_15 */
> +					0x14 0x80000008 0xf000000f
> +					/* GPIO3_12 GPIO3_13 */
> +					0x1C 0x00008800 0x0000ff00
> +					/* GPIO4_0 GPIO4_1 */
> +					0x28 0x88000000 0xff000000
> +					/* GPIO6_9 GPIO6_10 GPIO6_13 */
> +					0x34 0x08800800 0x0ff00f00
> +				>;
> +			};
>  		};

Shouldn't these pinmux entries be part of actual device
node which needs them to be muxed this way? For now, I
have committed the attached reduced patch.

Thanks,
Sekhar

---8<---
>From 3a9574f2aa4ffd9b867321a1f298893410bd3718 Mon Sep 17 00:00:00 2001
From: KV Sujith <sujithkv@ti.com>
Date: Thu, 21 Nov 2013 23:45:31 +0530
Subject: [PATCH 1/1] ARM: davinci: da850 evm: add GPIO pinumux entries DT node

Add GPIO DT node and pinmux entries for DA850 EVM. GPIO is
configurable differently on different boards. So add GPIO
pinmuxing in dts file.

Signed-off-by: KV Sujith <sujithkv@ti.com>
Signed-off-by: Philip Avinash <avinashphilip@ti.com>
Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
---
 arch/arm/boot/dts/da850-evm.dts |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/boot/dts/da850-evm.dts b/arch/arm/boot/dts/da850-evm.dts
index 588ce58..1e11e5a 100644
--- a/arch/arm/boot/dts/da850-evm.dts
+++ b/arch/arm/boot/dts/da850-evm.dts
@@ -101,6 +101,9 @@
 			pinctrl-names = "default";
 			pinctrl-0 = <&mii_pins>;
 		};
+		gpio: gpio@1e26000 {
+			status = "okay";
+		};
 	};
 	nand_cs3@62000000 {
 		status = "okay";
-- 
1.7.10.1



