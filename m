Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932928AbaFKRWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 13:22:30 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:39750 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502AbaFKRW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:22:28 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/22] staging: rtl8188eu: rtw_io.c: Remove unused function _rtw_write_port_and_wait()
Date: Wed, 11 Jun 2014 22:51:23 +0530
Message-Id: <1402507301-3722-4-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
References: <1402507301-3722-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/core/rtw_io.c    |   17 -----------------
 drivers/staging/rtl8188eu/include/rtw_io.h |    4 ----
 2 files changed, 21 deletions(-)

diff --git a/drivers/staging/rtl8188eu/core/rtw_io.c b/drivers/staging/rtl8188eu/core/rtw_io.c
index ed6cd2b..a0a31e6 100644
--- a/drivers/staging/rtl8188eu/core/rtw_io.c
+++ b/drivers/staging/rtl8188eu/core/rtw_io.c
@@ -187,23 +187,6 @@ u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem)
 	return ret;
 }
 
-u32 _rtw_write_port_and_wait(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem, int timeout_ms)
-{
-	int ret = _SUCCESS;
-	struct xmit_buf *pxmitbuf = (struct xmit_buf *)pmem;
-	struct submit_ctx sctx;
-
-	rtw_sctx_init(&sctx, timeout_ms);
-	pxmitbuf->sctx = &sctx;
-
-	ret = _rtw_write_port(adapter, addr, cnt, pmem);
-
-	if (ret == _SUCCESS)
-		ret = rtw_sctx_wait(&sctx);
-
-	return ret;
-}
-
 void _rtw_write_port_cancel(struct adapter *adapter)
 {
 	void (*_write_port_cancel)(struct intf_hdl *pintfhdl);
diff --git a/drivers/staging/rtl8188eu/include/rtw_io.h b/drivers/staging/rtl8188eu/include/rtw_io.h
index e47d819..4c8a8c1 100644
--- a/drivers/staging/rtl8188eu/include/rtw_io.h
+++ b/drivers/staging/rtl8188eu/include/rtw_io.h
@@ -101,8 +101,6 @@ int _rtw_write32(struct adapter *adapter, u32 addr, u32 val);
 int _rtw_writeN(struct adapter *adapter, u32 addr, u32 length, u8 *pdata);
 
 u32 _rtw_write_port(struct adapter *adapter, u32 addr, u32 cnt, u8 *pmem);
-u32 _rtw_write_port_and_wait(struct adapter *adapter, u32 addr, u32 cnt,
-			     u8 *pmem, int timeout_ms);
 void _rtw_write_port_cancel(struct adapter *adapter);
 
 #define rtw_read8(adapter, addr) _rtw_read8((adapter), (addr))
@@ -122,8 +120,6 @@ void _rtw_write_port_cancel(struct adapter *adapter);
 	_rtw_writeN((adapter), (addr), (length), (data))
 #define rtw_write_port(adapter, addr, cnt, mem)				\
 	_rtw_write_port((adapter), (addr), (cnt), (mem))
-#define rtw_write_port_and_wait(adapter, addr, cnt, mem, timeout_ms)	\
-	_rtw_write_port_and_wait((adapter), (addr), (cnt), (mem), (timeout_ms))
 #define rtw_write_port_cancel(adapter) _rtw_write_port_cancel((adapter))
 
 void rtw_write_scsi(struct adapter *adapter, u32 cnt, u8 *pmem);
-- 
1.7.10.4

