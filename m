Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3HNSXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:23:37 -0400
Received: from smtp97.ord1c.emailsrvr.com ([108.166.43.97]:55785 "EHLO
	smtp97.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753893Ab3HNSXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:23:35 -0400
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
To: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org,
        devicetree@vger.kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ian.campbell@citrix.com,
        rob.herring@calxeda.com, sergei.shtylyov@cogentembedded.com
Cc: Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: [PATCH v4 1/3] devicetree: create a separate binding description for sata_highbank
Date: Wed, 14 Aug 2013 13:23:30 -0500
Message-Id: <1376504612-17340-1-git-send-email-mark.langsdorf@calxeda.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Calxeda sata_highbank driver has been adding its descriptions to the
ahci driver. Separate them properly. This patch only affects
documentation and has no functional component.

Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
Changes from v3
	Added all optional properties to the example.
	Expanded the description.
	Renumbered the patch series since the first two got accepted.
Changes from v2
	Fixed some indenting.
Changes from v1
	None.

 Documentation/devicetree/bindings/ata/sata_highbank.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
index 1ac6d3d..e7a6f28 100644
--- a/Documentation/devicetree/bindings/ata/sata_highbank.txt
+++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
@@ -12,7 +12,7 @@ Required properties:
 
 Optional properties:
 - dma-coherent      : Present if dma operations are coherent
-- calxeda,port-phys: phandle-combophy and lane assignment, which maps each
+- calxeda,port-phys : phandle-combophy and lane assignment, which maps each
 			SATA port to a combophy and a lane within that
 			combophy
 - calxeda,sgpio-gpio: phandle-gpio bank, bit offset, and default on or off,
@@ -26,7 +26,9 @@ Example:
 		compatible = "calxeda,hb-ahci";
 		reg = <0xffe08000 0x1000>;
 		interrupts = <115>;
+		dma-coherent;
 		calxeda,port-phys = <&combophy5 0 &combophy0 0 &combophy0 1
 					&combophy0 2 &combophy0 3>;
-
+		calxeda,sgpio-gpio =<&gpioh 5 1 &gpioh 6 1 &gpioh 7 1>;
+		calxeda,led-order = <4 0 1 2 3>;
         };
-- 
1.8.1.2

