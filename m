Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaI2SAE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 14:00:04 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:56627 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750968AbaI2SAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 14:00:02 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoNAHidKVRbtA8r/2dsb2JhbABggw6BKrYYBQFyAZpWgRUXAXuEMS8jgRo3iEIBr3aPboYSigwdhDUFkT2La5Vdg2U7L4JKAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] fs/affs/inode.c: remove unused variable
Date: Mon, 29 Sep 2014 19:59:45 +0200
Message-Id: <1412013585-14593-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

head is set to AFFS_HEAD(bh) but never used.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/inode.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/affs/inode.c b/fs/affs/inode.c
index bec2d1a..930aac3 100644
--- a/fs/affs/inode.c
+++ b/fs/affs/inode.c
@@ -20,7 +20,6 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 {
 	struct affs_sb_info	*sbi = AFFS_SB(sb);
 	struct buffer_head	*bh;
-	struct affs_head	*head;
 	struct affs_tail	*tail;
 	struct inode		*inode;
 	u32			 block;
@@ -49,7 +48,6 @@ struct inode *affs_iget(struct super_block *sb, unsigned long ino)
 		goto bad_inode;
 	}
 
-	head = AFFS_HEAD(bh);
 	tail = AFFS_TAIL(sb, bh);
 	prot = be32_to_cpu(tail->protect);
 
-- 
1.9.3

