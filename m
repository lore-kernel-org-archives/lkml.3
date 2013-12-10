Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab3LJTjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:39:51 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:58738 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3LJTjt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:39:49 -0500
Date: Tue, 10 Dec 2013 12:39:47 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Subject: [PATCH] dt: Document a compatible entry for MDIO ethernet Phys
Message-ID: <20131210193947.GU5429@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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
---
 Documentation/devicetree/bindings/net/phy.txt | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

Patch to parse this compatible string to follow if this binding is
acceptable.

Please see

http://www.spinics.net/lists/devicetree/msg13175.html

For discussion and a conceptual parsing patch.

diff --git a/Documentation/devicetree/bindings/net/phy.txt b/Documentation/devicetree/bindings/net/phy.txt
index 7cd18fb..d70b535 100644
--- a/Documentation/devicetree/bindings/net/phy.txt
+++ b/Documentation/devicetree/bindings/net/phy.txt
@@ -23,10 +23,18 @@ Optional Properties:
   assume clause 22. The compatible list may also contain other
   elements.
 
+  If the phy's identifier is known then the list may contain an entry
+  of the form: "ethernet-phy-idAAAA,BBBB" where
+     AAAA - The value of the 16 bit Phy Identifier 1 register as
+            4 hex digits. This is the chip vendor OUI bits 3:18
+     BBBB - The value of the 16 bit Phy Identifier 2 register as
+            4 hex digits. This is the chip vendor OUI bits 19:24,
+            followed by 10 bits of a vendor specific ID.
+
 Example:
 
 ethernet-phy@0 {
-	compatible = "ethernet-phy-ieee802.3-c22";
+	compatible = "ethernet-phy-id0141,0e90", "ethernet-phy-ieee802.3-c22";
 	linux,phandle = <2452000>;
 	interrupt-parent = <40000>;
 	interrupts = <35 1>;
-- 
1.8.1.2

