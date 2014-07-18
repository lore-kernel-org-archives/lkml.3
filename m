Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946012AbaGRSf0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:35:26 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:65384 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422748AbaGRSfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:35:25 -0400
From: Igor Bezukh <igbzkh@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        linux-kernel@vger.kernel.org, igbzkh@gmail.com
Subject: [PATCH] Staging: vt6655: apply kernel coding style to wCommandTimerWait function
Date: Fri, 18 Jul 2014 21:35:13 +0300
Message-Id: <1405708513-27831-1-git-send-email-igbzkh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since there is a lot of stuff that need to be changed in order to meet the kernel
coding style in wcmd.c file, I've decided to fix function-per-patch.
The following changes were made in vCommandTimerWait function:

- Camel case change:
   - MSecond ---> msec
   - hDdeviceContext ---> private
   - pDevice ---> priv
- Removed redundant return
- Removed redndant comment

In future patches, I will also change the function name itself.

Signed-off-by: Igor Bezukh <igbzkh@gmail.com>
---
 drivers/staging/vt6655/wcmd.c |   20 +++++++-------------
 1 file changed, 7 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/vt6655/wcmd.c b/drivers/staging/vt6655/wcmd.c
index a689645..e5073d9 100644
--- a/drivers/staging/vt6655/wcmd.c
+++ b/drivers/staging/vt6655/wcmd.c
@@ -281,21 +281,15 @@ s_MgrMakeProbeRequest(
 	return pTxPacket;
 }
 
-void
-vCommandTimerWait(
-	void *hDeviceContext,
-	unsigned int MSecond
-)
+void vCommandTimerWait(void *private, unsigned int msec)
 {
-	PSDevice        pDevice = (PSDevice)hDeviceContext;
+	PSDevice priv = (PSDevice)private;
 
-	init_timer(&pDevice->sTimerCommand);
-	pDevice->sTimerCommand.data = (unsigned long) pDevice;
-	pDevice->sTimerCommand.function = (TimerFunction)vCommandTimer;
-	// RUN_AT :1 msec ~= (HZ/1024)
-	pDevice->sTimerCommand.expires = (unsigned int)RUN_AT((MSecond * HZ) >> 10);
-	add_timer(&pDevice->sTimerCommand);
-	return;
+	init_timer(&priv->sTimerCommand);
+	priv->sTimerCommand.data = (unsigned long)priv;
+	priv->sTimerCommand.function = (TimerFunction)vCommandTimer;
+	priv->sTimerCommand.expires = (unsigned int)RUN_AT((msec * HZ) >> 10);
+	add_timer(&priv->sTimerCommand);
 }
 
 void
-- 
1.7.9.5

