Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033AbaAHOfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:35:16 -0500
Received: from 15.mo3.mail-out.ovh.net ([87.98.150.177]:49489 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755278AbaAHOfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:35:08 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mtd@lists.infradead.org, dev@linux-sunxi.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [RFC PATCH 7/9] ARM: dt/sunxi: add NFC node to Allwinner A20 SoC
Date: Wed,  8 Jan 2014 15:22:02 +0100
Message-Id: <1389190924-26226-8-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 6932728676901877956
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

Add NAND Flash controller node definition to the A20 SoC.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 arch/arm/boot/dts/sun7i-a20.dtsi |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a20.dtsi
index 8e4cdcc..c00a577 100644
--- a/arch/arm/boot/dts/sun7i-a20.dtsi
+++ b/arch/arm/boot/dts/sun7i-a20.dtsi
@@ -299,6 +299,17 @@
 		#size-cells = <1>;
 		ranges;
 
+		nfc: nand@01c03000 {
+			compatible = "allwinner,sun4i-nfc";
+			reg = <0x01c03000 0x1000>;
+			interrupts = <0 37 1>;
+			clocks = <&ahb_gates 13>, <&nand_clk>;
+			clock-names = "ahb_clk", "sclk";
+			#address-cells = <1>;
+			#size-cells = <0>;
+			status = "disabled";
+		};
+
 		emac: ethernet@01c0b000 {
 			compatible = "allwinner,sun4i-emac";
 			reg = <0x01c0b000 0x1000>;
-- 
1.7.9.5

