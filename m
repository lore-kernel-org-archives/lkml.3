Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaFLTNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:13:33 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44200 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFLTNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:13:31 -0400
From: Kumar Gala <galak@codeaurora.org>
To: Tejun Heo <tj@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>, linux-ide@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 3/3] ata: qcom: Add device tree bindings information
Date: Thu, 12 Jun 2014 14:13:24 -0500
Message-Id: <1402600404-19214-3-git-send-email-galak@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1402600404-19214-1-git-send-email-galak@codeaurora.org>
References: <1402600404-19214-1-git-send-email-galak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add device tree binding for Qualcomm AHCI SATA controller and specifically
the sata controller on the IPQ806x family of SoCs.

Signed-off-by: Kumar Gala <galak@codeaurora.org>
---
 .../devicetree/bindings/ata/qcom-sata.txt          | 40 ++++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/qcom-sata.txt

diff --git a/Documentation/devicetree/bindings/ata/qcom-sata.txt b/Documentation/devicetree/bindings/ata/qcom-sata.txt
new file mode 100644
index 0000000..5e74e41
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/qcom-sata.txt
@@ -0,0 +1,40 @@
+* Qualcomm AHCI SATA Controller
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+Each SATA controller should have its own node.
+
+Required properties:
+- compatible		: compatible list, contains "qcom,msm-ahci"
+- interrupts		: <interrupt mapping for SATA IRQ>
+- reg			: <registers mapping>
+- phys			: Must contain exactly one entry as specified
+			  in phy-bindings.txt
+- phy-names		: Must be "sata-phy"
+
+Required properties for "qcom,ipq806x-ahci" compatible:
+- clocks		: Must contain an entry for each entry in clock-names.
+- clock-names		: Shall be:
+				"slave_iface" - Fabric port AHB clock for SATA
+				"iface" - AHB clock
+				"core" - core clock
+				"rxoob" - RX out-of-band clock
+				"pmalive" - Power Module Alive clock
+
+Example:
+	sata@29000000 {
+		compatible = "qcom,ipq806x-ahci", "qcom,msm-ahci";
+		reg = <0x29000000 0x180>;
+
+		interrupts = <0 209 0x0>;
+
+		clocks = <&gcc SFAB_SATA_S_H_CLK>,
+			 <&gcc SATA_H_CLK>,
+			 <&gcc SATA_A_CLK>,
+			 <&gcc SATA_RXOOB_CLK>,
+			 <&gcc SATA_PMALIVE_CLK>;
+		clock-names = "slave_iface", "iface", "core",
+				"rxoob", "pmalive";
+
+		phys = <&sata_phy>;
+		phy-names = "sata-phy";
+	};
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation

