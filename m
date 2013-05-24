Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab3EXOEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:04:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756056Ab3EXOEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:04:14 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 4/4] GFS2: Fix typo in gfs2_log_end_write loop
Date: Fri, 24 May 2013 14:37:35 +0100
Message-Id: <1369402655-26600-5-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
References: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a missing _all in this loop iterator

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index c5fa758..68b4c8f 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -212,7 +212,7 @@ static void gfs2_end_log_write(struct bio *bio, int error)
 		fs_err(sdp, "Error %d writing to log\n", error);
 	}
 
-	bio_for_each_segment(bvec, bio, i) {
+	bio_for_each_segment_all(bvec, bio, i) {
 		page = bvec->bv_page;
 		if (page_has_buffers(page))
 			gfs2_end_log_write_bh(sdp, bvec, error);
-- 
1.7.4

