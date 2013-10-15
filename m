Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3JOFvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:51:00 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39034 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759116Ab3JOFu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:50:56 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <bcousson@baylibre.com>
CC: <tony@atomide.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <linux@arm.linux.org.uk>,
        <kishon@ti.com>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <rogerq@ti.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v2 2/2] ARM: dts: omap5: Add dr_mode for dwc3
Date: Tue, 15 Oct 2013 11:19:59 +0530
Message-ID: <1381816199-7966-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <52580F34.8030809@ti.com>
References: <52580F34.8030809@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: George Cherian <george.cherian@ti.com>

Added dr_mode property in dwc3 and set its default mode to device.
Currently dwc3 driver doesn't have support for OTG mode. So explicitly
setting to peripheral even dwc3 is a OTG controller since OMAP5 has
already got an EHCI host.

Signed-off-by: George Cherian <george.cherian@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
Changed the commit log to explain why dr_mode was not set to OTG.
 arch/arm/boot/dts/omap5.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
index 6d0a1d5..ef598af 100644
--- a/arch/arm/boot/dts/omap5.dtsi
+++ b/arch/arm/boot/dts/omap5.dtsi
@@ -652,6 +652,7 @@
 				reg = <0x4a030000 0x10000>;
 				interrupts = <GIC_SPI 92 IRQ_TYPE_LEVEL_HIGH>;
 				usb-phy = <&usb2_phy>, <&usb3_phy>;
+				dr_mode = "peripheral";
 				tx-fifo-resize;
 			};
 		};
-- 
1.7.10.4

