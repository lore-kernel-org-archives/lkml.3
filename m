Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaFVIwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:40 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:55053 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaFVIwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:37 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 35/42] staging: rtl8188eu: Use round_up() instead of _RND128()
Date: Sun, 22 Jun 2014 14:21:39 +0530
Message-Id: <1403427107-12744-7-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/include/osdep_service.h |    8 --------
 drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c  |    2 +-
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 1bf324c..2202570 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -197,14 +197,6 @@ static inline u32 _RND8(u32 sz)
 	return val;
 }
 
-static inline u32 _RND128(u32 sz)
-{
-	u32	val;
-
-	val = ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
-	return val;
-}
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
diff --git a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
index 8015c3a..eddff41 100644
--- a/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
+++ b/drivers/staging/rtl8188eu/os_dep/usb_ops_linux.c
@@ -160,7 +160,7 @@ static int recvbuf2recvframe(struct adapter *adapt, struct sk_buff *pskb)
 		switch (haldata->UsbRxAggMode) {
 		case USB_RX_AGG_DMA:
 		case USB_RX_AGG_MIX:
-			pkt_offset = (u16)_RND128(pkt_offset);
+			pkt_offset = (u16) round_up(pkt_offset, 128);
 			break;
 		case USB_RX_AGG_USB:
 			pkt_offset = (u16)_RND4(pkt_offset);
-- 
1.7.10.4

