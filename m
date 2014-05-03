Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbaECLs7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:48:59 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:61667 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaECLs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:48:57 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 12/15] staging: rtl8188eu: Remove 'u32 len' from struct recv_buf
Date: Sat,  3 May 2014 17:15:29 +0530
Message-Id: <1399117532-8521-13-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused variable 'u32 len'.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 3edc2cd..740818a5 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -30,7 +30,6 @@
 
 void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *precvbuf)
 {
-	precvbuf->len = 0;
 	precvbuf->ref_cnt = 0;
 }
 
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 519ed4e..3f43f11 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -238,7 +238,6 @@ struct recv_buf {
 	u32	ref_cnt;
 	struct adapter *adapter;
 	u8	*pbuf;
-	u32	len;
 	struct urb *purb;
 	struct sk_buff *pskb;
 	u8	reuse;
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 25358fb..2577ceb6 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -61,7 +61,6 @@ int rtw_os_recvbuf_resource_alloc(struct adapter *padapter,
 	precvbuf->pskb = NULL;
 	precvbuf->reuse = false;
 	precvbuf->pbuf = NULL;
-	precvbuf->len = 0;
 	return res;
 }
 
-- 
1.7.10.4

