Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209AbaCWS33 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 14:29:29 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:45156 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaCWS32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:29:28 -0400
From: Monam Agarwal <monamagarwal123@gmail.com>
To: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, neilb@suse.de,
        linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/md: Use RCU_INIT_POINTER(x, NULL) in dm.c
Date: Sun, 23 Mar 2014 23:58:27 +0530
Message-Id: <1395599307-6862-1-git-send-email-monamagarwal123@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replaces rcu_assign_pointer(x, NULL) with RCU_INIT_POINTER(x, NULL)

The rcu_assign_pointer() ensures that the initialization of a structure       
is carried out before storing a pointer to that structure. 
And in the case of the NULL pointer, there is no structure to initialize. 
So, rcu_assign_pointer(p, NULL) can be safely converted to RCU_INIT_POINTER(p, NULL)

Signed-off-by: Monam Agarwal <monamagarwal123@gmail.com>
---
 drivers/md/dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8c53b09..804412a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2172,7 +2172,7 @@ static struct dm_table *__unbind(struct mapped_device *md)
 		return NULL;
 
 	dm_table_event_callback(map, NULL, NULL);
-	rcu_assign_pointer(md->map, NULL);
+	RCU_INIT_POINTER(md->map, NULL);
 	dm_sync_table(md);
 
 	return map;
-- 
1.7.9.5

