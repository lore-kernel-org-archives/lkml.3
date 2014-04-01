Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaDAJQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699AbaDAJQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:38 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Joe Perches <joe@perches.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 19/29] GFS2: Use fs_<level> more often
Date: Tue,  1 Apr 2014 10:15:31 +0100
Message-Id: <1396343741-1524-20-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Convert a couple of uses of pr_<level> to fs_<level>
Add and use fs_emerg.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index 73ed925..27f9435 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1083,8 +1083,8 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	pr_info("fsid=%s: quota %s for %s %u\n",
-		sdp->sd_fsname, type,
+	fs_info(sdp, "quota %s for %s %u\n",
+		type,
 		(qd->qd_id.type == USRQUOTA) ? "user" : "group",
 		from_kqid(&init_user_ns, qd->qd_id));
 
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index 02fb38d..84bf853 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -32,7 +32,7 @@ mempool_t *gfs2_page_pool __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
-	pr_emerg("fsid=%s: fatal assertion failed\n", sdp->sd_fsname);
+	fs_emerg(sdp, "fatal assertion failed\n");
 }
 
 int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
@@ -106,8 +106,8 @@ int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
 		return -2;
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW)
-		pr_warn("fsid=%s: warning: assertion \"%s\" failed at function = %s, file = %s, line = %u\n",
-			sdp->sd_fsname, assertion, function, file, line);
+		fs_warn(sdp, "warning: assertion \"%s\" failed at function = %s, file = %s, line = %u\n",
+			assertion, function, file, line);
 
 	if (sdp->sd_args.ar_debug)
 		BUG();
diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
index d365733..515cce2 100644
--- a/fs/gfs2/util.h
+++ b/fs/gfs2/util.h
@@ -19,6 +19,8 @@
 
 #include "incore.h"
 
+#define fs_emerg(fs, fmt, ...)						\
+	pr_emerg("fsid=%s: " fmt, (fs)->sd_fsname, ##__VA_ARGS__)
 #define fs_warn(fs, fmt, ...)						\
 	pr_warn("fsid=%s: " fmt, (fs)->sd_fsname, ##__VA_ARGS__)
 #define fs_err(fs, fmt, ...)						\
-- 
1.8.3.1

