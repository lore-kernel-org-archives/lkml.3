Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753743Ab3GAJ7y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:59:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41464 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753646Ab3GAJ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:53 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 04/12] GFS2: Remove no-op wrapper function
Date: Mon,  1 Jul 2013 10:33:07 +0100
Message-Id: <1372671195-3472-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This wrapper function is no longer required, so get rid of it.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c253b13..3768c2f 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1154,11 +1154,6 @@ int gfs2_quota_sync(struct super_block *sb, int type)
 	return error;
 }
 
-static int gfs2_quota_sync_timeo(struct super_block *sb, int type)
-{
-	return gfs2_quota_sync(sb, type);
-}
-
 int gfs2_quota_refresh(struct gfs2_sbd *sdp, struct kqid qid)
 {
 	struct gfs2_quota_data *qd;
@@ -1414,7 +1409,7 @@ int gfs2_quotad(void *data)
 					   &tune->gt_statfs_quantum);
 
 		/* Update quota file */
-		quotad_check_timeo(sdp, "sync", gfs2_quota_sync_timeo, t,
+		quotad_check_timeo(sdp, "sync", gfs2_quota_sync, t,
 				   &quotad_timeo, &tune->gt_quota_quantum);
 
 		/* Check for & recover partially truncated inodes */
-- 
1.7.4

