Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932662AbaFKRWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:22:18 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59011 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932468AbaFKRWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:22:15 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 02/22] staging: rtl8188eu: rtw_io.c: Remove unused function rtw_write16_async()
Date: Wed, 11 Jun 2014 22:51:21 +0530
Message-Id: <1402507301-3722-2-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c    |   13 -------------
 drivers/staging/rtl8188eu/include/rtw_io.h |    4 ----
 2 files changed, 17 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index 009dca5..420b84e 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -139,19 +139,6 @@ int _rtw_writeN(struct adapter *adapter, u32 addr , u32 length , u8 *pdata)
 	return RTW_STATUS_CODE(ret);
 }
 
-int _rtw_write16_async(struct adapter *adapter, u32 addr, u16 val)
-{
-	struct io_priv *pio_priv = &adapter->iopriv;
-	struct	intf_hdl		*pintfhdl = &(pio_priv->intf);
-	int (*_write16_async)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
-	int ret;
-
-	_write16_async = pintfhdl->io_ops._write16_async;
-	ret = _write16_async(pintfhdl, addr, val);
-
-	return RTW_STATUS_CODE(ret);
-}
-
 int _rtw_write32_async(struct adapter *adapter, u32 addr, u32 val)
 {
 	struct io_priv *pio_priv = &adapter->iopriv;
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index 5463164..1943503 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -52,7 +52,6 @@ struct _io_ops {
 	int (*_write32)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
 	int (*_writeN)(struct intf_hdl *pintfhdl, u32 addr, u32 length,
 		       u8 *pdata);
-	int (*_write16_async)(struct intf_hdl *pintfhdl, u32 addr, u16 val);
 	int (*_write32_async)(struct intf_hdl *pintfhdl, u32 addr, u32 val);
 	u32 (*_read_port)(struct intf_hdl *pintfhdl, u32 addr, u32 cnt,
 			  u8 *pmem);
@@ -102,7 +101,6 @@ int _rtw_write16(struct adapter *adapter, u32 addr, u16 val);
 int _rtw_write32(struct adapter *adapter, u32 addr, u32 val);
 int _rtw_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
-int _rtw_write16_async(struct adapter *adapter, u32 addr, u16 val);
 int _rtw_write32_async(struct adapter *adapter, u32 addr, u32 val);
 
 u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
@@ -125,8 +123,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_write32((adapter), (addr), (val))
 #define  rtw_writeN(adapter, addr, length, data)			\
 	_rtw_writeN((adapter), (addr), (length), (data))
-#define rtw_write16_async(adapter, addr, val)				\
-	_rtw_write16_async((adapter), (addr), (val))
 #define rtw_write32_async(adapter, addr, val)				\
 	_rtw_write32_async((adapter), (addr), (val))
 #define rtw_write_port(adapter, addr, cnt, mem)				\
-- 
1.7.10.4

