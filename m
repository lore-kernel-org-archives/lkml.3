Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbaBXAvn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 19:51:43 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44886 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbaBXAvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 19:51:42 -0500
From: Daeseok Youn <daeseok.youn@gmail.com>
To: gregkh@linuxfoundation.org
Cc: ufimtseva@gmail.com, paul.gortmaker@windriver.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: ced401: remove redundant spin_unlock
Date: Mon, 24 Feb 2014 09:51:35 +0900
Message-ID: <3750536.lQYs9UcrV9@daeseok-laptop.cloud.net>
User-Agent: KMail/4.8.5 (Linux/3.2.0-58-generic; KDE/4.8.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5e737e8211cd1f83488e484c088befc5feb755a9 Mon Sep 17 00:00:00 2001
From: Daeseok Youn <daeseok.youn@gmail.com>
Date: Mon, 24 Feb 2014 09:17:41 +0900
Subject: [PATCH] staging: ced401: remove redundant spin_unlock

sparse says:
drivers/staging/ced1401/usb1401.c:1080:28: warning:
 context imbalance in 'Handle1401Esc' - unexpected unlock

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
---
 drivers/staging/ced1401/usb1401.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index efc310c..8195eb9 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -1053,7 +1053,6 @@ static int Handle1401Esc(DEVICE_EXTENSION *pdx, char *pCh,
 				/*  This can never happen, really */
 				dev_err(&pdx->interface->dev,
 					"ERROR: DMA setup while transfer still waiting");
-				spin_unlock(&pdx->stagedLock);
 			} else {
 				if ((wTransType == TM_EXTTOHOST)
 				    || (wTransType == TM_EXTTO1401)) {
-- 
1.7.9.5

---
