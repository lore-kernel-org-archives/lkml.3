Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935627Ab3IEJ2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 05:28:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48403 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763535Ab3IEJ2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:28:46 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/6] GFS2: Remove unnecessary memory barrier
Date: Thu,  5 Sep 2013 10:02:10 +0100
Message-Id: <1378371732-3947-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
References: <1378371732-3947-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

Function test_and_clear_bit implies a memory barrier, so subsequent
memory barriers are unnecessary.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ce7078d..722329c 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1411,7 +1411,6 @@ __acquires(&lru_lock)
 		if (demote_ok(gl))
 			handle_callback(gl, LM_ST_UNLOCKED, 0, false);
 		WARN_ON(!test_and_clear_bit(GLF_LOCK, &gl->gl_flags));
-		smp_mb__after_clear_bit();
 		if (queue_delayed_work(glock_workqueue, &gl->gl_work, 0) == 0)
 			gfs2_glock_put_nolock(gl);
 		spin_unlock(&gl->gl_spin);
-- 
1.7.4

