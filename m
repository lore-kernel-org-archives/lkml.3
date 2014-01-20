Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbaATMY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 07:24:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753724AbaATMYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 07:24:47 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>, Andrew Price <anprice@redhat.com>
Subject: [PATCH 15/24] GFS2: Add initialization for address space in super block
Date: Mon, 20 Jan 2014 12:23:38 +0000
Message-Id: <1390220627-1571-16-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
References: <1390220627-1571-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spotted by Andy Price. This should fix the odd messages from
lockdep caused by 70d4ee94b370c5ef54d0870600f16bd92d18013c

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Cc: Andrew Price <anprice@redhat.com>

diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 94aab31..3b820b6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -102,6 +102,7 @@ static struct gfs2_sbd *init_sbd(struct super_block *sb)
 
 	mapping = &sdp->sd_aspace;
 
+	address_space_init_once(mapping);
 	mapping->a_ops = &gfs2_meta_aops;
 	mapping->host = sb->s_bdev->bd_inode;
 	mapping->flags = 0;
-- 
1.8.3.1

