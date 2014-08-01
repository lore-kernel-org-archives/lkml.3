Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461AbaHAGOO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 02:14:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33847 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHAGOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 02:14:11 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <robh+dt@kernel.org>
CC: <khilman@deeprootsystems.com>, <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>,
        <davinci-linux-open-source@linux.davincidsp.com>, <pawel.moll@arm.com>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/6] ARM: DTS: da850: Add node for McASP
Date: Fri, 1 Aug 2014 09:13:27 +0300
Message-ID: <1406873610-5037-4-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
References: <1406873610-5037-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Node for mcasp0

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/boot/dts/da850.dtsi | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
index 41ce4e8bf227..0bd98cd00816 100644
--- a/arch/arm/boot/dts/da850.dtsi
+++ b/arch/arm/boot/dts/da850.dtsi
@@ -276,6 +276,19 @@
 			ti,davinci-gpio-unbanked = <0>;
 			status = "disabled";
 		};
+
+		mcasp0: mcasp@01d00000 {
+			compatible = "ti,da830-mcasp-audio";
+			reg = <0x100000 0x2000>,
+			      <0x102000 0x400000>;
+			reg-names = "mpu", "dat";
+			interrupts = <54>;
+			interrupt-names = "common";
+			status = "disabled";
+			dmas = <&edma0 1>,
+				<&edma0 0>;
+			dma-names = "tx", "rx";
+		};
 	};
 	nand_cs3@62000000 {
 		compatible = "ti,davinci-nand";
-- 
2.0.2

