Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaK0G1q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 01:27:46 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59586 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150AbaK0G04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 01:26:56 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 24/25] Phy: DT binding documentation for the Armada 375 USB cluster binding
Date: Thu, 27 Nov 2014 11:56:16 +0530
Message-ID: <1417069577-1169-25-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417069577-1169-1-git-send-email-kishon@ti.com>
References: <1417069577-1169-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gregory CLEMENT <gregory.clement@free-electrons.com>

Armada 375 comes with an USB2 host and device controller and an USB3
controller. The USB cluster control register allows to manage common
features of both USB controllers. This commit adds the Device Tree
binding documentation for this piece of hardware.

Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
Acked-by: Jason Cooper <jason@lakedaemon.net>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../devicetree/bindings/phy/phy-mvebu.txt          |   21 ++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/devicetree/bindings/phy/phy-mvebu.txt b/Documentation/devicetree/bindings/phy/phy-mvebu.txt
index 6cb3364..f95b626 100644
--- a/Documentation/devicetree/bindings/phy/phy-mvebu.txt
+++ b/Documentation/devicetree/bindings/phy/phy-mvebu.txt
@@ -20,3 +20,24 @@ Example:
 			#phy-cells = <0>;
 			status = "ok";
 		};
+
+Armada 375 USB cluster
+----------------------
+
+Armada 375 comes with an USB2 host and device controller and an USB3
+controller. The USB cluster control register allows to manage common
+features of both USB controllers.
+
+Required properties:
+
+- compatible: "marvell,armada-375-usb-cluster"
+- reg: Should contain usb cluster register location and length.
+- #phy-cells : from the generic phy bindings, must be 1. Possible
+values are 1 (USB2), 2 (USB3).
+
+Example:
+		usbcluster: usb-cluster@18400 {
+			compatible = "marvell,armada-375-usb-cluster";
+			reg = <0x18400 0x4>;
+			#phy-cells = <1>
+		};
-- 
1.7.9.5

