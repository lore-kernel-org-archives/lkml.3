Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaFQH6R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 03:58:17 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38223 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbaFQH6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 03:58:14 -0400
From: Zhangfei Gao <zhangfei.gao@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>, arnd@arndb.de,
        mark.rutland@arm.com, haifeng.yan@linaro.org, jchxue@gmail.com,
        zhangfei.gao@linaro.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Jiancheng Xue <xuejiancheng@huawei.com>
Subject: [PATCH 1/2] Documentation: Document Hisilicon hix5hd2 sata PHY
Date: Tue, 17 Jun 2014 15:58:00 +0800
Message-Id: <1402991881-27676-2-git-send-email-zhangfei.gao@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
References: <1402991881-27676-1-git-send-email-zhangfei.gao@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiancheng Xue <xuejiancheng@huawei.com>

Add necessary binding documentation SATA PHY on Hisilicon hix5hd2 soc.

Signed-off-by: Jiancheng Xue <xuejiancheng@huawei.com>
Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
---
 .../devicetree/bindings/phy/hix5hd2-sata-phy.txt   |   26 ++++++++++++++++++++
 1 file changed, 26 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt

diff --git a/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
new file mode 100644
index 0000000..ed15123
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/hix5hd2-sata-phy.txt
@@ -0,0 +1,26 @@
+Hisilicon hix5hd2 SATA PHY
+-----------------------
+
+Required properties:
+- compatible: should be "hisilicon,hix5hd2-sata-phy"
+- reg: offset and length of the PHY registers
+- #phy-cells: must be 0
+Refer to phy/phy-bindings.txt for the generic PHY binding properties
+
+Optional Properties:
+- hisilicon,peri-syscon: phandle of syscon used to control peripheral.
+- hisilicon,power-reg: offset and bit number of the sata power supply register.
+  Only effective when hisilicon,peri-syscon is supplied.
+- hisilicon,reg-init: one of more sets of 4 cells.  The first cell
+  is the register offset address, the second cell is the start bit in register,
+  the third cell means the bit width, and the fourth cell is the value to set.
+
+Example:
+	sata_phy: phy@f9900000 {
+		compatible = "hisilicon,hix5hd2-sata-phy";
+		reg = <0xf9900000 0x10000>;
+		#phy-cells = <0>;
+		hisilicon,peri-syscon = <&peri_ctrl>;
+		hisilicon,power-reg = <0x8 10>;
+		hisilicon,reg-init = <0x148 0 32 0x345cb8>,<0x14c 0 32 0x20545>;
+	};
-- 
1.7.9.5

