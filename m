Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaFWAmW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:42:22 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39879 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaFWAmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:42:20 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 2/4] staging: rtl8712: remove inline _RND128() and use round_up()
Date: Sun, 22 Jun 2014 20:27:56 -0400
Message-Id: <1403483278-7343-2-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1403483278-7343-1-git-send-email-shack@linux.com>
References: <1403483278-7343-1-git-send-email-shack@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h |    5 -----
 drivers/staging/rtl8712/rtl8712_recv.c  |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 6af0df9..37ec56b 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -184,11 +184,6 @@ static inline void flush_signals_thread(void)
 		flush_signals(current);
 }
 
-static inline u32 _RND128(u32 sz)
-{
-	return ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
-}
-
 static inline u32 _RND256(u32 sz)
 {
 	return ((sz >> 8) + ((sz & 255) ? 1 : 0)) << 8;
diff --git a/drivers/staging/rtl8712/rtl8712_recv.c b/drivers/staging/rtl8712/rtl8712_recv.c
index 1f70017..fb947c1 100644
--- a/drivers/staging/rtl8712/rtl8712_recv.c
+++ b/drivers/staging/rtl8712/rtl8712_recv.c
@@ -1065,7 +1065,7 @@ static int recvbuf2recvframe(struct _adapter *padapter, struct sk_buff *pskb)
 		precvframe->u.hdr.precvbuf = NULL; /*can't access the precvbuf*/
 		precvframe->u.hdr.len = 0;
 		tmp_len = pkt_len + drvinfo_sz + RXDESC_SIZE;
-		pkt_offset = (u16)_RND128(tmp_len);
+		pkt_offset = (u16)round_up(tmp_len, 128);
 		/* for first fragment packet, driver need allocate 1536 +
 		 * drvinfo_sz + RXDESC_SIZE to defrag packet. */
 		if ((mf == 1) && (frag == 0))
-- 
1.7.9.5

