Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179AbaLAK1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:27:46 -0500
Received: from down.free-electrons.com ([37.187.137.238]:50491 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753133AbaLAK1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:27:42 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v3 11/11] ARM: at91/dt: add NOR definition in sama5d3xcm dtsi
Date: Mon,  1 Dec 2014 11:27:27 +0100
Message-Id: <1417429647-3419-12-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1417429647-3419-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sama5d3 evaluation kit embeds a NOR chip which is connected through
the EBI.
Define this NOR chip in the CPU module dtsi.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3xcm.dtsi | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3xcm.dtsi b/arch/arm/boot/dts/sama5d3xcm.dtsi
index cfcd200..92be776 100644
--- a/arch/arm/boot/dts/sama5d3xcm.dtsi
+++ b/arch/arm/boot/dts/sama5d3xcm.dtsi
@@ -75,6 +75,40 @@
 			};
 		};
 
+		ebi@10000000 {
+			pinctrl-0 = <&pinctrl_ebi_addr &pinctrl_ebi_cs0>;
+
+			cs@0 {
+				#address-cells = <2>;
+				#size-cells = <1>;
+				ranges;
+				atmel,generic-dev;
+				atmel,read-mode = "nrd";
+				atmel,write-mode = "nwe";
+				atmel,bus-width = <16>;
+				atmel,ncs-rd-setup-ns = <0>;
+				atmel,ncs-wr-setup-ns = <0>;
+				atmel,nwe-setup-ns = <8>;
+				atmel,nrd-setup-ns = <16>;
+				atmel,ncs-rd-pulse-ns = <84>;
+				atmel,ncs-wr-pulse-ns = <84>;
+				atmel,nrd-pulse-ns = <76>;
+				atmel,nwe-pulse-ns = <76>;
+				atmel,nrd-cycle-ns = <107>;
+				atmel,nwe-cycle-ns = <84>;
+				atmel,tdf-ns = <16>;
+
+				nor: flash@0,0 {
+					compatible = "cfi-flash";
+					linux,mtd-name = "physmap-flash.0";
+					#address-cells = <1>;
+					#size-cells = <1>;
+					reg = <0x0 0x0 0x1000000>;
+					bank-width = <2>;
+				};
+			};
+		};
+
 		nand0: nand@60000000 {
 			nand-bus-width = <8>;
 			nand-ecc-mode = "hw";
-- 
1.9.1

