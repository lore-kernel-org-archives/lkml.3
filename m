Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751724AbaHDI0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 04:26:46 -0400
Received: from mailrelay006.isp.belgacom.be ([195.238.6.172]:54594 "EHLO
	mailrelay006.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaHDI0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 04:26:45 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ar8IALdC31NXQ62T/2dsb2JhbABbgw2BKa5XBgEBAQEBBQFuAaQZgRcXd4RgI4EaN4hGAbNXkH6FfIlQHYQ1BZwGi3uIZINPOy8
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ext4: fix comment in evict_inode()
Date: Mon,  4 Aug 2014 10:26:26 +0200
Message-Id: <1407140787-3742-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 91b0abe36a7b
("mm + fs: store shadow entries in page cache")

replaced truncate_inode_pages by truncate_inode_pages_final

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/ext4/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 367a60c..16d429f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -197,8 +197,8 @@ void ext4_evict_inode(struct inode *inode)
 		 * ready for reaping the inode might still have some pages to
 		 * write in the running transaction or waiting to be
 		 * checkpointed. Thus calling jbd2_journal_invalidatepage()
-		 * (via truncate_inode_pages()) to discard these buffers can
-		 * cause data loss. Also even if we did not discard these
+		 * (via truncate_inode_pages_final()) to discard these buffers
+		 * can cause data loss. Also even if we did not discard these
 		 * buffers, we would have no way to find them after the inode
 		 * is reaped and thus user could see stale data if he tries to
 		 * read them before the transaction is checkpointed. So be
-- 
1.9.1

