Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751803Ab3BOTdO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 14:33:14 -0500
Received: from mout.gmx.net ([212.227.17.21]:63343 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3BOTc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 14:32:56 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19D/LM//QhDfD1k1umcBFvUclE+bkx5vsXbIIFt2o
	z9MaP7LqnIhYpv
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging/xgifb: Remove duplicated code in loops.
Date: Fri, 15 Feb 2013 20:37:13 +0100
Message-Id: <1360957033-11876-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
References: <1360957033-11876-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of calling the same function three times in a loop, multiply the
loop counter by three.
And since the value in DAC_TEST_PARMS is always the same we can use the
value directly.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index edbe70b..dfa5303 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -5464,7 +5464,6 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 
 	unsigned char CR17, CR63, SR31;
 	unsigned short temp;
-	unsigned char DAC_TEST_PARMS[3] = { 0x0F, 0x0F, 0x0F };
 
 	int i;
 	xgifb_reg_set(pVBInfo->P3c4, 0x05, 0x86);
@@ -5518,10 +5517,8 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 
 	outb(0x00, pVBInfo->P3c8);
 
-	for (i = 0; i < 256; i++) {
-		outb((unsigned char) DAC_TEST_PARMS[0], (pVBInfo->P3c8 + 1));
-		outb((unsigned char) DAC_TEST_PARMS[1], (pVBInfo->P3c8 + 1));
-		outb((unsigned char) DAC_TEST_PARMS[2], (pVBInfo->P3c8 + 1));
+	for (i = 0; i < 256 * 3; i++) {
+		outb(0x0F, (pVBInfo->P3c8 + 1)); /* DAC_TEST_PARMS */
 	}
 
 	mdelay(1);
@@ -5537,9 +5534,7 @@ void XGI_SenseCRT1(struct vb_device_info *pVBInfo)
 	/* avoid display something, set BLACK DAC if not restore DAC */
 	outb(0x00, pVBInfo->P3c8);
 
-	for (i = 0; i < 256; i++) {
-		outb(0, (pVBInfo->P3c8 + 1));
-		outb(0, (pVBInfo->P3c8 + 1));
+	for (i = 0; i < 256 * 3; i++) {
 		outb(0, (pVBInfo->P3c8 + 1));
 	}
 
-- 
1.7.8.6

