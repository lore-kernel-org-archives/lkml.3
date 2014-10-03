Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933096AbaJCXc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:32:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46453 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaJCWDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 18:03:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nishanth Menon <nm@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 3.14 113/238] ARM: dts: dra7-evm: Fix spi1 mux documentation
Date: Fri,  3 Oct 2014 14:30:28 -0700
Message-Id: <20141003212917.291442031@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212913.680985295@linuxfoundation.org>
References: <20141003212913.680985295@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nishanth Menon <nm@ti.com>

commit 68e4d9e58dbae2fb178e8b74806f521adb16f0d3 upstream.

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
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/dra7-evm.dts |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

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
 


