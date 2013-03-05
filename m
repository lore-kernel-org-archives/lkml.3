Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab3CEWQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 17:16:53 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:58339 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3CEWQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 17:16:51 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        linux-omap@vger.kernel.org
Subject: [PATCH 5/9] ARM: omap1: add back missing includes
Date: Tue,  5 Mar 2013 23:16:45 +0100
Message-Id: <1362521809-22989-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362521809-22989-1-git-send-email-arnd@arndb.de>
References: <1362521809-22989-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:dZEil615teRfxIemLsgX2QKEyQ0zYNATGW9WaiwIuOJ
 khn6uB35OfiO1r3vSV4Z4lVBGZFxrz3J5wA5wfzXtQv2iTlrxF
 ZDT0Hm8JhRrjdaacPExVaaVj+gVZOI3TadImZwdECZIxZ5c6ez
 nc7FsRct3e5463s4mZpTGziFNG+bo4p0n8msROoEgra1wRqOaJ
 96huNcr91xEteOWh0FoTNoY9ou0R1KL3btYH8MtPK3YHVxKg5S
 jHkRQeFSb0/mI/vL3EwIl0iX6wnY2G8q57zVdHSPc3owa99UAb
 nlisUSZ9G8Dy0KiFm386kl9RLS4fux0jJn+DKnBhdCgohFGRgY
 gaT8M4JFAya4tcgvgXQ6l6cDiTISAd4niWwe3uoYz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent reorganization of OMAP header files caused a couple of
files that used to be implicitly included now missing from OMAP1.
This adds explicit inclusions of mach/irqs.h and mach/hardware.h
in all files that need them for an OMAP1 allyesconfig build.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org
---
 arch/arm/mach-omap1/board-fsample.c  | 1 +
 arch/arm/mach-omap1/board-h2.c       | 1 +
 arch/arm/mach-omap1/board-perseus2.c | 1 +
 arch/arm/mach-omap1/board-sx1.c      | 1 +
 drivers/video/omap/lcd_ams_delta.c   | 1 +
 drivers/video/omap/lcd_osk.c         | 1 +
 6 files changed, 6 insertions(+)

diff --git a/arch/arm/mach-omap1/board-fsample.c b/arch/arm/mach-omap1/board-fsample.c
index 702d580..512b33a 100644
--- a/arch/arm/mach-omap1/board-fsample.c
+++ b/arch/arm/mach-omap1/board-fsample.c
@@ -33,6 +33,7 @@
 #include <linux/platform_data/keypad-omap.h>
 
 #include <mach/hardware.h>
+#include <mach/irqs.h>
 
 #include "iomap.h"
 #include "common.h"
diff --git a/arch/arm/mach-omap1/board-h2.c b/arch/arm/mach-omap1/board-h2.c
index 0dac3d2..99ee4d7 100644
--- a/arch/arm/mach-omap1/board-h2.c
+++ b/arch/arm/mach-omap1/board-h2.c
@@ -47,6 +47,7 @@
 
 #include <mach/hardware.h>
 #include <mach/usb.h>
+#include <mach/irqs.h>
 
 #include "common.h"
 #include "board-h2.h"
diff --git a/arch/arm/mach-omap1/board-perseus2.c b/arch/arm/mach-omap1/board-perseus2.c
index 8b2f712..403efcc 100644
--- a/arch/arm/mach-omap1/board-perseus2.c
+++ b/arch/arm/mach-omap1/board-perseus2.c
@@ -31,6 +31,7 @@
 #include <mach/tc.h>
 #include <mach/mux.h>
 #include <mach/flash.h>
+#include <mach/irqs.h>
 
 #include <mach/hardware.h>
 
diff --git a/arch/arm/mach-omap1/board-sx1.c b/arch/arm/mach-omap1/board-sx1.c
index 9732a98..b31e77c 100644
--- a/arch/arm/mach-omap1/board-sx1.c
+++ b/arch/arm/mach-omap1/board-sx1.c
@@ -43,6 +43,7 @@
 
 #include <mach/hardware.h>
 #include <mach/usb.h>
+#include <mach/irqs.h>
 
 #include "common.h"
 #include "dma.h"
diff --git a/drivers/video/omap/lcd_ams_delta.c b/drivers/video/omap/lcd_ams_delta.c
index ed4cad8..7539276 100644
--- a/drivers/video/omap/lcd_ams_delta.c
+++ b/drivers/video/omap/lcd_ams_delta.c
@@ -28,6 +28,7 @@
 #include <linux/gpio.h>
 
 #include <mach/board-ams-delta.h>
+#include <mach/hardware.h>
 
 #include "omapfb.h"
 
diff --git a/drivers/video/omap/lcd_osk.c b/drivers/video/omap/lcd_osk.c
index 3aa62da..cad2338 100644
--- a/drivers/video/omap/lcd_osk.c
+++ b/drivers/video/omap/lcd_osk.c
@@ -25,6 +25,7 @@
 
 #include <asm/gpio.h>
 #include <mach/mux.h>
+#include <mach/hardware.h>
 #include "omapfb.h"
 
 static int osk_panel_init(struct lcd_panel *panel, struct omapfb_device *fbdev)
-- 
1.8.1.2

