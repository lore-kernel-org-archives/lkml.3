Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbaDTE4U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 00:56:20 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:38348 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaDTE4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 00:56:08 -0400
From: Jinqiang Zeng <jinqiangzeng@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Elena Ufimtseva <ufimtseva@gmail.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Jinqiang Zeng <jinqiangzeng@gmail.com>
Subject: [PATCH] ced1401 coding style fixes
Date: Sun, 20 Apr 2014 12:55:28 +0800
Message-Id: <1397969728-11159-1-git-send-email-jinqiangzeng@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Jinqiang Zeng <jinqiangzeng@gmail.com>
---
 drivers/staging/ced1401/usb1401.c   |    8 ++++++--
 drivers/staging/ced1401/use14_ioc.h |    4 ----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index 284abc0..5028318 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -896,7 +896,7 @@ static bool ReadWord(unsigned short *pWord, char *pBuf, unsigned int *pdDone,
 ** to indicate three byte total.
 **
 *****************************************************************************/
-static bool ReadHuff(volatile unsigned int *pDWord, char *pBuf,
+static bool ReadHuff(unsigned int *pDWord, char *pBuf,
 		     unsigned int *pdDone, unsigned int dGot)
 {
 	unsigned char ucData;	/* for each read to ReadChar */
@@ -941,7 +941,7 @@ static bool ReadHuff(volatile unsigned int *pDWord, char *pBuf,
 **  we start handling the data at offset zero.
 **
 *****************************************************************************/
-static bool ReadDMAInfo(volatile DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
+static bool ReadDMAInfo(DMADESC *pDmaDesc, DEVICE_EXTENSION *pdx,
 			char *pBuf, unsigned int dwCount)
 {
 	bool bResult = false;	/*  assume we won't succeed */
@@ -1122,6 +1122,7 @@ static void ced_readchar_callback(struct urb *pUrb)
 			spin_lock(&pdx->charInLock);	/*  already at irq level */
 			if (nGot > 0) {
 				unsigned int i;
+
 				if (nGot < INBUF_SZ) {
 					pdx->pCoherCharIn[nGot] = 0;	/*  tidy the string */
 					dev_dbg(&pdx->interface->dev,
@@ -1514,6 +1515,7 @@ static void ced_disconnect(struct usb_interface *interface)
 void ced_draw_down(DEVICE_EXTENSION *pdx)
 {
 	int time;
+
 	dev_dbg(&pdx->interface->dev, "%s: called\n", __func__);
 
 	pdx->bInDrawDown = true;
@@ -1548,6 +1550,7 @@ static int ced_resume(struct usb_interface *intf)
 static int ced_pre_reset(struct usb_interface *intf)
 {
 	DEVICE_EXTENSION *pdx = usb_get_intfdata(intf);
+
 	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 	mutex_lock(&pdx->io_mutex);
 	ced_draw_down(pdx);
@@ -1557,6 +1560,7 @@ static int ced_pre_reset(struct usb_interface *intf)
 static int ced_post_reset(struct usb_interface *intf)
 {
 	DEVICE_EXTENSION *pdx = usb_get_intfdata(intf);
+
 	dev_dbg(&pdx->interface->dev, "%s\n", __func__);
 
 	/* we are sure no URBs are active - no locking needed */
diff --git a/drivers/staging/ced1401/use14_ioc.h b/drivers/staging/ced1401/use14_ioc.h
index 42d2e4e..c27b3b9 100644
--- a/drivers/staging/ced1401/use14_ioc.h
+++ b/drivers/staging/ced1401/use14_ioc.h
@@ -267,15 +267,11 @@ typedef union     /* to communicate with 1401 driver status & control funcs */
 	T1401REGISTERS registers;
 } TCSBLOCK;
 
-typedef TCSBLOCK*  LPTCSBLOCK;
-
 typedef struct paramBlk {
 	 short       sState;
 	 TCSBLOCK    csBlock;
 } PARAMBLK;
 
-typedef PARAMBLK*   PPARAMBLK;
-
 struct transfer_area_desc          /* Structure and type for SetTransArea */
 {
 	unsigned short        wArea;            /* number of transfer area to set up       */
-- 
1.7.7.6

