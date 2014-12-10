Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbaLJFtW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 00:49:22 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:40598 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675AbaLJFtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 00:49:19 -0500
From: Fred Chou <fred.chou.nd@gmail.com>
X-Google-Original-From: Fred Chou
To: forest@alittletooquiet.net, gregkh@linuxfoundation.org, tvboxspy@gmail.com,
        guido@vanguardiasur.com.ar, joe@perches.com, gclement@baobob.org,
        fred.chou.nd@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: vt6655: remove unused function in mac.c
Date: Wed, 10 Dec 2014 13:50:16 +0800
Message-Id: <1418190616-25317-1-git-send-email-fred.chou.nd@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fred Chou <fred.chou.nd@gmail.com>

Removed the unused function MACvGetShortRetryLimit, which also
fixed the following sparse warning:
drivers/staging/vt6655/mac.c:162:6: warning: 
symbol 'MACvGetShortRetryLimit' was not declared. Should it be static?

Signed-off-by: Fred Chou <fred.chou.nd@gmail.com>
---
 drivers/staging/vt6655/mac.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/drivers/staging/vt6655/mac.c b/drivers/staging/vt6655/mac.c
index 8f0d652..09a91d1 100644
--- a/drivers/staging/vt6655/mac.c
+++ b/drivers/staging/vt6655/mac.c
@@ -30,7 +30,6 @@
  *      MACbIsRegBitsOff - Test if All test Bits Off
  *      MACbIsIntDisable - Test if MAC interrupt disable
  *      MACvSetShortRetryLimit - Set 802.11 Short Retry limit
- *      MACvGetShortRetryLimit - Get 802.11 Short Retry limit
  *      MACvSetLongRetryLimit - Set 802.11 Long Retry limit
  *      MACvSetLoopbackMode - Set MAC Loopback Mode
  *      MACvSaveContext - Save Context of MAC Registers
@@ -146,24 +145,6 @@ void MACvSetShortRetryLimit(void __iomem *dwIoBase, unsigned char byRetryLimit)
 	VNSvOutPortB(dwIoBase + MAC_REG_SRT, byRetryLimit);
 }
 
-/*
- * Description:
- *      Get 802.11 Short Retry Limit
- *
- * Parameters:
- *  In:
- *      dwIoBase        - Base Address for MAC
- *  Out:
- *      pbyRetryLimit   - Retry Limit Get
- *
- * Return Value: none
- *
- */
-void MACvGetShortRetryLimit(void __iomem *dwIoBase, unsigned char *pbyRetryLimit)
-{
-	// get SRT
-	VNSvInPortB(dwIoBase + MAC_REG_SRT, pbyRetryLimit);
-}
 
 /*
  * Description:
-- 
1.9.1

