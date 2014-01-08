Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbaAHP2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 10:28:52 -0500
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:34265 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756620AbaAHP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 10:28:46 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 9/9] ARM: sunxi/dt: enable NAND on cubietruck board
Date: Wed,  8 Jan 2014 16:28:11 +0100
Message-Id: <1389194891-26771-1-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 7975311991454070973
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the NFC and describe the NAND flash connected to this controller.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sun7i-a20-cubietruck.dts |   33 ++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
index 8a1009d..08ee7d3 100644
--- a/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
+++ b/arch/arm/boot/dts/sun7i-a20-cubietruck.dts
@@ -18,7 +18,40 @@
 	model = "Cubietech Cubietruck";
 	compatible = "cubietech,cubietruck", "allwinner,sun7i-a20";
 
+	chosen {
+		bootargs = "console=ttyS0,115200 earlyprintk root=/dev/ram0 rootfstype=ext2 rw";
+	};
+
 	soc@01c00000 {
+		nfc: nand@01c03000 {
+			pinctrl-names = "default";
+			pinctrl-0 = <&nand_pins_a &nand_cs0_pins_a &nand_rb0_pins_a>;
+			status = "okay";
+
+			nand@0 {
+				reg = <0>;
+				allwinner,rb = <0>;
+				nand-ecc-mode = "soft_bch";
+
+				/* nand timings */
+				tCLS-min = <6>;
+				tCLH-min = <3>;
+				tCS-min = <20>;
+				tCH-min = <5>;
+				tWP-min = <8>;
+				tWH-min = <6>;
+				tALS-min = <6>;
+				tDS-min = <6>;
+				tDH-min = <2>;
+				tRR-min = <20>;
+				tALH-min = <3>;
+				tRP-min = <8>;
+				tREH-min = <6>;
+				tRC-min = <16>;
+				tWC-min = <16>;
+			};
+		};
+
 		pinctrl@01c20800 {
 			led_pins_cubietruck: led_pins@0 {
 				allwinner,pins = "PH7", "PH11", "PH20", "PH21";
-- 
1.7.9.5

