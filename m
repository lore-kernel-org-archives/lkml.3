Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab3FRLMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:12:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33281 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200Ab3FRLMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:12:06 -0400
From: Roger Quadros <rogerq@ti.com>
To: <tony@atomide.com>, <b-cousson@ti.com>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Roger Quadros <rogerq@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: [PATCH 2/4] ARM: dts: omap4-panda: Fix DVI EDID reads
Date: Tue, 18 Jun 2013 14:11:29 +0300
Message-ID: <1371553891-29364-3-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1371553891-29364-1-git-send-email-rogerq@ti.com>
References: <1371553891-29364-1-git-send-email-rogerq@ti.com>
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
 arch/arm/boot/dts/omap4-panda-common.dtsi |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/boot/dts/omap4-panda-common.dtsi b/arch/arm/boot/dts/omap4-panda-common.dtsi
index 7a21e8e..40df79e 100644
--- a/arch/arm/boot/dts/omap4-panda-common.dtsi
+++ b/arch/arm/boot/dts/omap4-panda-common.dtsi
@@ -80,6 +80,11 @@
 		gpio = <&gpio1 1 0>;	/* gpio_1 */
 		startup-delay-us = <70000>;
 		enable-active-high;
+		/*
+		 * FIXME: Remove boot-on when DSS can handle this regulator
+		 * for DVI EDID.
+		 */
+		regulator-boot-on;
 	};
 
 	/* HS USB Host PHY on PORT 1 */
-- 
1.7.4.1

