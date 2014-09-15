Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899AbaIOJdU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbaIOJdP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:15 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Jan Kara <jack@suse.cz>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 5/6] GFS2: Don't use MAXQUOTAS value
Date: Mon, 15 Sep 2014 10:32:47 +0100
Message-Id: <1410773568-1573-6-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
References: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

MAXQUOTAS value defines maximum number of quota types VFS supports.
This isn't necessarily the number of types gfs2 supports and with
addition of project quotas these two numbers stop matching. So make gfs2
use its private definition.

CC: cluster-devel@redhat.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 67d310c..39e7e99 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -262,6 +262,9 @@ struct gfs2_holder {
 	unsigned long gh_ip;
 };
 
+/* Number of quota types we support */
+#define GFS2_MAXQUOTAS 2
+
 /* Resource group multi-block reservation, in order of appearance:
 
    Step 1. Function prepares to write, allocates a mb, sets the size hint.
@@ -282,8 +285,8 @@ struct gfs2_blkreserv {
 	u64 rs_inum;                  /* Inode number for reservation */
 
 	/* ancillary quota stuff */
-	struct gfs2_quota_data *rs_qa_qd[2 * MAXQUOTAS];
-	struct gfs2_holder rs_qa_qd_ghs[2 * MAXQUOTAS];
+	struct gfs2_quota_data *rs_qa_qd[2 * GFS2_MAXQUOTAS];
+	struct gfs2_holder rs_qa_qd_ghs[2 * GFS2_MAXQUOTAS];
 	unsigned int rs_qa_qd_num;
 };
 
-- 
1.8.3.1

