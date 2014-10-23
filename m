Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaJWOGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:06:19 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:65438 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbaJWOGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:06:13 -0400
From: Zhou Wang <wangzhou.bry@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org
Cc: mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        robh+dt@kernel.org, galak@codeaurora.org, caizhiyong@huawei.com,
        haojian.zhuang@gmail.com, xuwei5@hisilicon.com,
        wangzhou1@hisilicon.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Zhou Wang <wangzhou.bry@gmail.com>
Subject: [PATCH v2 2/2] mtd: hisilicon: add device tree binding documentation
Date: Thu, 23 Oct 2014 22:04:45 +0800
Message-Id: <1414073085-19296-3-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1414073085-19296-1-git-send-email-wangzhou.bry@gmail.com>
References: <1414073085-19296-1-git-send-email-wangzhou.bry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
---
 .../devicetree/bindings/mtd/hisi504-nand.txt       |   40 ++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/hisi504-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/hisi504-nand.txt b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
new file mode 100644
index 0000000..c8b3988
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/hisi504-nand.txt
@@ -0,0 +1,40 @@
+Hisilicon Hip04 Soc NAND controller DT binding
+
+Required properties:
+- compatible:          Should be "hisilicon,504-nfc".
+- reg:                 The first contains base physical address and size of
+                       NAND controller's registers. The second contains base
+                       physical address and size of NAND controller's buffer.
+- interrupts:          Interrupt number for nfc.
+- nand-bus-width:      See nand.txt.
+- nand-ecc-mode:       See nand.txt.
+- hisi,nand-ecc-bits:  ECC bits type support.
+                 <0>:  none ecc
+                 <1>:  Can correct 1bit per 512byte.
+                 <6>:  Can correct 16bits per 1K byte.
+- #address-cells:      partition address, should be set 1.
+- #size-cells:         partition size, should be set 1.
+
+Flash chip may optionally contain additional sub-nodes describing partitions of
+the address space. See partition.txt for more detail.
+
+Example:
+
+	nand: nand@4020000 {
+		compatible = "hisilicon,504-nfc";
+		reg = <0x4020000 0x10000>, <0x5000000 0x1000>;
+		interrupts = <0 379 4>;
+		nand-bus-width = <8>;
+		nand-ecc-mode = "hw";
+		hisi,nand-ecc-bits = <1>;
+		#address-cells = <1>;
+		#size-cells = <1>;
+
+		partition@0 {
+			label = "nand_text";
+			reg = <0x00000000 0x00400000>;
+		};
+
+		...
+
+	};
-- 
1.7.9.5

