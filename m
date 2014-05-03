Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaECLsf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:48:35 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:41679 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaECLsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:48:33 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 10/15] staging: rtl8188eu: Remove 'pallocated_buf' from struct recv_buf
Date: Sat,  3 May 2014 17:15:27 +0530
Message-Id: <1399117532-8521-11-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pallocated_buf is not being used by driver.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/rtw_recv.h  |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 987445a..b955d73 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -238,7 +238,6 @@ struct recv_buf {
 	u32	ref_cnt;
 	struct adapter *adapter;
 	u8	*pbuf;
-	u8	*pallocated_buf;
 	u32	len;
 	struct urb *purb;
 	u32 alloc_sz;
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 7f9b654..25358fb 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -60,7 +60,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 		res = _FAIL;
 	precvbuf->pskb = NULL;
 	precvbuf->reuse = false;
-	precvbuf->pallocated_buf = NULL;
 	precvbuf->pbuf = NULL;
 	precvbuf->len = 0;
 	return res;
-- 
1.7.10.4

