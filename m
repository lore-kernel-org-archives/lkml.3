Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaDNTNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 15:13:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58063 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752573AbaDNTNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 15:13:11 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Rajendra Nayak <rnayak@ti.com>,
        Nishanth Menon <nm@ti.com>
Subject: [PATCH 2/2] ARM: dts: AM4372: add l3-noc information
Date: Mon, 14 Apr 2014 14:12:46 -0500
Message-ID: <1397502766-13994-3-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397502766-13994-1-git-send-email-nm@ti.com>
References: <1397502766-13994-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Afzal Mohammed <afzal@ti.com>

AM4372 has two clk domains 100f and 200s. Provide register mapping,
interrupt information and compatibility flags associated with it.

Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
Signed-off-by: Afzal Mohammed <afzal@ti.com>
Signed-off-by: Sekhar Nori <nsekhar@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
---
 arch/arm/boot/dts/am4372.dtsi |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/am4372.dtsi b/arch/arm/boot/dts/am4372.dtsi
index 36d523a..ef29037 100644
--- a/arch/arm/boot/dts/am4372.dtsi
+++ b/arch/arm/boot/dts/am4372.dtsi
@@ -67,11 +67,15 @@
 	};
 
 	ocp {
-		compatible = "simple-bus";
+		compatible = "ti,am4372-l3-noc", "simple-bus";
 		#address-cells = <1>;
 		#size-cells = <1>;
 		ranges;
 		ti,hwmods = "l3_main";
+		reg = <0x44000000 0x400000
+		       0x44800000 0x400000>;
+		interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 10 IRQ_TYPE_LEVEL_HIGH>;
 
 		prcm: prcm@44df0000 {
 			compatible = "ti,am4-prcm";
-- 
1.7.9.5

