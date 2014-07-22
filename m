Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaGVK5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:57:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56786 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754770AbaGVK5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:57:36 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <kishon@ti.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/28] phy: qcom: Add APQ8064 SATA PHY device tree bindings
Date: Tue, 22 Jul 2014 16:26:40 +0530
Message-ID: <1406026611-30493-18-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406026611-30493-1-git-send-email-kishon@ti.com>
References: <1406026611-30493-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

This patch adds binding spec for Qualcomm AP8064 SATA PHY.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Kiran Padwal <kiran.padwal@smartplayin.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
 .../bindings/phy/qcom-apq8064-sata-phy.txt         |   24 ++++++++++++++++++++
 1 file changed, 24 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt b/Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt
new file mode 100644
index 0000000..952f6c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/qcom-apq8064-sata-phy.txt
@@ -0,0 +1,24 @@
+Qualcomm APQ8064 SATA PHY Controller
+------------------------------------
+
+SATA PHY nodes are defined to describe on-chip SATA Physical layer controllers.
+Each SATA PHY controller should have its own node.
+
+Required properties:
+- compatible: compatible list, contains "qcom,apq8064-sata-phy".
+- reg: offset and length of the SATA PHY register set;
+- #phy-cells: must be zero
+- clocks: a list of phandles and clock-specifier pairs, one for each entry in
+  clock-names.
+- clock-names: must be "cfg" for phy config clock.
+
+Example:
+	sata_phy: sata-phy@1b400000 {
+		compatible = "qcom,apq8064-sata-phy";
+		reg = <0x1b400000 0x200>;
+
+		clocks = <&gcc SATA_PHY_CFG_CLK>;
+		clock-names = "cfg";
+
+		#phy-cells = <0>;
+	};
-- 
1.7.9.5

