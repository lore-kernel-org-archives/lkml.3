Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaIDNeE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:34:04 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:35132 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832AbaIDNeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:34:01 -0400
Date: Thu, 4 Sep 2014 08:33:37 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <rogerq@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] ARM: dts: dra7-evm: Fix spi1 mux documentation
Message-ID: <20140904133337.GA4215@kahuna>
References: <1409837008-32144-1-git-send-email-nm@ti.com>
 <1409837008-32144-2-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1409837008-32144-2-git-send-email-nm@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08:23-20140904, Nishanth Menon wrote:
> While auditing the various pin ctrl configurations using the following
> command:
> grep PIN_ arch/arm/boot/dts/dra7-evm.dts|(while read line;
> do
> 	v=`echo "$line" | sed -e "s/\s\s*/|/g" | cut -d '|' -f1 |
> 		cut -d 'x' -f2|tr [a-z] [A-Z]`;
> 	HEX=`echo "obase=16;ibase=16;4A003400+$v"| bc`;
> 	echo "$HEX ===> $line";
> done)
> against DRA75x/74x NDA TRM revision S(SPRUHI2S August 2014),
> documentation errors were found for spi1 pinctrl. Fix the same.
> 
> Fixes: 6e58b8f1daaf1af340fb9309907e5ffa473c7aff ("ARM: dts: DRA7: Add
> the dts files for dra7 SoC and dra7-evm board")
^^^ uggh... apologies.. checkpatch slipped this one.. updated rev below
(wont repost unless requested), Apologies on the spam..
----8<----
>From db595b941663f634f5f5106cf0092c7c8e998bb4 Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Thu, 4 Sep 2014 08:06:27 -0500
Subject: [PATCH V2 1/2] ARM: dts: dra7-evm: Fix spi1 mux documentation

While auditing the various pin ctrl configurations using the following
command:
grep PIN_ arch/arm/boot/dts/dra7-evm.dts|(while read line;
do
	v=`echo "$line" | sed -e "s/\s\s*/|/g" | cut -d '|' -f1 |
		cut -d 'x' -f2|tr [a-z] [A-Z]`;
	HEX=`echo "obase=16;ibase=16;4A003400+$v"| bc`;
	echo "$HEX ===> $line";
done)
against DRA75x/74x NDA TRM revision S(SPRUHI2S August 2014),
documentation errors were found for spi1 pinctrl. Fix the same.

Fixes: 6e58b8f1daaf1af ("ARM: dts: DRA7: Add the dts files for dra7 SoC and dra7-evm board")
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7-evm.dts |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/boot/dts/dra7-evm.dts b/arch/arm/boot/dts/dra7-evm.dts
index 50f8022..e120fca 100644
--- a/arch/arm/boot/dts/dra7-evm.dts
+++ b/arch/arm/boot/dts/dra7-evm.dts
@@ -50,13 +50,13 @@
 
 	mcspi1_pins: pinmux_mcspi1_pins {
 		pinctrl-single,pins = <
-			0x3a4 (PIN_INPUT | MUX_MODE0) /* spi2_clk */
-			0x3a8 (PIN_INPUT | MUX_MODE0) /* spi2_d1 */
-			0x3ac (PIN_INPUT | MUX_MODE0) /* spi2_d0 */
-			0x3b0 (PIN_INPUT_SLEW | MUX_MODE0) /* spi2_cs0 */
-			0x3b4 (PIN_INPUT_SLEW | MUX_MODE0) /* spi2_cs1 */
-			0x3b8 (PIN_INPUT_SLEW | MUX_MODE6) /* spi2_cs2 */
-			0x3bc (PIN_INPUT_SLEW | MUX_MODE6) /* spi2_cs3 */
+			0x3a4 (PIN_INPUT | MUX_MODE0) /* spi1_sclk */
+			0x3a8 (PIN_INPUT | MUX_MODE0) /* spi1_d1 */
+			0x3ac (PIN_INPUT | MUX_MODE0) /* spi1_d0 */
+			0x3b0 (PIN_INPUT_SLEW | MUX_MODE0) /* spi1_cs0 */
+			0x3b4 (PIN_INPUT_SLEW | MUX_MODE0) /* spi1_cs1 */
+			0x3b8 (PIN_INPUT_SLEW | MUX_MODE6) /* spi1_cs2.hdmi1_hpd */
+			0x3bc (PIN_INPUT_SLEW | MUX_MODE6) /* spi1_cs3.hdmi1_cec */
 		>;
 	};
 
-- 
1.7.9.5


-- 
Regards,
Nishanth Menon
