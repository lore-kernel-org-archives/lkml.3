Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426AbaFKRYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:24:24 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40838 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbaFKRYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:24:22 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 20/22] staging: rtl8188eu: rtw_io.h: Remove unused structures and macros
Date: Wed, 11 Jun 2014 22:51:39 +0530
Message-Id: <1402507301-3722-20-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/drv_types.h |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h    |   42 -------------------------
 2 files changed, 43 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/drv_types.h b/drivers/staging/rtl8188eu/include/drv_types.h
index 974f12f..8063caa 100644
--- a/drivers/staging/rtl8188eu/include/drv_types.h
+++ b/drivers/staging/rtl8188eu/include/drv_types.h
@@ -196,7 +196,6 @@ struct adapter {
 	struct	mlme_ext_priv mlmeextpriv;
 	struct	cmd_priv	cmdpriv;
 	struct	evt_priv	evtpriv;
-	struct	io_priv	iopriv;
 	struct	xmit_priv	xmitpriv;
 	struct	recv_priv	recvpriv;
 	struct	sta_priv	stapriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 86431b8..41e3dd8 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -33,48 +33,6 @@
 #include <linux/usb.h>
 #include <linux/usb/ch9.h>
 
-#define rtw_usb_buffer_alloc(dev, size, dma)				\
-	usb_alloc_coherent((dev), (size), (in_interrupt() ?		\
-			   GFP_ATOMIC : GFP_KERNEL), (dma))
-#define rtw_usb_buffer_free(dev, size, addr, dma)			\
-	usb_free_coherent((dev), (size), (addr), (dma))
-
-
-struct intf_priv;
-struct intf_hdl;
-
-struct _io_ops {
-};
-
-struct io_req {
-	struct list_head list;
-	u32	addr;
-	u32	val;
-	u32	command;
-	u32	status;
-	u8	*pbuf;
-	struct semaphore sema;
-
-	void (*_async_io_callback)(struct adapter *padater,
-				   struct io_req *pio_req, u8 *cnxt);
-	u8 *cnxt;
-};
-
-struct	intf_hdl {
-	struct adapter *padapter;
-	struct dvobj_priv *pintf_dev;
-	struct _io_ops	io_ops;
-};
-
-/*
-Below is the data structure used by _io_handler
-*/
-
-struct io_priv {
-	struct adapter *padapter;
-	struct intf_hdl intf;
-};
-
 u8 usb_read8(struct adapter *adapter, u32 addr);
 u16 usb_read16(struct adapter *adapter, u32 addr);
 u32 usb_read32(struct adapter *adapter, u32 addr);
-- 
1.7.10.4

