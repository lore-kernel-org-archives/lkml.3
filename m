Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362AbaL0PB7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2014 10:01:59 -0500
Received: from mailrelay012.isp.belgacom.be ([195.238.6.179]:9798 "EHLO
	mailrelay012.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751079AbaL0PB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2014 10:01:57 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjAVAITJnlRbsnvc/2dsb2JhbABbgwaBKrQbBQEBAQEBAQUBd5cwBAKBCBcBAQEBAX2EOi8jgRo3iDABuhWPS4YDiXQdhBMFlwiJZ4dpIoFFAYIpPTGCQwEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [PATCH 1/1 linux-next] ext3: destroy sbi mutexes in put_super
Date: Sat, 27 Dec 2014 16:01:22 +0100
Message-Id: <1419692482-17658-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
This is untested.

 fs/ext3/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 9b4e7d7..d4dbf3c 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -466,6 +466,8 @@ static void ext3_put_super (struct super_block * sb)
 	}
 	sb->s_fs_info = NULL;
 	kfree(sbi->s_blockgroup_lock);
+	mutex_destroy(&sbi->s_orphan_lock);
+	mutex_destroy(&sbi->s_resize_lock);
 	kfree(sbi);
 }
 
-- 
2.1.0

