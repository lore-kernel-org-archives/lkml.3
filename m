Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaDAJZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:25:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751426AbaDAJQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:15 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/29] GFS2: Mark functions as static in gfs2/rgrp.c
Date: Tue,  1 Apr 2014 10:15:18 +0100
Message-Id: <1396343741-1524-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rashika Kheria <rashika.kheria@gmail.com>

Mark functions as static in gfs2/rgrp.c because they are not used
outside this file.

This eliminates the following warning in gfs2/rgrp.c:
fs/gfs2/rgrp.c:1092:5: warning: no previous prototype for ‘gfs2_rgrp_bh_get’ [-Wmissing-prototypes]
fs/gfs2/rgrp.c:1157:5: warning: no previous prototype for ‘update_rgrp_lvb’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index c13e4c5..f585746 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1102,7 +1102,7 @@ static u32 count_unlinked(struct gfs2_rgrpd *rgd)
  * Returns: errno
  */
 
-int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
+static int gfs2_rgrp_bh_get(struct gfs2_rgrpd *rgd)
 {
 	struct gfs2_sbd *sdp = rgd->rd_sbd;
 	struct gfs2_glock *gl = rgd->rd_gl;
@@ -1169,7 +1169,7 @@ fail:
 	return error;
 }
 
-int update_rgrp_lvb(struct gfs2_rgrpd *rgd)
+static int update_rgrp_lvb(struct gfs2_rgrpd *rgd)
 {
 	u32 rl_flags;
 
-- 
1.8.3.1

