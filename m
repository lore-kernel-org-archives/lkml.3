Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaFVIwr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 04:52:47 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:54796 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452AbaFVIwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 04:52:44 -0400
From: navin patidar <navin.patidar@gmail.com>
To: gregkh@linuxfoundation.org
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, navin patidar <navin.patidar@gmail.com>
Subject: [PATCH 36/42] staging: rtl8188eu: Use round_up() instead of _RND8()
Date: Sun, 22 Jun 2014 14:21:40 +0530
Message-Id: <1403427107-12744-8-git-send-email-navin.patidar@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
References: <1403427107-12744-1-git-send-email-navin.patidar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: navin patidar <navin.patidar@gmail.com>
---
 drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c    |    2 +-
 drivers/staging/rtl8188eu/include/osdep_service.h |    8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
index ba8beb8..8543847 100644
--- a/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
+++ b/drivers/staging/rtl8188eu/hal/rtl8188eu_xmit.c
@@ -493,7 +493,7 @@ s32 rtl8188eu_xmitframe_complete(struct adapter *adapt, struct xmit_priv *pxmitp
 	pfirstframe = pxmitframe;
 	len = xmitframe_need_length(pfirstframe) + TXDESC_SIZE + (pfirstframe->pkt_offset*PACKET_OFFSET_SZ);
 	pbuf_tail = len;
-	pbuf = _RND8(pbuf_tail);
+	pbuf = round_up(pbuf_tail, 8);
 
 	/*  check pkt amount in one bulk */
 	desc_cnt = 0;
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 2202570..927b30b 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -189,14 +189,6 @@ static inline u32 _RND4(u32 sz)
 	return val;
 }
 
-static inline u32 _RND8(u32 sz)
-{
-	u32	val;
-
-	val = ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
-	return val;
-}
-
 struct rtw_netdev_priv_indicator {
 	void *priv;
 	u32 sizeof_priv;
-- 
1.7.10.4

