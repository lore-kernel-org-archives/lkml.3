Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaECLrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:47:08 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:64060 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbaECLrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:47:06 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 04/15] staging: rtl8188eu: Remove 'struct list_head list' from struct recv_buf
Date: Sat,  3 May 2014 17:15:21 +0530
Message-Id: <1399117532-8521-5-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Users of 'struct list_head list' variable e.g. rtw_enqueue_recvbuf(),
rtw_enqueue_recvbuf_to_head() and rtw_dequeue_recvbuf() are
already removed.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index b1b1584..98a79ba 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -71,7 +71,6 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		_rtw_init_listhead(&precvbuf->list);
 		spin_lock_init(&precvbuf->recvbuf_lock);
 		precvbuf->alloc_sz = MAX_RECVBUF_SZ;
 		res = rtw_os_recvbuf_resource_alloc(padapter, precvbuf);
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 677859e..103849f 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -235,7 +235,6 @@ struct sta_recv_priv {
 };
 
 struct recv_buf {
-	struct list_head list;
 	spinlock_t recvbuf_lock;
 	u32	ref_cnt;
 	struct adapter *adapter;
-- 
1.7.10.4

