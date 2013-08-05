Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3HEPge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 11:36:34 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49134 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753773Ab3HEPgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 11:36:32 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Aug 2013 11:36:32 EDT
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-omap@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Subject: [PATCH] ARM: DTS: SAMA5: Add PMU support
Date: Mon,  5 Aug 2013 17:26:06 +0200
Message-Id: <1375716366-19121-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM Performance Monitor Units are available on the sama5d3, add the support in
the dtsi.

Tested with perf and oprofile on the sama5d31ek.

Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
---
 arch/arm/boot/dts/sama5d3.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/boot/dts/sama5d3.dtsi b/arch/arm/boot/dts/sama5d3.dtsi
index a1d5e25..afa68ac 100644
--- a/arch/arm/boot/dts/sama5d3.dtsi
+++ b/arch/arm/boot/dts/sama5d3.dtsi
@@ -48,6 +48,11 @@
 		};
 	};
 
+       pmu {
+               compatible = "arm,cortex-a5-pmu";
+               interrupts = <46 IRQ_TYPE_LEVEL_HIGH 0>;
+       };
+
 	memory {
 		reg = <0x20000000 0x8000000>;
 	};
-- 
1.8.1.2

