Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161068Ab3FTVH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 17:07:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37689 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758089Ab3FTVHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 17:07:52 -0400
From: Joel A Fernandes <joelagnel@ti.com>
To: Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>,
        Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>
CC: Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>, Joel A Fernandes <joelagnel@ti.com>
Subject: [PATCH v12 07/11] ARM: davinci: Fix compiler warnings in devices-da8xx
Date: Thu, 20 Jun 2013 16:06:43 -0500
Message-ID: <1371762407-24544-8-git-send-email-joelagnel@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joel A Fernandes <agnel.joel@gmail.com>

queue_priority_mapping and queue_tc_mapping are no longer
const anymore generating a bunch of warnings in devices-da8xx.
Fix them by not doing constant assignments.

Signed-off-by: Joel A Fernandes <joelagnel@ti.com>
---
 arch/arm/mach-davinci/devices-da8xx.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index bf57252..eb254fe 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -105,27 +105,27 @@ struct platform_device da8xx_serial_device = {
 	},
 };
 
-static const s8 da8xx_queue_tc_mapping[][2] = {
+static s8 da8xx_queue_tc_mapping[][2] = {
 	/* {event queue no, TC no} */
 	{0, 0},
 	{1, 1},
 	{-1, -1}
 };
 
-static const s8 da8xx_queue_priority_mapping[][2] = {
+static s8 da8xx_queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 3},
 	{1, 7},
 	{-1, -1}
 };
 
-static const s8 da850_queue_tc_mapping[][2] = {
+static s8 da850_queue_tc_mapping[][2] = {
 	/* {event queue no, TC no} */
 	{0, 0},
 	{-1, -1}
 };
 
-static const s8 da850_queue_priority_mapping[][2] = {
+static s8 da850_queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 3},
 	{-1, -1}
-- 
1.7.9.5

