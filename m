Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165Ab3CZRsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:48:19 -0400
Received: from norkia.v3.sk ([91.210.183.14]:34036 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab3CZRsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:48:16 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: Lubomir Rintel <lkundrak@v3.sk>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-rpi-kernel@lists.infradead.org
Subject: [PATCH v2] bcm2835: Add Broadcom BCM2835 RNG to the device tree
Date: Tue, 26 Mar 2013 18:48:10 +0100
Message-Id: <1364320090-23363-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1364135137-26691-1-git-send-email-lkundrak@v3.sk>
References: <1364135137-26691-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a device tree binding for random number generator present on Broadcom
BCM2835 SoC, used in Raspberry Pi and Roku 2 devices.

Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
Cc: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-rpi-kernel@lists.infradead.org
---
Changes for v2:
    - Split out from the driver changeset
    - Added documentation

 .../devicetree/bindings/rng/brcm,bcm2835.txt       |   13 +++++++++++++
 arch/arm/boot/dts/bcm2835.dtsi                     |    5 +++++
 2 files changed, 18 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm2835.txt

diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
new file mode 100644
index 0000000..07ccdaa
--- /dev/null
+++ b/Documentation/devicetree/bindings/rng/brcm,bcm2835.txt
@@ -0,0 +1,13 @@
+BCM2835 Random number generator
+
+Required properties:
+
+- compatible : should be "brcm,bcm2835-rng"
+- reg : Specifies base physical address and size of the registers.
+
+Example:
+
+rng {
+        compatible = "brcm,bcm2835-rng";
+        reg = <0x7e104000 0x10>;
+};
diff --git a/arch/arm/boot/dts/bcm2835.dtsi b/arch/arm/boot/dts/bcm2835.dtsi
index 7e0481e..dc22336 100644
--- a/arch/arm/boot/dts/bcm2835.dtsi
+++ b/arch/arm/boot/dts/bcm2835.dtsi
@@ -34,6 +34,11 @@
 			reg = <0x7e100000 0x28>;
 		};
 
+		rng {
+			compatible = "brcm,bcm2835-rng";
+			reg = <0x7e104000 0x10>;
+		};
+
 		uart@20201000 {
 			compatible = "brcm,bcm2835-pl011", "arm,pl011", "arm,primecell";
 			reg = <0x7e201000 0x1000>;
-- 
1.7.1

