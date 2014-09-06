Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751457AbaIFIzW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 04:55:22 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:58534 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaIFIzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 04:55:18 -0400
From: Mikko Perttunen <cyndis@kapsi.fi>
To: swarren@wwwdotorg.org, thierry.reding@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org, wni@nvidia.com,
        Mikko Perttunen <mperttunen@nvidia.com>
Subject: [PATCH v3 2/5] of: Add nvidia,controller-id property to Tegra I2C bindings
Date: Sat,  6 Sep 2014 11:54:42 +0300
Message-Id: <1409993685-21911-3-git-send-email-cyndis@kapsi.fi>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
References: <1409993685-21911-1-git-send-email-cyndis@kapsi.fi>
X-SA-Exim-Connect-IP: 2001:708:30:12d0:beee:7bff:fe5b:f272
X-SA-Exim-Mail-From: cyndis@kapsi.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikko Perttunen <mperttunen@nvidia.com>

Sometimes, hardware blocks want to issue requests to devices
connected to I2C buses by itself. In such case, the bus the
target device resides on must be configured into a register.
For this purpose, each I2C controller has a defined ID known
by the hardware. Add a property for these IDs to the device tree
bindings, so that drivers can know what ID to write to a hardware
register when configuring a block that sends I2C messages autonomously.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Reviewed-by: Wei Ni <wni@nvidia.com>
Tested-by: Wei Ni <wni@nvidia.com>
---
 Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt b/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt
index 87507e9..e9e5994 100644
--- a/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt
+++ b/Documentation/devicetree/bindings/i2c/nvidia,tegra20-i2c.txt
@@ -57,6 +57,10 @@ Required properties:
   - rx
   - tx
 
+Optional properties:
+- nvidia,controller-id: ID of controller when referred to in
+                        hardware registers.
+
 Example:
 
 	i2c@7000c000 {
@@ -71,5 +75,6 @@ Example:
 		reset-names = "i2c";
 		dmas = <&apbdma 16>, <&apbdma 16>;
 		dma-names = "rx", "tx";
+		nvidia,controller-id = <0>;
 		status = "disabled";
 	};
-- 
2.1.0

