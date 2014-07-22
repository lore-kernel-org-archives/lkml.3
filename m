Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229AbaGVK7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:59:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56794 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754916AbaGVK5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:49 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 25/28] phy: qcom: Add device tree bindings for IPQ806x SATA PHY
Date: Tue, 22 Jul 2014 16:26:48 +0530
Message-ID: <1406026611-30493-26-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@codeaurora.org>

Add binding spec for Qualcomm SoC PHYs, starting with the SATA PHY on
the IPQ806x family of SoCs.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../bindings/phy/qcom-ipq806x-sata-phy.txt         |   23 ++++++++++++++++++++
 1 file changed, 23 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-ipq806x-sata-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/qcom-ipq806x-sata-phy.txt b/Documentation/devicetree/bindings/phy/qcom-ipq806x-sata-phy.txt
new file mode 100644
index 0000000..76bfbd0
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/qcom-ipq806x-sata-phy.txt
@@ -0,0 +1,23 @@
+Qualcomm IPQ806x SATA PHY Controller
+------------------------------------
+
+SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
+Each SATA PHY controller should have its own node.
+
+Required properties:
+- compatible: compatible list, contains "qcom,ipq806x-sata-phy"
+- reg: offset and length of the SATA PHY register set;
+- #phy-cells: must be zero
+- clocks: must be exactly one entry
+- clock-names: must be "cfg"
+
+Example:
+	sata_phy: sata-phy@1b400000 {
+		compatible = "qcom,ipq806x-sata-phy";
+		reg = <0x1b400000 0x200>;
+
+		clocks = <&gcc SATA_PHY_CFG_CLK>;
+		clock-names = "cfg";
+
+		#phy-cells = <0>;
+	};
-- 
1.7.9.5

