Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab3EXOFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:05:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161Ab3EXOEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:04:09 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/4] GFS2: two minor quota fixups
Date: Fri, 24 May 2013 14:37:32 +0100
Message-Id: <1369402655-26600-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
References: <1369402655-26600-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This patch fixes two regression problems that Abhi found in the
GFS2 quota code.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c7c840e..c253b13 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -121,7 +121,7 @@ static u64 qd2index(struct gfs2_quota_data *qd)
 {
 	struct kqid qid = qd->qd_id;
 	return (2 * (u64)from_kqid(&init_user_ns, qid)) +
-		(qid.type == USRQUOTA) ? 0 : 1;
+		((qid.type == USRQUOTA) ? 0 : 1);
 }
 
 static u64 qd2offset(struct gfs2_quota_data *qd)
@@ -721,7 +721,7 @@ get_a_page:
 			goto unlock_out;
 	}
 
-	gfs2_trans_add_meta(ip->i_gl, bh);
+	gfs2_trans_add_data(ip->i_gl, bh);
 
 	kaddr = kmap_atomic(page);
 	if (offset + sizeof(struct gfs2_quota) > PAGE_CACHE_SIZE)
-- 
1.7.4

