Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbaATMbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:31:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753322AbaATMYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:32 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 06/24] GFS2: Remove test which is always true
Date: Mon, 20 Jan 2014 12:23:29 +0000
Message-Id: <1390220627-1571-7-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since gfs2_inplace_reserve() is always called with a valid
alloc parms structure, there is no need to test for this
within the function itself - and in any case, after we've
all ready dereferenced it anyway.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 797f1d3..2584710 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -1943,7 +1943,7 @@ int gfs2_inplace_reserve(struct gfs2_inode *ip, const struct gfs2_alloc_parms *a
 		/* Skip unuseable resource groups */
 		if ((rs->rs_rbm.rgd->rd_flags & (GFS2_RGF_NOALLOC |
 						 GFS2_RDF_ERROR)) ||
-		    (ap && (ap->target > rs->rs_rbm.rgd->rd_extfail_pt)))
+		    (ap->target > rs->rs_rbm.rgd->rd_extfail_pt))
 			goto skip_rgrp;
 
 		if (sdp->sd_args.ar_rgrplvb)
-- 
1.8.3.1

