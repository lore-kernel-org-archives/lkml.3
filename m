Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747Ab3JPSvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 14:51:53 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50195 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761195Ab3JPSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 14:51:51 -0400
From: Dhanunjaya <dhanunjaya.matrix@gmail.com>
To: arnaud.patard@rtp-net.org, gregkh@linuxfoundation.org,
        aaro.koskinen@iki.fi, peterhuewe@gmx.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dhanunjaya <dhanunjaya.matrix@gmail.com>
Subject: [PATCH 3/4] Staging: xgifb: fix braces {} are not necessary for single statement blocks
Date: Thu, 17 Oct 2013 00:21:33 +0530
Message-Id: <1381949494-19886-1-git-send-email-dhanunjaya.matrix@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the vb_setmode.c file that fixes braces {}
are not necessary for single statement blocks warning found
by the checkpatch.pl tool

Signed-of-by: Dhanunjaya <dhanunjaya.matrix@gmail.com>
---
 drivers/staging/xgifb/vb_setmode.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 46dea3f..400c726 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -845,11 +845,10 @@ static unsigned short XGI_GetVCLK2Ptr(unsigned short ModeIdIndex,
 			VCLKIndex = TVCLKBASE_315_25 + HiTVVCLK;
 
 		if (pVBInfo->SetFlag & TVSimuMode) {
-			if (modeflag & Charx8Dot) {
+			if (modeflag & Charx8Dot)
 				VCLKIndex = TVCLKBASE_315_25 + HiTVSimuVCLK;
-			} else {
+			else
 				VCLKIndex = TVCLKBASE_315_25 + HiTVTextVCLK;
-			}
 		}
 
 		/* 301lv */
@@ -5274,9 +5273,8 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 
 	outb(0x00, pVBInfo->P3c8);
 
-	for (i = 0; i < 256 * 3; i++) {
+	for (i = 0; i < 256 * 3; i++)
 		outb(0x0F, (pVBInfo->P3c8 + 1)); /* DAC_TEST_PARMS */
-	}
 
 	mdelay(1);
 
@@ -5291,9 +5289,8 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	/* avoid display something, set BLACK DAC if not restore DAC */
 	outb(0x00, pVBInfo->P3c8);
 
-	for (i = 0; i < 256 * 3; i++) {
+	for (i = 0; i < 256 * 3; i++)
 		outb(0, (pVBInfo->P3c8 + 1));
-	}
 
 	xgifb_reg_set(pVBInfo->P3c4, 0x01, SR01);
 	xgifb_reg_set(pVBInfo->P3d4, 0x63, CR63);
-- 
1.8.1.2

