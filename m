Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbaENJuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:50:04 -0400
Received: from top.free-electrons.com ([176.31.233.9]:45063 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752862AbaENJtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:49:09 -0400
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
Subject: [PATCH v3 2/6] Documentation: bindings: add the Berlin SATA PHY
Date: Wed, 14 May 2014 11:48:58 +0200
Message-Id: <1400060942-10588-3-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1400060942-10588-1-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Berlin SATA PHY drives the PHY related to the SATA interface and
allows to power up/down each PHY independently. Add the corresponding
documentation.

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
---
 .../devicetree/bindings/phy/berlin-sata-phy.txt    | 34 ++++++++++++++++++++++
 1 file changed, 34 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/berlin-sata-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
new file mode 100644
index 000000000000..b1e11a25775a
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/berlin-sata-phy.txt
@@ -0,0 +1,34 @@
+Berlin SATA PHY
+---------------
+
+Required properties:
+- compatible: "marvell,berlin-sata-phy"
+- #address-cells: number of cells to encode an address, must be 1
+- #size-cells: number of cells representing the size of an address, must be 0
+- reg: address and length of the register
+
+The SATA PHY node is a provider and should contain sub-nodes representing the
+PHYs it handles, one per PHY.
+
+Required sub-node properties:
+- reg: the PHY described. 0 or 1.
+- #phy-cells: from the generic PHY bindings, must be 0
+
+Example:
+	sata_phy: phy@f7e900a0 {
+		compatible = "marvell,berlin-sata-phy";
+		reg = <0xf7e900a0 0x10>;
+		#address-cells = <1>;
+		#size-cells = <0>;
+		status = "okay";
+
+		sata_phy0: phy@0 {
+			reg = <0>;
+			#phy-cells = <0>;
+		};
+
+		sata_phy1: phy@1 {
+			reg = <1>;
+			#phy-cells = <0>;
+		};
+	};
-- 
1.9.1

