Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaFFQQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 12:16:16 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63372 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234AbaFFQQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 12:16:13 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 07/13] staging: rtl8188eu: Remove unused function _rtw_write_mem()
Date: Fri,  6 Jun 2014 21:45:15 +0530
Message-Id: <1402071320-14400-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
References: <1402071320-14400-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c          |   14 --------------
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c    |    1 -
 drivers/staging/rtl8188eu/include/rtw_io.h       |    5 -----
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c |    4 ----
 4 files changed, 24 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 934370e..292b6a1 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -177,20 +177,6 @@ int _rtw_write32_async(struct adapter *adapter, u32 addr, u32 val)
 	return RTW_STATUS_CODE(ret);
 }
 
-
-void _rtw_write_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
-{
-	void (*_write_mem)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-
-
-	_write_mem = pintfhdl->io_ops._write_mem;
-
-	_write_mem(pintfhdl, addr, cnt, pmem);
-
-}
-
 void _rtw_read_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 {
 	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *pmem);
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index c39dc0c..6a1be6e 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -676,7 +676,6 @@ void rtl8188eu_set_intf_ops(struct _io_ops	*pops)
 	pops->_write16 = &usb_write16;
 	pops->_write32 = &usb_write32;
 	pops->_writeN = &usb_writeN;
-	pops->_write_mem = &usb_write_mem;
 	pops->_write_port = &usb_write_port;
 	pops->_read_port_cancel = &usb_read_port_cancel;
 	pops->_write_port_cancel = &usb_write_port_cancel;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 04338ee..958fc52 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -112,8 +112,6 @@ struct _io_ops {
 	int (*_write8_async)(struct intf_hdl *pintfhdl, u32 addr, u8 val);
 	int (*_write16_async)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
 	int (*_write32_async)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
-	void (*_write_mem)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
-			   u8 *pmem);
 	u32 (*_read_interrupt)(struct intf_hdl *pintfhdl, u32 addr);
 	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
 			  u8 *pmem);
@@ -254,7 +252,6 @@ int _rtw_write8_async(struct adapter *adapter, u32 addr, u8 val);
 int _rtw_write16_async(struct adapter *adapter, u32 addr, u16 val);
 int _rtw_write32_async(struct adapter *adapter, u32 addr, u32 val);
 
-void _rtw_write_mem(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
 u32 _rtw_write_port_and_wait(struct adapter *adapter, u32 addr, u32 cnt,
 			     u8 *pmem, int timeout_ms);
@@ -283,8 +280,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_write16_async((adapter), (addr), (val))
 #define rtw_write32_async(adapter, addr, val)				\
 	_rtw_write32_async((adapter), (addr), (val))
-#define rtw_write_mem(adapter, addr, cnt, mem)				\
-	_rtw_write_mem((adapter), (addr), (cnt), (mem))
 #define rtw_write_port(adapter, addr, cnt, mem)				\
 	_rtw_write_port((adapter), (addr), (cnt), (mem))
 #define rtw_write_port_and_wait(adapter, addr, cnt, mem, timeout_ms)	\
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 27dd7cd..5bac414 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -39,10 +39,6 @@ unsigned int ffaddr2pipehdl(struct dvobj_priv *pdvobj, u32 addr)
 	return pipe;
 }
 
-void usb_write_mem(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *wmem)
-{
-}
-
 void usb_read_port_cancel(struct intf_hdl *pintfhdl)
 {
 	int i;
-- 
1.7.10.4

