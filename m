Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478AbaFFQP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:15:58 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36230 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaFFQP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:15:56 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/13] staging: rtl8188eu: Remove unused struct intf_priv
Date: Fri,  6 Jun 2014 21:45:13 +0530
Message-Id: <1402071320-14400-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_intf.h |   33 ------------------------
 1 file changed, 33 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_intf.h b/drivers/staging/rtl8188eu/include/osdep_intf.h
index a5b3bd3..523141a 100644
--- a/drivers/staging/rtl8188eu/include/osdep_intf.h
+++ b/drivers/staging/rtl8188eu/include/osdep_intf.h
@@ -24,39 +24,6 @@
 #include <osdep_service.h>
 #include <drv_types.h>
 
-struct intf_priv {
-	u8 *intf_dev;
-	u32	max_iosz;	/* USB2.0: 128, USB1.1: 64, SDIO:64 */
-	u32	max_xmitsz; /* USB2.0: unlimited, SDIO:512 */
-	u32	max_recvsz; /* USB2.0: unlimited, SDIO:512 */
-
-	u8 *io_rwmem;
-	u8 *allocated_io_rwmem;
-	u32	io_wsz; /* unit: 4bytes */
-	u32	io_rsz;/* unit: 4bytes */
-	u8 intf_status;
-
-	void (*_bus_io)(u8 *priv);
-
-/*
-Under Sync. IRP (SDIO/USB)
-A protection mechanism is necessary for the io_rwmem(read/write protocol)
-
-Under Async. IRP (SDIO/USB)
-The protection mechanism is through the pending queue.
-*/
-	struct mutex ioctl_mutex;
-	/*  when in USB, IO is through interrupt in/out endpoints */
-	struct usb_device	*udev;
-	struct urb *piorw_urb;
-	u8 io_irp_cnt;
-	u8 bio_irp_pending;
-	struct semaphore  io_retevt;
-	struct timer_list io_timer;
-	u8 bio_irp_timeout;
-	u8 bio_timer_cancel;
-};
-
 u8 rtw_init_drv_sw(struct adapter *padapter);
 u8 rtw_free_drv_sw(struct adapter *padapter);
 u8 rtw_reset_drv_sw(struct adapter *padapter);
-- 
1.7.10.4

