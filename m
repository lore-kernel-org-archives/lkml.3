Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab3KKNBS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 08:01:18 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47692 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753139Ab3KKNBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 08:01:04 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: devicetree@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH] Documentation: Add MDIO bus node to PHY binding document
Date: Mon, 11 Nov 2013 14:00:25 +0100
Message-Id: <1384174825-14249-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MDIO bus node segment and update the example,
allowing trivial bindings to break out boilerplate.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Changes per reply from Grant [0]
    
    [0] http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/208851.html
    
    Applies to next-20131111

 Documentation/devicetree/bindings/net/phy.txt | 37 +++++++++++++++++++++------
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 7cd18fb..4e58a5d 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -1,3 +1,13 @@
+MDIO Bus Nodes
+
+MDIO bus nodes describe an MDIO bus. It is a container for PHY nodes as
+described below.
+
+Required properties:
+- #address-cells = <1>;
+- #size-cells = <0>;
+
+
 PHY nodes
 
 Required properties:
@@ -23,13 +33,24 @@ Optional Properties:
   assume clause 22. The compatible list may also contain other
   elements.
 
+
 Example:
 
-ethernet-phy@0 {
-	compatible = "ethernet-phy-ieee802.3-c22";
-	linux,phandle = <2452000>;
-	interrupt-parent = <40000>;
-	interrupts = <35 1>;
-	reg = <0>;
-	device_type = "ethernet-phy";
-};
+mdio {
+	#address-cells = <1>;
+	#size-cells = <0>;
+
+	ethernet-phy@0 {
+		device_type = "ethernet-phy";
+		compatible = "...", "ethernet-phy-ieee802.3-c22";
+		reg = <0>;
+		interrupts = <24 0>;
+	}
+
+	ethernet-phy@1 {
+		device_type = "ethernet-phy";
+		compatible = "...";
+		reg = <1>;
+		interrupts = <35 1>;
+	}
+}
-- 
1.8.2.1

