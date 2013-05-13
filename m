Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab3EMVhc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:37:32 -0400
Received: from mout.gmx.net ([212.227.17.20]:54164 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755338Ab3EMVhb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:37:31 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19eOIl5jFZeCJe488u9vdcLT72oMr3sIc+Lb0leAV
	Dl+fQw82C0G1H0
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Huewe <peterhuewe@gmx.de>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] staging/xgifb: Fix always false condition in vb_setmode.c (smatch)
Date: Mon, 13 May 2013 23:41:49 +0200
Message-Id: <1368481309-4883-5-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
References: <1368481309-4883-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Smatch complains:
drivers/staging/xgifb/vb_setmode.c:3181
XGI_SetLockRegs() warn: bitwise AND condition is false here

Since SetNTSCTV is defined as 0 in drivers/video/sis/initdef.h this is
correct.
-> Change the condition to == to fix this.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 3adec3f..5fb699d 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -3178,7 +3178,7 @@ static void XGI_SetLockRegs(unsigned short ModeNo, unsigned short ModeIdIndex,
 	if (pVBInfo->VBInfo & SetCRT2ToTV) {
 		if (pVBInfo->TVInfo & TVSimuMode) {
 			if (ModeNo == 0x50) {
-				if (pVBInfo->TVInfo & SetNTSCTV) {
+				if (pVBInfo->TVInfo == SetNTSCTV) {
 					xgifb_reg_set(pVBInfo->Part1Port,
 							0x07, 0x30);
 					xgifb_reg_set(pVBInfo->Part1Port,
-- 
1.8.1.5

