Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbbAMSfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 13:35:23 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:37236 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752330AbbAMSfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 13:35:20 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: An8RAPxjtVRbtBuH/2dsb2JhbABbgwaBKrM+BQEBAQEBAQUBd5c3BAKBG0QBAQEBAX2EOi8jgRo3iDABwXiOO4YFiXQdhBMFjiGJLol/h30igUUBgik9MYJDAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1 linux-next] fs/affs/super.c: destroy sbi mutex in affs_kill_sb()
Date: Tue, 13 Jan 2015 19:35:10 +0100
Message-Id: <1421174110-14397-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call mutex_destroy() on superblock mutex in affs_kill_sb()
otherwise mutex debugging code isn't able to detect that mutex
is used after being freed. (thanks to Jan Kara for complete definition).

Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/affs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/affs/super.c b/fs/affs/super.c
index f754ab6..ee8eca7 100644
--- a/fs/affs/super.c
+++ b/fs/affs/super.c
@@ -602,6 +602,7 @@ static void affs_kill_sb(struct super_block *sb)
 		affs_free_bitmap(sb);
 		affs_brelse(sbi->s_root_bh);
 		kfree(sbi->s_prefix);
+		mutex_destroy(&sbi->s_bmlock);
 		kfree(sbi);
 	}
 }
-- 
2.1.0

