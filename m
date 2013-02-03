Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011Ab3BCVw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 16:52:26 -0500
Received: from mout.gmx.net ([212.227.15.19]:63823 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985Ab3BCVvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 16:51:41 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/F1X9RBjnFwdoB75Pfe+aXN+FV+khbhkd0VKcGHt
	/9o4eJX8ahGJ1A
From: Peter Huewe <peterhuewe@gmx.de>
To: Arnaud Patard <arnaud.patard@rtp-net.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?UTF-8?q?Miguel=20G=C3=B3mez?= <magomez@igalia.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, Peter Huewe <peterhuewe@gmx.de>,
        Sam Hansen <solid.se7en@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] staging/xgifb: Remove unnecessary bitshifts in XGI_SetCRT1ModeRegs
Date: Sun,  3 Feb 2013 22:54:37 +0100
Message-Id: <1359928479-8484-8-git-send-email-peterhuewe@gmx.de>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
References: <1359928479-8484-1-git-send-email-peterhuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since data can only be 0x0000, 0x0035 or 0x0048 we can simply skip the
bit shifting and masking as data & 0xFF is always equal to data and
data & 0xFF00 is always 0.
So we simply use data and 0 directly and save the assignment.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 drivers/staging/xgifb/vb_setmode.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/xgifb/vb_setmode.c b/drivers/staging/xgifb/vb_setmode.c
index 6f366f4..1ff1178 100644
--- a/drivers/staging/xgifb/vb_setmode.c
+++ b/drivers/staging/xgifb/vb_setmode.c
@@ -1083,10 +1083,8 @@ static void XGI_SetCRT1ModeRegs(struct xgi_hw_device_info *HwDeviceExtension,
 			data = 0x0048;
 	}
 
-	data2 = data & 0x00FF;
-	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data2);
-	data2 = (data & 0xFF00) >> 8;
-	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, data2);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFF, data);
+	xgifb_reg_and_or(pVBInfo->P3d4, 0x19, 0xFC, 0);
 
 	if (modeflag & HalfDCLK)
 		xgifb_reg_and_or(pVBInfo->P3c4, 0x01, 0xF7, 0x08);
-- 
1.7.8.6

