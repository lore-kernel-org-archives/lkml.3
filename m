Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755298AbaAHGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:16:59 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:52759 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbaAHGQ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:16:29 -0500
From: Roger Quadros <rogerq@ti.com>
To: <bcousson@baylibre.com>, <tony@atomide.com>
CC: <balbi@ti.com>, <arnd@arndb.de>, <linux-omap@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>
Subject: [PATCH v4 4/5] ARM: dts: omap5-uevm: Provide USB PHY clock
Date: Wed, 8 Jan 2014 11:45:41 +0530
Message-ID: <1389161742-10533-5-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389161742-10533-1-git-send-email-rogerq@ti.com>
References: <1389161742-10533-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The HS USB 2 PHY gets its clock from AUXCLK1. Provide this
information.

Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap5-uevm.dts | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/omap5-uevm.dts b/arch/arm/boot/dts/omap5-uevm.dts
index 002fa70..3b99ec2 100644
--- a/arch/arm/boot/dts/omap5-uevm.dts
+++ b/arch/arm/boot/dts/omap5-uevm.dts
@@ -31,12 +31,8 @@
 	hsusb2_phy: hsusb2_phy {
 		compatible = "usb-nop-xceiv";
 		reset-gpios = <&gpio3 16 GPIO_ACTIVE_LOW>; /* gpio3_80 HUB_NRESET */
-	/**
-	  * FIXME
-	  * Put the right clock phandle here when available
-	  *	clocks = <&auxclk1>;
-	  *	clock-names = "main_clk";
-	  */
+		clocks = <&auxclk1_ck>;
+		clock-names = "main_clk";
 		clock-frequency = <19200000>;
 	};
 
-- 
1.8.3.2

