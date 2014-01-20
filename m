Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaATMZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:25:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753824AbaATMZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:25:03 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/24] GFS2: Small cleanup
Date: Mon, 20 Jan 2014 12:23:46 +0000
Message-Id: <1390220627-1571-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

This is a small cleanup to function gfs2_rgrp_go_lock so that it
uses rgd instead of its more complicated twin.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index e14e887..a1da213 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1199,7 +1199,7 @@ int gfs2_rgrp_go_lock(struct gfs2_holder *gh)
 
 	if (gh->gh_flags & GL_SKIP && sdp->sd_args.ar_rgrplvb)
 		return 0;
-	return gfs2_rgrp_bh_get((struct gfs2_rgrpd *)gh->gh_gl->gl_object);
+	return gfs2_rgrp_bh_get(rgd);
 }
 
 /**
-- 
1.8.3.1

