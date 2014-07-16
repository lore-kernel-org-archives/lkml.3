Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbaGPBQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 21:16:25 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:60740 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbaGPBQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 21:16:22 -0400
From: Stone Kang <stonekyx@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sachin Kamat <sachin.kamat@samsung.com>,
        Magnus Damm <damm+renesas@opensource.se>,
        Simon Horman <horms+renesas@verge.net.au>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: emxx_udc: Fix coding style errors
Date: Wed, 16 Jul 2014 09:16:15 +0800
Message-Id: <1405473375-29825-1-git-send-email-stonekyx@gmail.com>
X-Mailer: git-send-email 2.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only fixing errors reported by checkpatch.pl, based on the following
rules:
1. '*' should be adjacent to the data name or function name.
2. Don't use C99-style "// ..." comments.

Signed-off-by: KANG Yuxuan <stonekyx@gmail.com>
---
 drivers/staging/emxx_udc/emxx_udc.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index 0003463..b2eaf01 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -562,12 +562,12 @@ static void _nbu2ss_dma_unmap_single(
 
 /*-------------------------------------------------------------------------*/
 /* Endpoint 0 OUT Transfer (PIO) */
-static int EP0_out_PIO(struct nbu2ss_udc *udc, u8* pBuf, u32 length)
+static int EP0_out_PIO(struct nbu2ss_udc *udc, u8 *pBuf, u32 length)
 {
 	u32		i;
 	int		nret   = 0;
 	u32		iWordLength = 0;
-	USB_REG_ACCESS* pBuf32 = (USB_REG_ACCESS *)pBuf;
+	USB_REG_ACCESS *pBuf32 = (USB_REG_ACCESS *)pBuf;
 
 	/*------------------------------------------------------------*/
 	/* Read Length */
@@ -588,12 +588,12 @@ static int EP0_out_PIO(struct nbu2ss_udc *udc, u8* pBuf, u32 length)
 
 /*-------------------------------------------------------------------------*/
 /* Endpoint 0 OUT Transfer (PIO, OverBytes) */
-static int EP0_out_OverBytes(struct nbu2ss_udc *udc, u8* pBuf, u32 length)
+static int EP0_out_OverBytes(struct nbu2ss_udc *udc, u8 *pBuf, u32 length)
 {
 	u32		i;
 	u32		iReadSize = 0;
 	USB_REG_ACCESS  Temp32;
-	USB_REG_ACCESS* pBuf32 = (USB_REG_ACCESS *)pBuf;
+	USB_REG_ACCESS *pBuf32 = (USB_REG_ACCESS *)pBuf;
 
 	if ((0 < length) && (length < sizeof(u32))) {
 		Temp32.dw = _nbu2ss_readl(&udc->p_regs->EP0_READ);
@@ -613,7 +613,7 @@ static int EP0_in_PIO(struct nbu2ss_udc *udc, u8 *pBuf, u32 length)
 	u32		iMaxLength   = EP0_PACKETSIZE;
 	u32		iWordLength  = 0;
 	u32		iWriteLength = 0;
-	USB_REG_ACCESS*	pBuf32 = (USB_REG_ACCESS *)pBuf;
+	USB_REG_ACCESS *pBuf32 = (USB_REG_ACCESS *)pBuf;
 
 	/*------------------------------------------------------------*/
 	/* Transfer Length */
@@ -639,7 +639,7 @@ static int EP0_in_OverBytes(struct nbu2ss_udc *udc, u8 *pBuf, u32 iRemainSize)
 {
 	u32		i;
 	USB_REG_ACCESS Temp32;
-	USB_REG_ACCESS* pBuf32 = (USB_REG_ACCESS *)pBuf;
+	USB_REG_ACCESS *pBuf32 = (USB_REG_ACCESS *)pBuf;
 
 	if ((0 < iRemainSize) && (iRemainSize < sizeof(u32))) {
 		for (i = 0 ; i < iRemainSize ; i++)
@@ -3339,7 +3339,7 @@ static int __init nbu2ss_drv_contest_init(
 	udc->gadget.ep0 = &udc->ep[0].ep;
 	udc->gadget.speed = USB_SPEED_UNKNOWN;
 	udc->gadget.name = driver_name;
-	//udc->gadget.is_dualspeed = 1;
+	/* udc->gadget.is_dualspeed = 1; */
 
 	device_initialize(&udc->gadget.dev);
 
-- 
2.0.1

