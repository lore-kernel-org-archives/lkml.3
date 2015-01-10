Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbbAJSNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 13:13:43 -0500
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:48369 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201AbbAJSNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 13:13:42 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgsNAHxrsVRbtAnC/2dsb2JhbABbgwaBKrM4BQEBAQEBAQUBd5c6gQpEAQEBAQF9hDovI4EaN4gwAbwZjTUshgWJdB2EEwWXR4l+h3kigUUBgik9MYJDAQEB
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Jan Kara <jack@suse.cz>
Subject: [PATCH 1/1 linux-next] udf: destroy sbi mutex in put_super
Date: Sat, 10 Jan 2015 19:13:32 +0100
Message-Id: <1420913612-8844-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Call mutex_destroy() on superblock mutex in udf_put_super()
otherwise mutex debugging code isn't able to detect that
mutex is used after being freed.
(thanks to Jan Kara for complete definition).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/udf/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 3ccb2f1..3d35a75 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -2300,6 +2300,7 @@ static void udf_put_super(struct super_block *sb)
 		udf_close_lvid(sb);
 	brelse(sbi->s_lvid_bh);
 	udf_sb_free_partitions(sb);
+	mutex_destroy(&sbi->s_alloc_mutex);
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 }
-- 
2.1.0

