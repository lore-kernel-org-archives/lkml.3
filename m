Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273Ab3EBXtj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 19:49:39 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:36718 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab3EBXtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 19:49:07 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/5] ARM: dove: add DT nodes for irqchip conversion
Date: Fri,  3 May 2013 01:48:39 +0200
Message-Id: <1367538519-23940-6-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1367519104-19677-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1367538519-23940-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds required device tree nodes for irqchip conversion
on Dove. The nodes are named and layed out to allow seamless migration
to true DT enabled drivers as soon as they are available.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Changelog:
v1->v2:
- merge DT changes into this patch (Suggested by Jason Cooper)

Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory Clement <gregory.clement@free-electrons.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jean-Francois Moine <moinejf@free.fr>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 arch/arm/boot/dts/dove.dtsi |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/dove.dtsi b/arch/arm/boot/dts/dove.dtsi
index 6cab468..afb719a 100644
--- a/arch/arm/boot/dts/dove.dtsi
+++ b/arch/arm/boot/dts/dove.dtsi
@@ -30,11 +30,18 @@
 			marvell,tauros2-cache-features = <0>;
 		};
 
+		timer: timer {
+			compatible = "marvell,orion-timer";
+			reg = <0x20300 0x20>;
+			interrupts = <0>;
+			clocks = <&core_clk 0>;
+		};
+
 		intc: interrupt-controller {
 			compatible = "marvell,orion-intc";
 			interrupt-controller;
 			#interrupt-cells = <1>;
-			reg = <0x20204 0x04>, <0x20214 0x04>;
+			reg = <0x20200 0x10>, <0x20210 0x10>;
 		};
 
 		core_clk: core-clocks@d0214 {
@@ -202,6 +209,13 @@
 			status = "disabled";
 		};
 
+		gbe: ethernet-controller {
+			compatible = "marvell,mv643xx-eth-block";
+			reg = <0x72000 0x4000>;
+			interrupts = <29>, <30>;
+			status = "disabled";
+		};
+
 		rtc@d8500 {
 			compatible = "marvell,orion-rtc";
 			reg = <0xd8500 0x20>;
-- 
1.7.10.4

