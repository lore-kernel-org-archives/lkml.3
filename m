Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752744Ab3CBOcG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 09:32:06 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54413 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab3CBOcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 09:32:04 -0500
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 2/2] gfs2: use memchr_inv
Date: Sat,  2 Mar 2013 23:31:35 +0900
Message-Id: <1362234695-5339-2-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362234695-5339-1-git-send-email-akinobu.mita@gmail.com>
References: <1362234695-5339-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use memchr_inv to verify that the specified memory range is cleared.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
---
 fs/gfs2/lock_dlm.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index ead5b36..830ad2f 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -483,12 +483,8 @@ static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
 
 static int all_jid_bits_clear(void *lvb)
 {
-	int i;
-	for (i = JID_BITMAP_OFFSET; i < GDLM_LVB_SIZE; i++) {
-		if (((char *)lvb)[i])
-			return 0;
-	}
-	return 1;
+	return !memchr_inv(lvb + JID_BITMAP_OFFSET, 0,
+			GDLM_LVB_SIZE - JID_BITMAP_OFFSET);
 }
 
 static void sync_wait_cb(void *arg)
-- 
1.8.1.2

