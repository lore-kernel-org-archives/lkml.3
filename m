Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaFNFEx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 01:04:53 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:39411 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbaFNFEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 01:04:52 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alois.schloegl@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] staging: ced1401: fix sparse warning for ced1401
Date: Sat, 14 Jun 2014 14:04:38 +0900
Message-Id: <1402722278-23040-1-git-send-email-waydi1@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes below warning.

drivers/staging/ced1401/ced_ioc.c:703:30: warning: incorrect type in assignment (different address spaces)
	drivers/staging/ced1401/ced_ioc.c:703:30:    expected void *[usertype] lpvBuff
	drivers/staging/ced1401/ced_ioc.c:703:30:    got char [noderef] <asn:1>*puBuf

Signed-off-by: Seunghun Lee <waydi1@gmail.com>
---
 drivers/staging/ced1401/ced_ioc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index ebbc509..963b941 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -700,7 +700,7 @@ static int SetArea(DEVICE_EXTENSION *pdx, int nArea, char __user *puBuf,
 		/*  kmap() or kmap_atomic() to get a virtual address. page_address will give you */
 		/*  (null) or at least it does in this context with an x86 machine. */
 		spin_lock_irq(&pdx->stagedLock);
-		pTA->lpvBuff = puBuf;	/*  keep start of region (user address) */
+		pTA->lpvBuff = (__force void *)puBuf;	/*  keep start of region (user address) */
 		pTA->dwBaseOffset = ulOffset;	/*  save offset in first page to start of xfer */
 		pTA->dwLength = dwLength;	/*  Size if the region in bytes */
 		pTA->pPages = pPages;	/*  list of pages that are used by buffer */
-- 
1.7.9.5

