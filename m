Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab3CUUdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 16:33:07 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5914 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770Ab3CUUdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 16:33:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 21 Mar 2013 13:33:03 -0700
From: Rhyland Klein <rklein@nvidia.com>
To: Anton Vorontsov <cbou@mail.ru>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Rhyland Klein <rklein@nvidia.com>
Subject: [PATCH 1/2] power_supply: tps65090: Update bindings for subnode
Date: Thu, 21 Mar 2013 16:33:04 -0400
Message-ID: <1363897985-19980-1-git-send-email-rklein@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the DT documentation to reflect that the tps65090-charger
should be represented as a child node of the tps65090 device itself.

Signed-off-by: Rhyland Klein <rklein@nvidia.com>
---
 .../devicetree/bindings/power_supply/tps65090.txt  |   18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/power_supply/tps65090.txt b/Documentation/devicetree/bindings/power_supply/tps65090.txt
index 56370c7..8e5e0d3 100644
--- a/Documentation/devicetree/bindings/power_supply/tps65090.txt
+++ b/Documentation/devicetree/bindings/power_supply/tps65090.txt
@@ -1,23 +1,17 @@
 TPS65090 Frontend PMU with Switchmode Charger
 
 Required Properties:
--compatible: "ti,tps65090"
--reg: I2C slave address
--interrupts: the interrupt output to which this device connects
+-compatible: "ti,tps65090-charger"
 
 Optional Properties:
 -ti,enable-low-current-chrg: Enables charging when a low current is detected
  while the default logic is to stop charging.
 
-Example:
+This node is a subnode of the tps65090 PMIC.
 
-	tps65090@48 {
-		compatible = "ti,tps65090";
-		reg = <0x48>;
-		interrupts = <0 88 0x4>;
+Example:
 
+	tps65090-charger {
+		compatible = "ti,tps65090-charger";
 		ti,enable-low-current-chrg;
-
-		regulators {
-			...
-		};
+	};
-- 
1.7.9.5

