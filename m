Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaECLrW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:47:22 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:35098 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbaECLrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:47:19 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 05/15] staging: rtl8188eu: Remove 'spinlock_t recvbuf_lock' from struct recv_buf
Date: Sat,  3 May 2014 17:15:22 +0530
Message-Id: <1399117532-8521-6-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

recvbuf_lock is initialized inside rtl8188eu_init_recv_priv() but never used.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 98a79ba..52d83a4 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -71,7 +71,6 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		spin_lock_init(&precvbuf->recvbuf_lock);
 		precvbuf->alloc_sz = MAX_RECVBUF_SZ;
 		res = rtw_os_recvbuf_resource_alloc(padapter, precvbuf);
 		if (res == _FAIL)
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 103849f..4a19a06 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -235,7 +235,6 @@ struct sta_recv_priv {
 };
 
 struct recv_buf {
-	spinlock_t recvbuf_lock;
 	u32	ref_cnt;
 	struct adapter *adapter;
 	u8	*pbuf;
-- 
1.7.10.4

