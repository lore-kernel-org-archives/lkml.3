Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaFFREh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:04:37 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:39288 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFFREg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:04:36 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/13] staging: rtl8188eu: rtw_io.h: Remove unused macros
Date: Fri,  6 Jun 2014 22:34:28 +0530
Message-Id: <1402074268-22875-1-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_io.h |   57 ----------------------------
 1 file changed, 57 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index e56c52b..9c6384b 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -39,63 +39,6 @@
 #define rtw_usb_buffer_free(dev, size, addr, dma)			\
 	usb_free_coherent((dev), (size), (addr), (dma))

-#define NUM_IOREQ		8
-
-#define MAX_PROT_SZ	(64-16)
-
-#define _IOREADY		0
-#define _IO_WAIT_COMPLETE	1
-#define _IO_WAIT_RSP		2
-
-/*  IO COMMAND TYPE */
-#define _IOSZ_MASK_		(0x7F)
-#define _IO_WRITE_		BIT(7)
-#define _IO_FIXED_		BIT(8)
-#define _IO_BURST_		BIT(9)
-#define _IO_BYTE_		BIT(10)
-#define _IO_HW_			BIT(11)
-#define _IO_WORD_		BIT(12)
-#define _IO_SYNC_		BIT(13)
-#define _IO_CMDMASK_		(0x1F80)
-
-/*
-	For prompt mode accessing, caller shall free io_req
-	Otherwise, io_handler will free io_req
-*/
-
-/*  IO STATUS TYPE */
-#define _IO_ERR_		BIT(2)
-#define _IO_SUCCESS_		BIT(1)
-#define _IO_DONE_		BIT(0)
-
-#define IO_RD32			(_IO_SYNC_ | _IO_WORD_)
-#define IO_RD16			(_IO_SYNC_ | _IO_HW_)
-#define IO_RD8			(_IO_SYNC_ | _IO_BYTE_)
-
-#define IO_RD32_ASYNC		(_IO_WORD_)
-#define IO_RD16_ASYNC		(_IO_HW_)
-#define IO_RD8_ASYNC		(_IO_BYTE_)
-
-#define IO_WR32			(_IO_WRITE_ | _IO_SYNC_ | _IO_WORD_)
-#define IO_WR16			(_IO_WRITE_ | _IO_SYNC_ | _IO_HW_)
-#define IO_WR8			(_IO_WRITE_ | _IO_SYNC_ | _IO_BYTE_)
-
-#define IO_WR32_ASYNC		(_IO_WRITE_ | _IO_WORD_)
-#define IO_WR16_ASYNC		(_IO_WRITE_ | _IO_HW_)
-#define IO_WR8_ASYNC		(_IO_WRITE_ | _IO_BYTE_)
-
-/*
-	Only Sync. burst accessing is provided.
-*/
-
-#define IO_WR_BURST(x)						\
-	(_IO_WRITE_ | _IO_SYNC_ | _IO_BURST_ | ((x) & _IOSZ_MASK_))
-#define IO_RD_BURST(x)						\
-	(_IO_SYNC_ | _IO_BURST_ | ((x) & _IOSZ_MASK_))
-
-/* below is for the intf_option bit defition... */
-
-#define _INTF_ASYNC_	BIT(0)	/* support async io */

 struct intf_priv;
 struct intf_hdl;
--
1.7.10.4

