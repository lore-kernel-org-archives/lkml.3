Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3KJPNi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 10:13:38 -0500
Received: from trinity.catbull.com ([88.198.52.214]:42685 "EHLO catbull.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab3KJPNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 10:13:35 -0500
From: Joachim Adolf Schuetz <jas@catbull.com>
To: gregkh@linuxfoundation.org, dulshani.gunawardhana89@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Joachim Adolf Schuetz <jas@catbull.com>
Subject: [PATCH 2/2] staging: cxt1e1: comet: fixed some brace coding style issues.
Date: Sun, 10 Nov 2013 16:13:05 +0100
Message-Id: <1384096385-25851-1-git-send-email-jas@catbull.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed some coding style issues - a few braces and indentions.

Signed-off-by: Joachim Adolf Schuetz <jas@catbull.com>
---
 drivers/staging/cxt1e1/comet.c |   31 +++++++++++++------------------
 1 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/cxt1e1/comet.c b/drivers/staging/cxt1e1/comet.c
index 46a0d92..b130ad1 100644
--- a/drivers/staging/cxt1e1/comet.c
+++ b/drivers/staging/cxt1e1/comet.c
@@ -159,8 +159,7 @@ void init_comet(void *ci, comet_t *comet, u_int32_t port_mode, int clockmaster,
     /* 60: t1 ALMI cfg */
     /* Configure Line Coding */
 
-	switch (port_mode)
-	{
+	switch (port_mode) {
 	/* 1 - T1 B8ZS */
 	case CFG_FRAME_SF:
 		pci_write_32((u_int32_t *) &comet->cdrc_cfg, 0);
@@ -286,8 +285,7 @@ void init_comet(void *ci, comet_t *comet, u_int32_t port_mode, int clockmaster,
 
     /* 0x30: "BRIF cfg"; 0x20 is 'CMODE', 0x03 is (bit) rate */
     /* note "rate bits can only be set once after reset" */
-	if (clockmaster)
-		{
+	if (clockmaster) {
 		/* CMODE == clockMode, 0=clock master (so all 3 others should be slave) */
 		/* rate = 1.544 Mb/s */
 		if (isT1mode)
@@ -302,8 +300,7 @@ void init_comet(void *ci, comet_t *comet, u_int32_t port_mode, int clockmaster,
 
 		/* Master Mode i.e.FPMODE=0 (@0x20) */
 		pci_write_32((u_int32_t *) &comet->brif_fpcfg, 0x00);
-		if ((moreParams & CFG_CLK_PORT_MASK) == CFG_CLK_PORT_INTERNAL)
-			{
+		if ((moreParams & CFG_CLK_PORT_MASK) == CFG_CLK_PORT_INTERNAL) {
 			if (cxt1e1_log_level >= LOG_SBEBUG12)
 				pr_info(">> %s: clockmaster internal clock\n", __func__);
 			/* internal oscillator */
@@ -422,8 +419,7 @@ WrtXmtWaveformTbl(ci_t *ci, comet_t *comet,
 {
 	u_int32_t sample, unit;
 
-	for (sample = 0; sample < COMET_NUM_SAMPLES; sample++)
-		{
+	for (sample = 0; sample < COMET_NUM_SAMPLES; sample++) {
 		for (unit = 0; unit < COMET_NUM_UNITS; unit++)
 			WrtXmtWaveform(ci, comet, sample, unit, table[sample][unit]);
 		}
@@ -554,8 +550,7 @@ SetCometOps(comet_t *comet)
 {
 	volatile u_int8_t rd_value;
 
-	if (comet == mConfig.C4Func1Base + (COMET0_OFFSET >> 2))
-	{
+	if (comet == mConfig.C4Func1Base + (COMET0_OFFSET >> 2)) {
 		/* read the BRIF Configuration */
 		rd_value = (u_int8_t) pci_read_32((u_int32_t *) &comet->brif_cfg);
 		rd_value &= ~0x20;
@@ -565,14 +560,14 @@ SetCometOps(comet_t *comet)
 		rd_value &= ~0x20;
 		pci_write_32((u_int32_t *) &comet->brif_fpcfg, (u_int8_t) rd_value);
 	} else {
-	/* read the BRIF Configuration */
-	rd_value = (u_int8_t) pci_read_32((u_int32_t *) &comet->brif_cfg);
-	rd_value |= 0x20;
-	pci_write_32((u_int32_t *) &comet->brif_cfg, (u_int32_t) rd_value);
-	/* read the BRIF Frame Pulse Configuration */
-	rd_value = (u_int8_t) pci_read_32((u_int32_t *) &comet->brif_fpcfg);
-	rd_value |= 0x20;
-	pci_write_32(u_int32_t *) & comet->brif_fpcfg, (u_int8_t) rd_value);
+		/* read the BRIF Configuration */
+		rd_value = (u_int8_t) pci_read_32((u_int32_t *) &comet->brif_cfg);
+		rd_value |= 0x20;
+		pci_write_32((u_int32_t *) &comet->brif_cfg, (u_int32_t) rd_value);
+		/* read the BRIF Frame Pulse Configuration */
+		rd_value = (u_int8_t) pci_read_32((u_int32_t *) &comet->brif_fpcfg);
+		rd_value |= 0x20;
+		pci_write_32(u_int32_t *) & comet->brif_fpcfg, (u_int8_t) rd_value);
 	}
 }
 #endif
-- 
1.7.2.5

