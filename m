Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508AbaFFQQK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:10 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:47539 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaFFQQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 06/13] staging: rtl8188eu: Remove unused funtion _rtw_read_mem()
Date: Fri,  6 Jun 2014 21:45:14 +0530
Message-Id: <1402071320-14400-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c          |   15 ---------------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c    |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h       |    2 --
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    4 ----
 4 files changed, 22 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 7530532..934370e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -177,21 +177,6 @@ int _rtw_write32_async(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-void _rtw_read_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
-{
-	void (*_read_mem)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-
-	if (adapter->bDriverStopped || adapter->bSurpriseRemoved) {
-		RT_TRACE(_module_rtl871x_io_c_, _drv_info_,
-			 ("rtw_read_mem:bDriverStopped(%d) OR bSurpriseRemoved(%d)",
-			 adapter->bDriverStopped, adapter->bSurpriseRemoved));
-	     return;
-	}
-	_read_mem = pintfhdl->io_ops._read_mem;
-	_read_mem(pintfhdl, addr, cnt, pmem);
-}
 
 void _rtw_write_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 {
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 3aadf56..c39dc0c 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -671,7 +671,6 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_read8 = &usb_read8;
 	pops->_read16 = &usb_read16;
 	pops->_read32 = &usb_read32;
-	pops->_read_mem = &usb_read_mem;
 	pops->_read_port = &usb_read_port;
 	pops->_write8 = &usb_write8;
 	pops->_write16 = &usb_write16;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index e8790f8..04338ee 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -112,8 +112,6 @@ struct _io_ops {
 	int (*_write8_async)(struct intf_hdl *pintfhdl, u32 addr, u8 val);
 	int (*_write16_async)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
 	int (*_write32_async)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
-	void (*_read_mem)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
-			  u8 *pmem);
 	void (*_write_mem)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
 			   u8 *pmem);
 	u32 (*_read_interrupt)(struct intf_hdl *pintfhdl, u32 addr);
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 0b5fbb9..27dd7cd 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -39,10 +39,6 @@ unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr)
 	return pipe;
 }
 
-void usb_read_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
-{
-}
-
 void usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
 {
 }
-- 
1.7.10.4

