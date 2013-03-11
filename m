Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3CKPBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 11:01:40 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:33944 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3CKPBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 11:01:39 -0400
MIME-Version: 1.0
Date: Mon, 11 Mar 2013 23:01:37 +0800
Message-ID: <CAPgLHd9eg02c+HiLN9AGNDYUCx1qey7sSr6DoR6tJnp20eAvcw@mail.gmail.com>
Subject: [PATCH] GFS2: return error if malloc failed in gfs2_rs_alloc()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: swhiteho@redhat.com
Cc: yongjun_wei@trendmicro.com.cn, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

The error code in gfs2_rs_alloc() is set to ENOMEM when error
but never be used, instead, gfs2_rs_alloc() always return 0.
Fix to return 'error'.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 fs/gfs2/rgrp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 9d16a6f..b850198 100644
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


