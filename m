Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaBINKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 08:10:25 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:51912 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365AbaBINKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 08:10:24 -0500
Date: Sun, 9 Feb 2014 18:40:19 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>, cluster-devel@redhat.com,
        josh@joshtriplett.org
Subject: [PATCH 10/21] fs: Mark functions as static in gfs2/rgrp.c
Message-ID: <ea8cd448204387985f76078b8649168baaf81ab4.1391949868.git.rashika.kheria@gmail.com>
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark functions as static in gfs2/rgrp.c because they are not used
outside this file.

This eliminates the following warning in gfs2/rgrp.c:
fs/gfs2/rgrp.c:1092:5: warning: no previous prototype for ‘gfs2_rgrp_bh_get’ [-Wmissing-prototypes]
fs/gfs2/rgrp.c:1157:5: warning: no previous prototype for ‘update_rgrp_lvb’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 fs/gfs2/rgrp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index a1da213..551b9e9 100644
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
1.7.9.5

