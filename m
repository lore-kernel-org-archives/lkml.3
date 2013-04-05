Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161825Ab3DEKYc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 06:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29906 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161175Ab3DEKY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 06:24:29 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/6] GFS2: return error if malloc failed in gfs2_rs_alloc()
Date: Fri,  5 Apr 2013 10:57:13 +0100
Message-Id: <1365155836-3069-4-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
References: <1365155836-3069-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The error code in gfs2_rs_alloc() is set to ENOMEM when error
but never be used, instead, gfs2_rs_alloc() always return 0.
Fix to return 'error'.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index d1f51fd..70d1cd0 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -576,7 +576,7 @@ int gfs2_rs_alloc(struct gfs2_inode *ip)
 	RB_CLEAR_NODE(&ip->i_res->rs_node);
 out:
 	up_write(&ip->i_rw_mutex);
-	return 0;
+	return error;
 }
 
 static void dump_rs(struct seq_file *seq, const struct gfs2_blkreserv *rs)
-- 
1.7.4

