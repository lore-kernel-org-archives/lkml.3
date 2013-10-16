Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762008Ab3JPUVv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:21:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:45850 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761884Ab3JPUVt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:21:49 -0400
From: Nishanth Menon <nm@ti.com>
To: =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>,
        Rajendra Nayak <rnayak@ti.com>, Tony Lindgren <tony@atomide.com>
CC: <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 1/2] ARM: dts: OMAP3+: Add i2c aliases
Date: Wed, 16 Oct 2013 15:21:03 -0500
Message-ID: <1381954864-24410-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1381954864-24410-1-git-send-email-nm@ti.com>
References: <525E8D91.5090400@ti.com>
 <1381954864-24410-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, on OMAP5, i2c1 and i2c5 defer probe due to pinctrl
dependencies. This changes the i2c ID each bus is registered with in
i2c-dev interface. As a result of this, many userspace tools break and
there is no consistent manner to fix the same if the i2c dev interface
have no consistent numbering.

Since this could happen for other OMAP derivatives, provide i2c alias
for all OMAP3+ SoCs to allow ordering the i2c devices correctly.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/dra7.dtsi  |    5 +++++
 arch/arm/boot/dts/omap3.dtsi |    3 +++
 arch/arm/boot/dts/omap4.dtsi |    4 ++++
 arch/arm/boot/dts/omap5.dtsi |    5 +++++
 4 files changed, 17 insertions(+)

diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
index e723b52..f62f24a 100644
--- a/arch/arm/boot/dts/dra7.dtsi
+++ b/arch/arm/boot/dts/dra7.dtsi
@@ -20,6 +20,11 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
+		i2c0 = &i2c1;
+		i2c1 = &i2c2;
+		i2c2 = &i2c3;
+		i2c3 = &i2c4;
+		i2c4 = &i2c5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
diff --git a/arch/arm/boot/dts/omap3.dtsi b/arch/arm/boot/dts/omap3.dtsi
index 4f3778a..d9160e7 100644
--- a/arch/arm/boot/dts/omap3.dtsi
+++ b/arch/arm/boot/dts/omap3.dtsi
@@ -19,6 +19,9 @@
 	interrupt-parent = <&intc>;
 
 	aliases {
+		i2c0 = &i2c1;
+		i2c1 = &i2c2;
+		i2c2 = &i2c3;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
diff --git a/arch/arm/boot/dts/omap4.dtsi b/arch/arm/boot/dts/omap4.dtsi
index decff2a..269bf83 100644
--- a/arch/arm/boot/dts/omap4.dtsi
+++ b/arch/arm/boot/dts/omap4.dtsi
@@ -17,6 +17,10 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
+		i2c0 = &i2c1;
+		i2c1 = &i2c2;
+		i2c2 = &i2c3;
+		i2c3 = &i2c4;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index e18ee7e..8970deb 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -21,6 +21,11 @@
 	interrupt-parent = <&gic>;
 
 	aliases {
+		i2c0 = &i2c1;
+		i2c1 = &i2c2;
+		i2c2 = &i2c3;
+		i2c3 = &i2c4;
+		i2c4 = &i2c5;
 		serial0 = &uart1;
 		serial1 = &uart2;
 		serial2 = &uart3;
-- 
1.7.9.5

