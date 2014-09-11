Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083AbaIKNWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 09:22:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46009 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757056AbaIKNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 09:21:57 -0400
From: Boris BREZILLON <boris.brezillon@free-electrons.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Johan Hovold <jhovold@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 9/9] mfd: syscon: add Atmel GPBR DT bindings documention
Date: Thu, 11 Sep 2014 15:18:45 +0200
Message-Id: <1410441525-25258-10-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
References: <1410441525-25258-1-git-send-email-boris.brezillon@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPBR block provides a set of battery-backed registers that can be used
to save data which need to be kept when the system is powered down and
VDD-core is maintained by an external battery.

A typical usage is the RTT block (when used as an RTC) which needs one of
those registers to save the current time.

Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
---
 Documentation/devicetree/bindings/mfd/atmel,gpbr.txt | 15 +++++++++++++++
 1 file changed, 15 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/mfd/atmel,gpbr.txt

diff --git a/Documentation/devicetree/bindings/mfd/atmel,gpbr.txt b/Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
new file mode 100644
index 0000000..a285695
--- /dev/null
+++ b/Documentation/devicetree/bindings/mfd/atmel,gpbr.txt
@@ -0,0 +1,15 @@
+* Device tree bindings for Atmel GPBR (General Purpose Backup Registers)
+
+The GPBR are a set of battery-backed registers.
+
+Required properties:
+- compatible:		"atmel,at91sam9260-gpbr", "syscon"
+- reg:			contains offset/length value of the GPBR memory
+			region.
+
+Example:
+
+gpbr: gpbr@fffffd50 {
+	compatible = "atmel,at91sam9260-gpbr", "syscon";
+	reg = <0xfffffd50 0x10>;
+};
-- 
1.9.1

