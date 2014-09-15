Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbaIOJd6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 05:33:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753796AbaIOJdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 05:33:10 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/6] GFS2: fs/gfs2/super.c: replace seq_printf by seq_puts
Date: Mon, 15 Sep 2014 10:32:43 +0100
Message-Id: <1410773568-1573-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
References: <1410773568-1573-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

fix checkpatch warnings:
"WARNING: Prefer seq_puts to seq_printf"

Cc: cluster-devel@redhat.com
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2607ff1..a346f56 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1294,7 +1294,7 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	int val;
 
 	if (is_ancestor(root, sdp->sd_master_dir))
-		seq_printf(s, ",meta");
+		seq_puts(s, ",meta");
 	if (args->ar_lockproto[0])
 		seq_printf(s, ",lockproto=%s", args->ar_lockproto);
 	if (args->ar_locktable[0])
@@ -1302,13 +1302,13 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	if (args->ar_hostdata[0])
 		seq_printf(s, ",hostdata=%s", args->ar_hostdata);
 	if (args->ar_spectator)
-		seq_printf(s, ",spectator");
+		seq_puts(s, ",spectator");
 	if (args->ar_localflocks)
-		seq_printf(s, ",localflocks");
+		seq_puts(s, ",localflocks");
 	if (args->ar_debug)
-		seq_printf(s, ",debug");
+		seq_puts(s, ",debug");
 	if (args->ar_posix_acl)
-		seq_printf(s, ",acl");
+		seq_puts(s, ",acl");
 	if (args->ar_quota != GFS2_QUOTA_DEFAULT) {
 		char *state;
 		switch (args->ar_quota) {
@@ -1328,7 +1328,7 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",quota=%s", state);
 	}
 	if (args->ar_suiddir)
-		seq_printf(s, ",suiddir");
+		seq_puts(s, ",suiddir");
 	if (args->ar_data != GFS2_DATA_DEFAULT) {
 		char *state;
 		switch (args->ar_data) {
@@ -1345,7 +1345,7 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",data=%s", state);
 	}
 	if (args->ar_discard)
-		seq_printf(s, ",discard");
+		seq_puts(s, ",discard");
 	val = sdp->sd_tune.gt_logd_secs;
 	if (val != 30)
 		seq_printf(s, ",commit=%d", val);
@@ -1376,11 +1376,11 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 		seq_printf(s, ",errors=%s", state);
 	}
 	if (test_bit(SDF_NOBARRIERS, &sdp->sd_flags))
-		seq_printf(s, ",nobarrier");
+		seq_puts(s, ",nobarrier");
 	if (test_bit(SDF_DEMOTE, &sdp->sd_flags))
-		seq_printf(s, ",demote_interface_used");
+		seq_puts(s, ",demote_interface_used");
 	if (args->ar_rgrplvb)
-		seq_printf(s, ",rgrplvb");
+		seq_puts(s, ",rgrplvb");
 	return 0;
 }
 
-- 
1.8.3.1

