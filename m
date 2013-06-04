Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3FDO3z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 10:29:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754224Ab3FDOHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 10:07:15 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: Set log descriptor type for jdata blocks
Date: Tue,  4 Jun 2013 14:40:37 +0100
Message-Id: <1370353240-5962-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
References: <1370353240-5962-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch sets the log descriptor type according to whether the
journal commit is for (journaled) data or metadata. This was
recently broken when the functions to process data and metadata
log ops were combined.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 68b4c8f..6c33d7b 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -419,7 +419,9 @@ static void gfs2_before_commit(struct gfs2_sbd *sdp, unsigned int limit,
 		if (total > limit)
 			num = limit;
 		gfs2_log_unlock(sdp);
-		page = gfs2_get_log_desc(sdp, GFS2_LOG_DESC_METADATA, num + 1, num);
+		page = gfs2_get_log_desc(sdp,
+					 is_databuf ? GFS2_LOG_DESC_JDATA :
+					 GFS2_LOG_DESC_METADATA, num + 1, num);
 		ld = page_address(page);
 		gfs2_log_lock(sdp);
 		ptr = (__be64 *)(ld + 1);
-- 
1.7.4

