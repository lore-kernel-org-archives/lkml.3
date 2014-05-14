Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320AbaENJuA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:50:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45078 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753025AbaENJtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:49:10 -0400
From: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
To: sebastian.hesselbarth@gmail.com, tj@kernel.org, kishon@ti.com
Cc: =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/6] Documentation: bindings: add the berlin-ahci compatible to the ahci platform
Date: Wed, 14 May 2014 11:49:00 +0200
Message-Id: <1400060942-10588-5-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The berlin-ahci driver allows Berlin SoCs to support their AHCI SATA controller.
Add the compatible to the device tree bindings documentation.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 Documentation/devicetree/bindings/ata/ahci-berlin.txt | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/ata/ahci-berlin.txt

diff --git a/Documentation/devicetree/bindings/ata/ahci-berlin.txt b/Documentation/devicetree/bindings/ata/ahci-berlin.txt
new file mode 100644
index 000000000000..10362fdc5b8e
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/ahci-berlin.txt
@@ -0,0 +1,18 @@
+* Marvell Berlin SATA nodes
+
+Required properties:
+- compatible: "marvell,berlin-ahci"
+- interrupts: interrupt mapping for the SATA IRQ
+- reg: address and length of the register
+- phys: references to the SATA PHY nodes
+- phy-names: should be "port0" or/and "port1"
+
+Example:
+	ahci: sata@f7e90000 {
+		compatible = "marvell,berlin-ahci";
+		reg = <0xf7e90000 0x1000>;
+		interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
+		phys = <&sata_phy0>, <&sata_phy1>;
+		phy-names = "port0", "port1";
+		status = "okay";
+	};
-- 
1.9.1

