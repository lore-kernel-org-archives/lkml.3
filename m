Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbbALS6i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:58:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58065 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbbALS37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:29:59 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jiri Slaby <jslaby@suse.cz>, Jan Kara <jack@suse.cz>,
        reiserfs-devel@vger.kernel.org,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 136/216] reiserfs: destroy allocated commit workqueue
Date: Mon, 12 Jan 2015 18:28:34 +0000
Message-Id: <1421087394-2712-24-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit fa0c5540739320258c3e3a45aaae9dae467b2504 upstream.

When resirefs is trying to mount a partition, it creates a commit
workqueue (sbi->commit_wq). But when mount fails later, the workqueue
is not freed.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: auxsvr@gmail.com
Reported-by: Benoît Monin <benoit.monin@gmx.fr>
Cc: Jan Kara <jack@suse.cz>
Cc: reiserfs-devel@vger.kernel.org
Fixes: 797d9016ceca69879bb273218810fa0beef46aac
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/reiserfs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index 5fd8f57e07fc..27575041bea3 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -2161,6 +2161,9 @@ error_unlocked:
 		reiserfs_write_unlock(s);
 	}
 
+	if (sbi->commit_wq)
+		destroy_workqueue(sbi->commit_wq);
+
 	cancel_delayed_work_sync(&REISERFS_SB(s)->old_work);
 
 	reiserfs_free_bitmap_cache(s);
-- 
2.1.4

