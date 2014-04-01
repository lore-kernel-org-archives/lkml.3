Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836AbaDAJUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:20:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11375 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715AbaDAJQm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:42 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 21/29] GFS2: check NULL return value in gfs2_ok_to_move
Date: Tue,  1 Apr 2014 10:15:33 +0100
Message-Id: <1396343741-1524-22-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhi Das <adas@redhat.com>

gfs2_lookupi() can return NULL if the path to the root is broken by
another rename/rmdir. In this case gfs2_ok_to_move() must check for
this NULL pointer and return error.

Resolves: rhbz#1060246
Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index ec455b9..b52ebf8 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1299,6 +1299,10 @@ static int gfs2_ok_to_move(struct gfs2_inode *this, struct gfs2_inode *to)
 		}
 
 		tmp = gfs2_lookupi(dir, &gfs2_qdotdot, 1);
+		if (!tmp) {
+			error = -ENOENT;
+			break;
+		}
 		if (IS_ERR(tmp)) {
 			error = PTR_ERR(tmp);
 			break;
-- 
1.8.3.1

