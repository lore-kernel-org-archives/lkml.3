Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaDAJY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:24:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48874 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaDAJQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:19 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 08/29] GFS2: Reduce struct gfs2_trans in size
Date: Tue,  1 Apr 2014 10:15:20 +0100
Message-Id: <1396343741-1524-9-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A couple of "int" fields were being used as boolean values
so we can make them bitfields of one bit, and put them in
what might otherwise be a hole in the structure with 64
bit alignment.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index cf0e344..645655c 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -462,11 +462,11 @@ struct gfs2_trans {
 	unsigned int tr_blocks;
 	unsigned int tr_revokes;
 	unsigned int tr_reserved;
+	unsigned int tr_touched:1;
+	unsigned int tr_attached:1;
 
 	struct gfs2_holder tr_t_gh;
 
-	int tr_touched;
-	int tr_attached;
 
 	unsigned int tr_num_buf_new;
 	unsigned int tr_num_databuf_new;
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 2b20d70..963b28c 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -98,7 +98,7 @@ static void gfs2_print_trans(const struct gfs2_trans *tr)
 {
 	printk(KERN_WARNING "GFS2: Transaction created at: %pSR\n",
 	       (void *)tr->tr_ip);
-	printk(KERN_WARNING "GFS2: blocks=%u revokes=%u reserved=%u touched=%d\n",
+	printk(KERN_WARNING "GFS2: blocks=%u revokes=%u reserved=%u touched=%u\n",
 	       tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
 	printk(KERN_WARNING "GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
 	       tr->tr_num_buf_new, tr->tr_num_buf_rm,
-- 
1.8.3.1

