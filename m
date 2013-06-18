Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932856Ab3FRQFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:05:31 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36180 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932644Ab3FRQFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:05:20 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH v2 2/4] ARM: dts: omap4-panda: Fix DVI EDID reads
Date: Tue, 18 Jun 2013 19:04:45 +0300
Message-ID: <1371571487-14389-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371571487-14389-1-git-send-email-rogerq@ti.com>
References: <1371571487-14389-1-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Panda the +5V supply for DVI EDID is supplied by the
same regulator that poweres the USB Hub. Currently, the
DSS/DVI subsystem doesn't know how to manage this regulator
and so DVI EDID reads will fail if USB Hub is not enabled.

As a temporary fix we keep this regulator permanently enabled
on boot. This fixes the DVI EDID read problem.

CC: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 arch/arm/boot/dts/omap4-panda-common.dtsi |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 7a21e8e..e6e6c39 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -80,6 +80,13 @@
 		gpio = <&gpio1 1 0>;	/* gpio_1 */
 		startup-delay-us = <70000>;
 		enable-active-high;
+		/*
+		 * boot-on is required along with always-on as the
+		 * regulator framework doesn't enable the regulator
+		 * if boot-on is not there.
+		 */
+		regulator-always-on;
+		regulator-boot-on;
 	};
 
 	/* HS USB Host PHY on PORT 1 */
-- 
1.7.4.1

