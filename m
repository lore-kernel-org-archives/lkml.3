Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268Ab3BEJM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 04:12:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8157 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567Ab3BEJMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 04:12:52 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 18/18] ext4: Allow punch hole with bigalloc enabled
Date: Tue,  5 Feb 2013 10:12:11 +0100
Message-Id: <1360055531-26309-19-git-send-email-lczerner@redhat.com>
In-Reply-To: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
References: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commits 5f95d21fb6f2aaa52830e5b7fb405f6c71d3ab85 and
30bc2ec9598a1b156ad75217f2e7d4560efdeeab we've reworked punch_hole
implementation and there is noting holding us back from using punch hole
on file system with bigalloc feature enabled.

This has been tested with fsx and xfstests.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 fs/ext4/inode.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index e7bf594..01cf049 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3530,11 +3530,6 @@ int ext4_punch_hole(struct file *file, loff_t offset, loff_t length)
 		return -EOPNOTSUPP;
 	}
 
-	if (EXT4_SB(inode->i_sb)->s_cluster_ratio > 1) {
-		/* TODO: Add support for bigalloc file systems */
-		return -EOPNOTSUPP;
-	}
-
 	return ext4_ext_punch_hole(file, offset, length);
 }
 
-- 
1.7.7.6

