Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaELQ5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 12:57:31 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60074 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaELQ52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 12:57:28 -0400
From: Alexander Holler <holler@ahsoftware.de>
To: linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>, Jon Loeliger <jdl@jdl.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Alexander Holler <holler@ahsoftware.de>
Subject: [RFC PATCH 8/9] dt: deps: dts: kirkwood: dockstar: add dependency ehci -> usb power regulator
Date: Mon, 12 May 2014 18:47:59 +0200
Message-Id: <1399913280-6915-9-git-send-email-holler@ahsoftware.de>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
References: <1399913280-6915-1-git-send-email-holler@ahsoftware.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serves as an example how easy it is to fix an initialization order
if the order depends on the DT. No source code changes will be necessary.

If you look at the dependency graph for the dockstar, you will see that
there is no dependency between ehci and the usb power regulator. This
ends up with the fact that the regulator will be initialized after ehci.

Fix this by adding one dependency to the .dts.

Signed-off-by: Alexander Holler <holler@ahsoftware.de>
---
 arch/arm/boot/dts/kirkwood-dockstar.dts | 4 ++++
 arch/arm/boot/dts/kirkwood.dtsi         | 2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/kirkwood-dockstar.dts b/arch/arm/boot/dts/kirkwood-dockstar.dts
index f31312e..0ca7456 100644
--- a/arch/arm/boot/dts/kirkwood-dockstar.dts
+++ b/arch/arm/boot/dts/kirkwood-dockstar.dts
@@ -106,3 +106,7 @@
 		phy-handle = <&ethphy0>;
 	};
 };
+
+&ehci {
+	dependencies = <&usb_power>;
+};
diff --git a/arch/arm/boot/dts/kirkwood.dtsi b/arch/arm/boot/dts/kirkwood.dtsi
index 6abf44d..54a1223 100644
--- a/arch/arm/boot/dts/kirkwood.dtsi
+++ b/arch/arm/boot/dts/kirkwood.dtsi
@@ -185,7 +185,7 @@
 			status = "okay";
 		};
 
-		ehci@50000 {
+		ehci: ehci@50000 {
 			compatible = "marvell,orion-ehci";
 			reg = <0x50000 0x1000>;
 			interrupts = <19>;
-- 
1.8.3.1

