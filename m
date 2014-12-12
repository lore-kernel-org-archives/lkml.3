Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030666AbaLLP3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:29:34 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:35947 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933272AbaLLP3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:29:32 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jan Kara <jack@suse.cz>, All Versions <stable@vger.kernel.org>
Subject: [PATCH 1/1] reiserfs: destroy allocated commit workqueue
Date: Fri, 12 Dec 2014 16:29:29 +0100
Message-Id: <1418398169-19820-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When resirefs is trying to mount a partition, it creates a commit
workqueue (sbi->commit_wq). But when mount fails later, the workqueue
is not freed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: auxsvr@gmail.com
Reported-by: Benoît Monin <benoit.monin@gmx.fr>
Cc: Jan Kara <jack@suse.cz>
Cc: All Versions <stable@vger.kernel.org>
Cc: reiserfs-devel@vger.kernel.org
---
 fs/reiserfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index ea63ab13ef92..71fbbe3e2dab 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2172,6 +2172,9 @@ error_unlocked:
 		reiserfs_write_unlock(s);
 	}
 
+	if (sbi->commit_wq)
+		destroy_workqueue(sbi->commit_wq);
+
 	cancel_delayed_work_sync(&REISERFS_SB(s)->old_work);
 
 	reiserfs_free_bitmap_cache(s);
-- 
2.2.0

