Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaECLtL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:49:11 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:55996 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaECLtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:49:08 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 13/15] staging: rtl8188eu: Remove 'u32 ref_cnt' from struct recv_buf
Date: Sat,  3 May 2014 17:15:30 +0530
Message-Id: <1399117532-8521-14-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver isn't making any use of value stored in variable ref_cnt.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    2 --
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    1 -
 drivers/staging/rtl8188eu/os_dep/recv_linux.c  |    1 -
 3 files changed, 4 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 740818a5..fc06991 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -30,7 +30,6 @@
 
 void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *precvbuf)
 {
-	precvbuf->ref_cnt = 0;
 }
 
 int	rtl8188eu_init_recv_priv(struct adapter *padapter)
@@ -63,7 +62,6 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 		res = rtw_os_recvbuf_resource_alloc(padapter, precvbuf);
 		if (res == _FAIL)
 			break;
-		precvbuf->ref_cnt = 0;
 		precvbuf->adapter = padapter;
 		precvbuf++;
 	}
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index 3f43f11..8dadf30 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -235,7 +235,6 @@ struct sta_recv_priv {
 };
 
 struct recv_buf {
-	u32	ref_cnt;
 	struct adapter *adapter;
 	u8	*pbuf;
 	struct urb *purb;
diff --git a/drivers/staging/rtl8188eu/os_dep/recv_linux.c b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
index 2577ceb6..c1664b7 100644
--- a/drivers/staging/rtl8188eu/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/recv_linux.c
@@ -221,7 +221,6 @@ void rtw_os_read_port(struct adapter *padapter, struct recv_buf *precvbuf)
 {
 	struct recv_priv *precvpriv = &padapter->recvpriv;
 
-	precvbuf->ref_cnt--;
 	/* free skb in recv_buf */
 	dev_kfree_skb_any(precvbuf->pskb);
 	precvbuf->pskb = NULL;
-- 
1.7.10.4

