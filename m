Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaEPMSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 08:18:39 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50235 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaEPMSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 08:18:35 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <arnd@arndb.de>
CC: <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <tony@atomide.com>,
        <bcousson@baylibre.com>
Subject: [PATCH v3 12/13] ARM: davinci: Remove redundant/unused parameters for edma
Date: Fri, 16 May 2014 15:17:19 +0300
Message-ID: <1400242640-9902-13-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
References: <1400242640-9902-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following parameters are no longer needed by the edma driver since the
information can be obtained from the IP's CCCFG register:
n_channel, n_region, n_slot and n_tc.
Remove the initialization of n_cc as well since in this context it has no
meaning. We have separate edma_soc_info struct/eDMA3_CC instance so this
member does not make any sense (and the driver no longer uses it).

Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
---
 arch/arm/mach-davinci/devices-da8xx.c | 15 ---------------
 arch/arm/mach-davinci/dm355.c         |  5 -----
 arch/arm/mach-davinci/dm365.c         |  5 -----
 arch/arm/mach-davinci/dm644x.c        |  5 -----
 arch/arm/mach-davinci/dm646x.c        |  5 -----
 5 files changed, 35 deletions(-)

diff --git a/arch/arm/mach-davinci/devices-da8xx.c b/arch/arm/mach-davinci/devices-da8xx.c
index 7f376e54b266..b85b781b05fd 100644
--- a/arch/arm/mach-davinci/devices-da8xx.c
+++ b/arch/arm/mach-davinci/devices-da8xx.c
@@ -148,11 +148,6 @@ static s8 da850_queue_priority_mapping[][2] = {
 };
 
 static struct edma_soc_info da830_edma_cc0_info = {
-	.n_channel		= 32,
-	.n_region		= 4,
-	.n_slot			= 128,
-	.n_tc			= 2,
-	.n_cc			= 1,
 	.queue_priority_mapping	= da8xx_queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
@@ -163,20 +158,10 @@ static struct edma_soc_info *da830_edma_info[EDMA_MAX_CC] = {
 
 static struct edma_soc_info da850_edma_cc_info[] = {
 	{
-		.n_channel		= 32,
-		.n_region		= 4,
-		.n_slot			= 128,
-		.n_tc			= 2,
-		.n_cc			= 1,
 		.queue_priority_mapping	= da8xx_queue_priority_mapping,
 		.default_queue		= EVENTQ_1,
 	},
 	{
-		.n_channel		= 32,
-		.n_region		= 4,
-		.n_slot			= 128,
-		.n_tc			= 1,
-		.n_cc			= 1,
 		.queue_priority_mapping	= da850_queue_priority_mapping,
 		.default_queue		= EVENTQ_0,
 	},
diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
index e27f7ff54570..2f3ed3a58d57 100644
--- a/arch/arm/mach-davinci/dm355.c
+++ b/arch/arm/mach-davinci/dm355.c
@@ -577,11 +577,6 @@ queue_priority_mapping[][2] = {
 };
 
 static struct edma_soc_info edma_cc0_info = {
-	.n_channel		= 64,
-	.n_region		= 4,
-	.n_slot			= 128,
-	.n_tc			= 2,
-	.n_cc			= 1,
 	.queue_priority_mapping	= queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
index 88835b0aaead..0ae8114f5cc9 100644
--- a/arch/arm/mach-davinci/dm365.c
+++ b/arch/arm/mach-davinci/dm365.c
@@ -863,11 +863,6 @@ dm365_queue_priority_mapping[][2] = {
 };
 
 static struct edma_soc_info edma_cc0_info = {
-	.n_channel		= 64,
-	.n_region		= 4,
-	.n_slot			= 256,
-	.n_tc			= 4,
-	.n_cc			= 1,
 	.queue_priority_mapping	= dm365_queue_priority_mapping,
 	.default_queue		= EVENTQ_3,
 };
diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
index 8ea34be879b4..dc52657909c4 100644
--- a/arch/arm/mach-davinci/dm644x.c
+++ b/arch/arm/mach-davinci/dm644x.c
@@ -507,11 +507,6 @@ queue_priority_mapping[][2] = {
 };
 
 static struct edma_soc_info edma_cc0_info = {
-	.n_channel		= 64,
-	.n_region		= 4,
-	.n_slot			= 128,
-	.n_tc			= 2,
-	.n_cc			= 1,
 	.queue_priority_mapping	= queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
index 97e90dc5ed43..6c3bbea7d77d 100644
--- a/arch/arm/mach-davinci/dm646x.c
+++ b/arch/arm/mach-davinci/dm646x.c
@@ -543,11 +543,6 @@ dm646x_queue_priority_mapping[][2] = {
 };
 
 static struct edma_soc_info edma_cc0_info = {
-	.n_channel		= 64,
-	.n_region		= 6,	/* 0-1, 4-7 */
-	.n_slot			= 512,
-	.n_tc			= 4,
-	.n_cc			= 1,
 	.queue_priority_mapping	= dm646x_queue_priority_mapping,
 	.default_queue		= EVENTQ_1,
 };
-- 
1.9.3

