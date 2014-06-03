Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaFCLCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:02:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaFCLCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:02:50 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhi Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/6] GFS2: quotas not being refreshed in gfs2_adjust_quota
Date: Tue,  3 Jun 2014 12:02:28 +0100
Message-Id: <1401793353-1469-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
References: <1401793353-1469-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhi Das <adas@redhat.com>

Old values of user quota limits were being used and
could allow users to exceed their allotted quotas.
This patch refreshes the limits to the latest values
so that quotas are enforced correctly.

Resolves: rhbz#1077463
Signed-off-by: Abhi Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index c4effff..6193896 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -778,6 +778,7 @@ get_a_page:
 		i_size_write(inode, size);
 	inode->i_mtime = inode->i_atime = CURRENT_TIME;
 	mark_inode_dirty(inode);
+	set_bit(QDF_REFRESH, &qd->qd_flags);
 	return 0;
 
 unlock_out:
-- 
1.8.3.1

