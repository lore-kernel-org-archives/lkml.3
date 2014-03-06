Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaCFULM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 15:11:12 -0500
Received: from smtprelay0189.hostedemail.com ([216.40.44.189]:39334 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752053AbaCFULI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 15:11:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3866:3867:3868:4321:5007:6119:6261:10004:10026:10848:11026:11473:11658:11914:12296:12438:12517:12519:12555,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glove79_604d3ba02df43
X-Filterd-Recvd-Size: 3054
From: Joe Perches <joe@perches.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com
Subject: [PATCH 2/3] gfs2: Use fs_<level> more often
Date: Thu,  6 Mar 2014 12:10:46 -0800
Message-Id: <03faf31520f7ee9d3cff6e5e98588be7cbf1e5c9.1394136338.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
References: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
In-Reply-To: <cover.1394136338.git.joe@perches.com>
References: <cover.1394136338.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert a couple of uses of pr_<level> to fs_<level>
Add and use fs_emerg.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/gfs2/quota.c | 4 ++--
 fs/gfs2/util.c  | 6 +++---
 fs/gfs2/util.h  | 2 ++
 3 files changed, 7 insertions(+), 5 deletions(-)

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
1.8.1.2.459.gbcd45b4.dirty

