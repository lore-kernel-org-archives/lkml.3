Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbaGPQKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 12:10:24 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45611 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030363AbaGPQKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 12:10:15 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Kumar Gala <galak@codeaurora.org>, linux-ide@vger.kernel.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Tejun Heo <tj@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Subject: [PATCH v8 2/2] phy: qcom: Add device tree bindings for IPQ806x SATA PHY
Date: Wed, 16 Jul 2014 11:10:09 -0500
Message-Id: <1405527009-17539-2-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1405527009-17539-1-git-send-email-galak@codeaurora.org>
References: <1405527009-17539-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add binding spec for Qualcomm SoC PHYs, starting with the SATA PHY on
the IPQ806x family of SoCs.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
v8, v7:
* no change

v6:
* Moved binding to qcom-ipq806x-sata-phy.txt instead of qcom-phy.txt

 .../bindings/phy/qcom-ipq806x-sata-phy.txt         | 23 ++++++++++++++++++++++
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
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

