Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720Ab3GAJ7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:59:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3GAJ7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:59:49 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 02/12] GFS2: Eliminate gfs2_rg_lops
Date: Mon,  1 Jul 2013 10:33:05 +0100
Message-Id: <1372671195-3472-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

With recent changes to the transactions, it appears that we
are no longer using the "log ops" for resource groups. Since the
log commit code processes the array of log ops, eliminating this
should be marginally better for performance. Therefore this patch
eliminates it.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index cb017a6..33f18b7 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -852,10 +852,6 @@ const struct gfs2_log_operations gfs2_revoke_lops = {
 	.lo_name = "revoke",
 };
 
-const struct gfs2_log_operations gfs2_rg_lops = {
-	.lo_name = "rg",
-};
-
 const struct gfs2_log_operations gfs2_databuf_lops = {
 	.lo_before_commit = databuf_lo_before_commit,
 	.lo_after_commit = databuf_lo_after_commit,
@@ -867,7 +863,6 @@ const struct gfs2_log_operations gfs2_databuf_lops = {
 const struct gfs2_log_operations *gfs2_log_ops[] = {
 	&gfs2_databuf_lops,
 	&gfs2_buf_lops,
-	&gfs2_rg_lops,
 	&gfs2_revoke_lops,
 	NULL,
 };
diff --git a/fs/gfs2/lops.h b/fs/gfs2/lops.h
index 87e062e..9ca2e64 100644
--- a/fs/gfs2/lops.h
+++ b/fs/gfs2/lops.h
@@ -23,7 +23,6 @@
 extern const struct gfs2_log_operations gfs2_glock_lops;
 extern const struct gfs2_log_operations gfs2_buf_lops;
 extern const struct gfs2_log_operations gfs2_revoke_lops;
-extern const struct gfs2_log_operations gfs2_rg_lops;
 extern const struct gfs2_log_operations gfs2_databuf_lops;
 
 extern const struct gfs2_log_operations *gfs2_log_ops[];
-- 
1.7.4

