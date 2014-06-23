Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423AbaFWAmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 20:42:11 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:36144 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaFWAmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 20:42:09 -0400
From: James A Shackleford <shack@linux.com>
To: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: James A Shackleford <shack@linux.com>
Subject: [PATCH 1/4] staging: rtl8712: remove inline _RND8() and use round_up()
Date: Sun, 22 Jun 2014 20:27:55 -0400
Message-Id: <1403483278-7343-1-git-send-email-shack@linux.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: James A Shackleford <shack@linux.com>
---
 drivers/staging/rtl8712/osdep_service.h |    5 -----
 drivers/staging/rtl8712/rtl8712_cmd.c   |    2 +-
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8712/osdep_service.h b/drivers/staging/rtl8712/osdep_service.h
index 09e1561..6af0df9 100644
--- a/drivers/staging/rtl8712/osdep_service.h
+++ b/drivers/staging/rtl8712/osdep_service.h
@@ -184,11 +184,6 @@ static inline void flush_signals_thread(void)
 		flush_signals(current);
 }
 
-static inline u32 _RND8(u32 sz)
-{
-	return ((sz >> 3) + ((sz & 7) ? 1 : 0)) << 3;
-}
-
 static inline u32 _RND128(u32 sz)
 {
 	return ((sz >> 7) + ((sz & 127) ? 1 : 0)) << 7;
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 8ca7d7e..4998fde 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -351,7 +351,7 @@ _next:
 						    &padapter->dvobjpriv;
 			u8 blnPending = 0;
 			pcmdpriv->cmd_issued_cnt++;
-			cmdsz = _RND8((pcmd->cmdsz)); /* _RND8	*/
+			cmdsz = round_up(pcmd->cmdsz, 8);
 			wr_sz = TXDESC_SIZE + 8 + cmdsz;
 			pdesc->txdw0 |= cpu_to_le32((wr_sz-TXDESC_SIZE) &
 						     0x0000ffff);
-- 
1.7.9.5

