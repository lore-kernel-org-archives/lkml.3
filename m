Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaCLVFY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 17:05:24 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:60891 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbaCLVFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 17:05:18 -0400
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rob Herring <robh+dt@kernel.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 RESEND 1/2] dt: Document a compatible entry for MDIO ethernet Phys
Date: Wed, 12 Mar 2014 15:05:10 -0600
Message-Id: <1394658311-17769-1-git-send-email-jgunthorpe@obsidianresearch.com>
X-Mailer: git-send-email 1.8.1.2
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This describes a compatible entry of the form:
  ethernet-phy-idAAAA,BBBB
Which is modelled after the PCI structured compatible entry
(pciVVVV,DDDD.SSSS.ssss.RR)

If present the OF core will be able to use this information to
directly create the correct phy without auto probing the bus.

Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/net/phy.txt | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

This version is just a resend rebased against 3.14-rc6, with the minor merge
conflicts resolved.

I'm not sure who is supposed to pick this patch up?

diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 58307d0..5b8c589 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -21,10 +21,18 @@ Optional Properties:
   elements.
 - max-speed: Maximum PHY supported speed (10, 100, 1000...)
 
+  If the phy's identifier is known then the list may contain an entry
+  of the form: "ethernet-phy-idAAAA.BBBB" where
+     AAAA - The value of the 16 bit Phy Identifier 1 register as
+            4 hex digits. This is the chip vendor OUI bits 3:18
+     BBBB - The value of the 16 bit Phy Identifier 2 register as
+            4 hex digits. This is the chip vendor OUI bits 19:24,
+            followed by 10 bits of a vendor specific ID.
+
 Example:
 
 ethernet-phy@0 {
-	compatible = "ethernet-phy-ieee802.3-c22";
+	compatible = "ethernet-phy-id0141.0e90", "ethernet-phy-ieee802.3-c22";
 	interrupt-parent = <40000>;
 	interrupts = <35 1>;
 	reg = <0>;
-- 
1.8.1.2

