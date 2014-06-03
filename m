Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbaFCLC6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:02:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64871 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbaFCLC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:02:56 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/6] GFS2: lops.c: replace 0 by NULL for pointers
Date: Tue,  3 Jun 2014 12:02:29 +0100
Message-Id: <1401793353-1469-3-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
References: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

Sparse warning: fs/gfs2/lops.c:78:29:
"warning: Using plain integer as NULL pointer"

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index a294d8d..2c1ae86 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -75,7 +75,7 @@ static void maybe_release_space(struct gfs2_bufdata *bd)
 	unsigned int index = bd->bd_bh->b_blocknr - gl->gl_name.ln_number;
 	struct gfs2_bitmap *bi = rgd->rd_bits + index;
 
-	if (bi->bi_clone == 0)
+	if (bi->bi_clone == NULL)
 		return;
 	if (sdp->sd_args.ar_discard)
 		gfs2_rgrp_send_discards(sdp, rgd->rd_data0, bd->bd_bh, bi, 1, NULL);
-- 
1.8.3.1

