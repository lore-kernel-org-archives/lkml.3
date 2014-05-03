Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaECLtV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:49:21 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48912 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043AbaECLtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:49:18 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 14/15] staging: rtl8188eu: Remove rtl8188eu_init_recvbuf() function
Date: Sat,  3 May 2014 17:15:31 +0530
Message-Id: <1399117532-8521-15-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
References: <1399117532-8521-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rtl8188eu_init_recvbuf() function definition is empty now,
so remove it.

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c    |    4 ----
 drivers/staging/rtl8188eu/hal/usb_ops_linux.c     |    2 --
 drivers/staging/rtl8188eu/include/rtl8188e_recv.h |    1 -
 3 files changed, 7 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
index fc06991..2b45564 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_recv.c
@@ -28,10 +28,6 @@
 
 #include <rtl8188e_hal.h>
 
-void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *precvbuf)
-{
-}
-
 int	rtl8188eu_init_recv_priv(struct adapter *padapter)
 {
 	struct recv_priv	*precvpriv = &padapter->recvpriv;
diff --git a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
index 654c5b3..d3c5ed3 100644
--- a/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/hal/usb_ops_linux.c
@@ -600,8 +600,6 @@ static u32 usb_read_port(struct intf_hdl *pintfhdl, u32 addr, u32 cnt, u8 *rmem)
 			precvbuf->reuse = true;
 	}
 
-	rtl8188eu_init_recvbuf(adapter, precvbuf);
-
 	/* re-assign for linux based on skb */
 	if ((!precvbuf->reuse) || (precvbuf->pskb == NULL)) {
 		precvbuf->pskb = netdev_alloc_skb(adapter->pnetdev, MAX_RECVBUF_SZ + RECVBUFF_ALIGN_SZ);
diff --git a/drivers/staging/rtl8188eu/include/rtl8188e_recv.h b/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
index 07e5f52..5fed30d 100644
--- a/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
+++ b/drivers/staging/rtl8188eu/include/rtl8188e_recv.h
@@ -56,7 +56,6 @@ enum rx_packet_type {
 };
 
 #define INTERRUPT_MSG_FORMAT_LEN 60
-void rtl8188eu_init_recvbuf(struct adapter *padapter, struct recv_buf *buf);
 s32 rtl8188eu_init_recv_priv(struct adapter *padapter);
 void rtl8188eu_free_recv_priv(struct adapter *padapter);
 void rtl8188eu_recv_hdl(struct adapter *padapter, struct recv_buf *precvbuf);
-- 
1.7.10.4

