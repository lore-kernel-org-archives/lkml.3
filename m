Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaICFDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 01:03:22 -0400
Received: from mail.kernel.org ([198.145.19.201]:37831 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbaICFCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 01:02:45 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6/6] f2fs: need fsck.f2fs if the recovery was failed
Date: Tue,  2 Sep 2014 22:02:34 -0700
Message-Id: <1409720554-72925-6-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 1.8.5.2 (Apple Git-48)
In-Reply-To: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
References: <1409720554-72925-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the roll-forward recovery was failed, we'd better conduct fsck.f2fs.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index a692304..3275e73 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1083,6 +1083,9 @@ try_onemore:
 	if (err)
 		goto free_proc;
 
+	if (!retry)
+		sbi->need_fsck = true;
+
 	/* recover fsynced data */
 	if (!test_opt(sbi, DISABLE_ROLL_FORWARD)) {
 		err = recover_fsync_data(sbi);
-- 
1.8.5.2 (Apple Git-48)

