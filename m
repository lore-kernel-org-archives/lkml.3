Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3GAKAc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:00:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843Ab3GAKA1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:00:27 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Benjamin Marzinski <bmarzins@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 10/12] GFS2: fix warning message
Date: Mon,  1 Jul 2013 10:33:13 +0100
Message-Id: <1372671195-3472-11-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
References: <1372671195-3472-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Marzinski <bmarzins@redhat.com>

This patch fixes a warning message introduced in the recent
"GFS2: aggressively issue revokes in gfs2_log_flush" patch.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 0fa0dba..2b20d70 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -270,7 +270,6 @@ void gfs2_trans_add_meta(struct gfs2_glock *gl, struct buffer_head *bh)
 
 void gfs2_trans_add_revoke(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 {
-	struct gfs2_glock *gl = bd->bd_gl;
 	struct gfs2_trans *tr = current->journal_info;
 
 	BUG_ON(!list_empty(&bd->bd_list));
-- 
1.7.4

