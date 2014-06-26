Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbaFZHO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 03:14:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48776 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756110AbaFZHOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 03:14:16 -0400
From: Sricharan R <r.sricharan@ti.com>
To: <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: <tony@atomide.com>, <santosh.shilimkar@ti.com>, <nm@ti.com>,
        <rnayak@ti.com>, <linux@arm.linux.org.uk>, <r.sricharan@ti.com>,
        <tglx@linutronix.de>, <jason@lakedaemon.net>, <joe@perches.com>
Subject: [PATCH V4 15/16] documentation: dt: omap: crossbar: Add description for interrupt consumer
Date: Thu, 26 Jun 2014 12:40:33 +0530
Message-ID: <1403766634-18543-16-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
References: <1403766634-18543-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

The current crossbar description does not include the description
required for the consumer of the crossbar, a.k.a devices whoes events
pass through the crossbar into the GIC interrupt controller.

So, provide documentation for the same.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sricharan R <r.sricharan@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 .../devicetree/bindings/arm/omap/crossbar.txt      |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/omap/crossbar.txt b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
index 6923531..35356b6 100644
--- a/Documentation/devicetree/bindings/arm/omap/crossbar.txt
+++ b/Documentation/devicetree/bindings/arm/omap/crossbar.txt
@@ -36,3 +36,20 @@ Examples:
 			ti,irqs-reserved = <0 1 2 3 5 6 131 132 139 140>;
 			ti,irqs-skip = <10 133 139 140>;
 		};
+
+Consumer:
+========
+See Documentation/devicetree/bindings/interrupt-controller/interrupts.txt and
+Documentation/devicetree/bindings/arm/gic.txt for further details.
+
+An interrupt consumer on an SoC using crossbar will use:
+	interrupts = <GIC_SPI request_number interrupt_level>
+request number shall be between 0 to that described by
+"ti,max-crossbar-sources"
+
+Example:
+	device_x@0x4a023000 {
+		/* Crossbar 8 used */
+		interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
+		...
+	};
-- 
1.7.9.5

