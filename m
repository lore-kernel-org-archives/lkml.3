Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbaF3IGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 04:06:12 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:47031 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518AbaF3IGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 04:06:08 -0400
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
Subject: [PATCH 1/3] mtd: hisilicon: add device tree node for nand controller
Date: Mon, 30 Jun 2014 16:03:27 +0800
Message-Id: <1404115409-20200-2-git-send-email-wangzhou.bry@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com>
References: <1404115409-20200-1-git-send-email-wangzhou.bry@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Zhou Wang <wangzhou.bry@gmail.com>
---
 arch/arm/boot/dts/hip04.dtsi |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/arch/arm/boot/dts/hip04.dtsi b/arch/arm/boot/dts/hip04.dtsi
index abb42ca..e63fc61 100644
--- a/arch/arm/boot/dts/hip04.dtsi
+++ b/arch/arm/boot/dts/hip04.dtsi
@@ -386,5 +386,36 @@
 				interrupts = <0 389 4>;
 			};
 		};
+
+		nand: nand@4020000 {
+			compatible = "hisilicon,504-nfc";
+			reg = <0x4020000 0x10000>, <0x5000000 0x1000>;
+			interrupts = <0 379 4>;
+			nand-bus-width = <8>;
+			nand-ecc-mode = "none";
+			hisi,nand-ecc-bits = <0>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+
+			partition@0 {
+				label = "nand_text";
+				reg = <0x00000000 0x00400000>;
+			};
+
+			partition@00400000 {
+				label = "nand_monitor";
+				reg = <0x00400000 0x00400000>;
+			};
+
+			partition@00800000 {
+				label = "nand_kernel";
+				reg = <0x00800000 0x00800000>;
+			};
+
+			partition@01000000 {
+				label = "nand_fs";
+				reg = <0x01000000 0x1f000000>;
+			};
+		};
 	};
 };
-- 
1.7.9.5

