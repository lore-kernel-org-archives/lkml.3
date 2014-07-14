Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaGNLSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:18:25 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:48191 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaGNLSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:18:12 -0400
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-ide@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH v4 2/2] phy: qcom: Add APQ8064 SATA PHY device tree bindings
Date: Mon, 14 Jul 2014 12:18:08 +0100
Message-Id: <1405336688-32221-1-git-send-email-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405336651-32135-1-git-send-email-srinivas.kandagatla@linaro.org>
References: <1405336651-32135-1-git-send-email-srinivas.kandagatla@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds binding spec for Qualcomm AP8064 SATA PHY.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 .../bindings/phy/qcom-apq8064-sata-phy.txt         | 24 ++++++++++++++++++++++
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
1.9.1

