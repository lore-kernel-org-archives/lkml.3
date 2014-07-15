Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932562AbaGOLBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 07:01:43 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38469 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758043AbaGOLBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 07:01:36 -0400
From: Zhou Wang <wangzhou.bry@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Pekon Gupta <pekon@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Joern Engel <joern@logfs.org>, Randy Dunlap <rdunlap@infradead.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: wangzhou1@hisilicon.com, caizhiyong@huawei.com,
        Zhou Wang <wangzhou.bry@gmail.com>
Subject: [PATCH v1 3/3] mtd: hisilicon: add device tree binding documentation
Date: Tue, 15 Jul 2014 18:58:26 +0800
Message-Id: <1405421906-660-4-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1405421906-660-1-git-send-email-wangzhou.bry@gmail.com>
References: <1405421906-660-1-git-send-email-wangzhou.bry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
---
 .../devicetree/bindings/mtd/hisi-nand.txt          |   40 ++++++++++++++++++++
 1 file changed, 40 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/hisi-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/hisi-nand.txt b/Documentation/devicetree/bindings/mtd/hisi-nand.txt
new file mode 100644
index 0000000..c8b3988
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/hisi-nand.txt
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

