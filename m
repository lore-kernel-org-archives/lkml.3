Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaF3IHW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:07:22 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54555 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778AbaF3IGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:06:25 -0400
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
Subject: [PATCH 3/3] mtd: hisilicon: add device tree binding documentation
Date: Mon, 30 Jun 2014 16:03:29 +0800
Message-Id: <1404115409-20200-4-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com>
References: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
---
 .../devicetree/bindings/mtd/hisi-nand.txt          |   38 ++++++++++++++++++++
 1 file changed, 38 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mtd/hisi-nand.txt

diff --git a/Documentation/devicetree/bindings/mtd/hisi-nand.txt b/Documentation/devicetree/bindings/mtd/hisi-nand.txt
new file mode 100644
index 0000000..1cc6470
--- /dev/null
+++ b/Documentation/devicetree/bindings/mtd/hisi-nand.txt
@@ -0,0 +1,38 @@
+Hisilicon Hip04 Soc NAND controller DT binding
+
+Required properties:
+- compatible:          Should be "hisilicon,nfc504".
+- reg:                 Contain registers location and length for reg and data.
+- interrupts:          Interrupt number for nfc.
+- nand-bus-width:      See nand.txt.
+- nand-ecc-mode:       See nand.txt.
+- hisi,nand-ecc-bits:  ECC bits type support.
+		<0>:   none ecc
+		<1>:   Can correct 1bit per 512byte.
+		<6>:   Can correct 16bits per 1K byte.
+- #address-cells:      partition address.
+- #size-cells:         partition size.
+
+Flash chip may optionally contain additional sub-nodes describing partitions of
+the address space. See partition.txt for more detail.
+
+Example:
+
+	nand: nand@4020000 {
+		compatible = "hisilicon,nfc504";
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

