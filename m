Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161812Ab3DEKYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:24:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17857 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765935Ab3DEKYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:24:17 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>,
        Christine Caulfield <ccaulfie@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 2/6] GFS2: use memchr_inv
Date: Fri,  5 Apr 2013 10:57:12 +0100
Message-Id: <1365155836-3069-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
References: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

Use memchr_inv to verify that the specified memory range is cleared.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com
Cc: Christine Caulfield <ccaulfie@redhat.com>
Cc: David Teigland <teigland@redhat.com>

diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index b15bb45..c8423d6 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -483,12 +483,8 @@ static void control_lvb_write(struct lm_lockstruct *ls, uint32_t lvb_gen,
 
 static int all_jid_bits_clear(char *lvb)
 {
-	int i;
-	for (i = JID_BITMAP_OFFSET; i < GDLM_LVB_SIZE; i++) {
-		if (lvb[i])
-			return 0;
-	}
-	return 1;
+	return !memchr_inv(lvb + JID_BITMAP_OFFSET, 0,
+			GDLM_LVB_SIZE - JID_BITMAP_OFFSET);
 }
 
 static void sync_wait_cb(void *arg)
-- 
1.7.4

