Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210Ab3KMOIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:08:34 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:52810 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3KMOIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:08:31 -0500
From: Jonas Jensen <jonas.jensen@gmail.com>
To: devicetree@vger.kernel.org
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        Jonas Jensen <jonas.jensen@gmail.com>
Subject: [PATCH v2] Documentation: Add MDIO bus node to PHY binding document
Date: Wed, 13 Nov 2013 15:07:49 +0100
Message-Id: <1384351669-8325-1-git-send-email-jonas.jensen@gmail.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1384174825-14249-1-git-send-email-jonas.jensen@gmail.com>
References: <1384174825-14249-1-git-send-email-jonas.jensen@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add MDIO bus node segment and update the example,
allowing trivial bindings to break out boilerplate.

Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
---

Notes:
    Thanks Mark,
    
    This should have the changes from your comments. It also adds optional properties "compatible" and "reg", were those overlooked or left out intentionally?
    
    Changes since v1:
    
    1. reformat "MDIO bus node" description and add, node name should be "mdio"
    2. reformat property descriptions, describe what the cells represent
    3. add optional properties
    4. add a description after "PHY nodes"
    
    Applies to next-20131113

 Documentation/devicetree/bindings/net/phy.txt | 48 ++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 7cd18fb..4179a70 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -1,5 +1,26 @@
+MDIO Bus Nodes
+
+An MDIO bus node describes an MDIO bus, and is a container for PHY nodes
+as described below. An MDIO bus node should be named "mdio".
+
+Required properties:
+
+- #address-cells = Should be <1>, specifies the number of cells needed
+  to encode the PHY address
+- #size-cells = Should be <0>
+
+Optional Properties:
+
+- compatible : Should contain a specific name for the MDIO bus,
+  if known, followed by "-mdio"
+- reg : Should contain register location and length
+
+
 PHY nodes
 
+Describes the PHY chip. A MAC connecting the PHY may use a phandle to
+this node.
+
 Required properties:
 
  - device_type : Should be "ethernet-phy"
@@ -23,13 +44,24 @@ Optional Properties:
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

