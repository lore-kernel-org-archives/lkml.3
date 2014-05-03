Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346AbaECLsq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:48:46 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50248 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaECLso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:48:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 11/15] staging: rtl8188eu: Remove 'alloc_sz' from struct recv_buf
Date: Sat,  3 May 2014 17:15:28 +0530
Message-Id: <1399117532-8521-12-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver isn't making any use of value stored in alloc_sz variable.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c |    1 -
 drivers/staging/rtl8188eu/include/rtw_recv.h   |    1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index 41a0c0d..3edc2cd 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -61,7 +61,6 @@ int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 	precvbuf = (struct recv_buf *)precvpriv->precv_buf;
 
 	for (i = 0; i < NR_RECVBUFF; i++) {
-		precvbuf->alloc_sz = MAX_RECVBUF_SZ;
 		res = rtw_os_recvbuf_resource_alloc(padapter, precvbuf);
 		if (res == _FAIL)
 			break;
diff --git a/drivers/staging/rtl8188eu/include/rtw_recv.h b/drivers/staging/rtl8188eu/include/rtw_recv.h
index b955d73..519ed4e 100644
--- a/drivers/staging/rtl8188eu/include/rtw_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtw_recv.h
@@ -240,7 +240,6 @@ struct recv_buf {
 	u8	*pbuf;
 	u32	len;
 	struct urb *purb;
-	u32 alloc_sz;
 	struct sk_buff *pskb;
 	u8	reuse;
 };
-- 
1.7.10.4

