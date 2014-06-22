Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515AbaFVOiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 10:38:13 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:46385 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbaFVOiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 10:38:12 -0400
From: Seunghun Lee <waydi1@gmail.com>
To: gregkh@linuxfoundation.org
Cc: alois.schloegl@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Seunghun Lee <waydi1@gmail.com>
Subject: [PATCH] staging: ced1401: fix sparse warning for ced1401
Date: Sun, 22 Jun 2014 23:38:04 +0900
Message-Id: <1403447884-17470-1-git-send-email-waydi1@gmail.com>
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
 drivers/staging/ced1401/usb1401.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ced1401/usb1401.h b/drivers/staging/ced1401/usb1401.h
index ea0fe63..8327e9c 100644
--- a/drivers/staging/ced1401/usb1401.h
+++ b/drivers/staging/ced1401/usb1401.h
@@ -101,7 +101,7 @@ typedef struct circBlk {
 /*  A structure holding all of the information about a transfer area - an area of */
 /*   memory set up for use either as a source or destination in DMA transfers. */
 typedef struct transarea {
-	void	*lpvBuff;                /*  User address of xfer area saved for completeness */
+	void __user *lpvBuff;                /*  User address of xfer area saved for completeness */
 	UINT        dwBaseOffset;           /*  offset to start of xfer area in first page */
 	UINT        dwLength;               /*  Length of xfer area, in bytes */
 	struct page **pPages;               /*  Points at array of locked down pages */
-- 
1.7.9.5

