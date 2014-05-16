Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbaEPMSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:18:17 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:44796 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756038AbaEPMSM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:12 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 04/13] ARM: davinci: Remove eDMA3 queue_tc_mapping data from edma_soc_info
Date: Fri, 16 May 2014 15:17:11 +0300
Message-ID: <1400242640-9902-5-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is ignored by the edma driver since we are just setting back the default
mapping of TC -> Queue.

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-davinci/devices-da8xx.c | 16 ----------------
 arch/arm/mach-davinci/dm355.c         |  9 ---------
 arch/arm/mach-davinci/dm365.c         | 11 -----------
 arch/arm/mach-davinci/dm644x.c        |  9 ---------
 arch/arm/mach-davinci/dm646x.c        | 11 -----------
 5 files changed, 56 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 56ea41d5f849..7f376e54b266 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -134,13 +134,6 @@ struct platform_device da8xx_serial_device[] = {
 	}
 };
 
-static s8 da8xx_queue_tc_mapping[][2] = {
-	/* {event queue no, TC no} */
-	{0, 0},
-	{1, 1},
-	{-1, -1}
-};
-
 static s8 da8xx_queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 3},
@@ -148,12 +141,6 @@ static s8 da8xx_queue_priority_mapping[][2] = {
 	{-1, -1}
 };
 
-static s8 da850_queue_tc_mapping[][2] = {
-	/* {event queue no, TC no} */
-	{0, 0},
-	{-1, -1}
-};
-
 static s8 da850_queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 3},
@@ -166,7 +153,6 @@ static struct edma_soc_info da830_edma_cc0_info = {
 	.n_slot			= 128,
 	.n_tc			= 2,
 	.n_cc			= 1,
-	.queue_tc_mapping	= da8xx_queue_tc_mapping,
 	.queue_priority_mapping	= da8xx_queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
@@ -182,7 +168,6 @@ static struct edma_soc_info da850_edma_cc_info[] = {
 		.n_slot			= 128,
 		.n_tc			= 2,
 		.n_cc			= 1,
-		.queue_tc_mapping	= da8xx_queue_tc_mapping,
 		.queue_priority_mapping	= da8xx_queue_priority_mapping,
 		.default_queue		= EVENTQ_1,
 	},
@@ -192,7 +177,6 @@ static struct edma_soc_info da850_edma_cc_info[] = {
 		.n_slot			= 128,
 		.n_tc			= 1,
 		.n_cc			= 1,
-		.queue_tc_mapping	= da850_queue_tc_mapping,
 		.queue_priority_mapping	= da850_queue_priority_mapping,
 		.default_queue		= EVENTQ_0,
 	},
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index 07381d8cea62..e27f7ff54570 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -569,14 +569,6 @@ static u8 dm355_default_priorities[DAVINCI_N_AINTC_IRQ] = {
 /*----------------------------------------------------------------------*/
 
 static s8
-queue_tc_mapping[][2] = {
-	/* {event queue no, TC no} */
-	{0, 0},
-	{1, 1},
-	{-1, -1},
-};
-
-static s8
 queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 3},
@@ -590,7 +582,6 @@ static struct edma_soc_info edma_cc0_info = {
 	.n_slot			= 128,
 	.n_tc			= 2,
 	.n_cc			= 1,
-	.queue_tc_mapping	= queue_tc_mapping,
 	.queue_priority_mapping	= queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 08a61b938333..88835b0aaead 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -853,16 +853,6 @@ static u8 dm365_default_priorities[DAVINCI_N_AINTC_IRQ] = {
 
 /* Four Transfer Controllers on DM365 */
 static s8
-dm365_queue_tc_mapping[][2] = {
-	/* {event queue no, TC no} */
-	{0, 0},
-	{1, 1},
-	{2, 2},
-	{3, 3},
-	{-1, -1},
-};
-
-static s8
 dm365_queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 7},
@@ -878,7 +868,6 @@ static struct edma_soc_info edma_cc0_info = {
 	.n_slot			= 256,
 	.n_tc			= 4,
 	.n_cc			= 1,
-	.queue_tc_mapping	= dm365_queue_tc_mapping,
 	.queue_priority_mapping	= dm365_queue_priority_mapping,
 	.default_queue		= EVENTQ_3,
 };
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 5debffba4b24..8ea34be879b4 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -499,14 +499,6 @@ static u8 dm644x_default_priorities[DAVINCI_N_AINTC_IRQ] = {
 /*----------------------------------------------------------------------*/
 
 static s8
-queue_tc_mapping[][2] = {
-	/* {event queue no, TC no} */
-	{0, 0},
-	{1, 1},
-	{-1, -1},
-};
-
-static s8
 queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 3},
@@ -520,7 +512,6 @@ static struct edma_soc_info edma_cc0_info = {
 	.n_slot			= 128,
 	.n_tc			= 2,
 	.n_cc			= 1,
-	.queue_tc_mapping	= queue_tc_mapping,
 	.queue_priority_mapping	= queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 332d00d24dc2..97e90dc5ed43 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -533,16 +533,6 @@ static u8 dm646x_default_priorities[DAVINCI_N_AINTC_IRQ] = {
 
 /* Four Transfer Controllers on DM646x */
 static s8
-dm646x_queue_tc_mapping[][2] = {
-	/* {event queue no, TC no} */
-	{0, 0},
-	{1, 1},
-	{2, 2},
-	{3, 3},
-	{-1, -1},
-};
-
-static s8
 dm646x_queue_priority_mapping[][2] = {
 	/* {event queue no, Priority} */
 	{0, 4},
@@ -558,7 +548,6 @@ static struct edma_soc_info edma_cc0_info = {
 	.n_slot			= 512,
 	.n_tc			= 4,
 	.n_cc			= 1,
-	.queue_tc_mapping	= dm646x_queue_tc_mapping,
 	.queue_priority_mapping	= dm646x_queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
-- 
1.9.3

