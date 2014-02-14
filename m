Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbaBNFqY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 00:46:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50549 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaBNFqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 00:46:22 -0500
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>, Balaji T K <balajitk@ti.com>,
        Chris Ball <chris@printf.net>
CC: <linux-mmc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 2/2] ARM: dts: omap3-ldp: fix mmc configuration
Date: Thu, 13 Feb 2014 23:45:49 -0600
Message-ID: <1392356749-32091-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1392356749-32091-1-git-send-email-nm@ti.com>
References: <1392356749-32091-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MMC1 is the only MMC interface available on the platform. Further,
since the platform is based on older revision of SoC which is not
capable of doing multi-block reads, mark it with compatibility for the
same and add pinmux to ensure that all relevant pins are configured
for non-MMC boot mode.

Signed-off-by: Nishanth Menon <nm@ti.com>
---

Changes since V1:
	- fixed commit message as suggested by Balaji.
	- update to use new compatible match for the erratum.

V1: https://patchwork.kernel.org/patch/3514881/

 arch/arm/boot/dts/omap3-ldp.dts |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm/boot/dts/omap3-ldp.dts b/arch/arm/boot/dts/omap3-ldp.dts
index ddce0d8..0abe986 100644
--- a/arch/arm/boot/dts/omap3-ldp.dts
+++ b/arch/arm/boot/dts/omap3-ldp.dts
@@ -174,8 +174,20 @@
 };
 
 &mmc1 {
+	/* See 35xx errata 2.1.1.128 in SPRZ278F */
+	compatible = "ti,omap3-pre-es3-hsmmc";
 	vmmc-supply = <&vmmc1>;
 	bus-width = <4>;
+	pinctrl-names = "default";
+	pinctrl-0 = <&mmc1_pins>;
+};
+
+&mmc2 {
+	status="disabled";
+};
+
+&mmc3 {
+	status="disabled";
 };
 
 &omap3_pmx_core {
@@ -209,6 +221,17 @@
 			0x174 (PIN_OUTPUT | MUX_MODE0)	/* hsusb0_stp.hsusb0_stp */
 		>;
 	};
+
+	mmc1_pins: pinmux_mmc1_pins {
+		pinctrl-single,pins = <
+			OMAP3_CORE1_IOPAD(0x2144, PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc1_clk.mmc1_clk */
+			OMAP3_CORE1_IOPAD(0x2146, PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc1_cmd.mmc1_cmd */
+			OMAP3_CORE1_IOPAD(0x2148, PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc1_dat0.mmc1_dat0 */
+			OMAP3_CORE1_IOPAD(0x214A, PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc1_dat1.mmc1_dat1 */
+			OMAP3_CORE1_IOPAD(0x214C, PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc1_dat2.mmc1_dat2 */
+			OMAP3_CORE1_IOPAD(0x214e, PIN_INPUT_PULLUP | MUX_MODE0)	/* mmc1_dat3.mmc1_dat3 */
+		>;
+	};
 };
 
 &usb_otg_hs {
-- 
1.7.9.5

