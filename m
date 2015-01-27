Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbbA0XcD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 18:32:03 -0500
Received: from mail.kernel.org ([198.145.29.136]:53614 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbbA0Xb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 18:31:59 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 3/5] f2fs: avoid write_checkpoint if f2fs is mounted readonly
Date: Tue, 27 Jan 2015 15:31:41 -0800
Message-Id: <1422401503-4769-3-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
References: <1422401503-4769-1-git-send-email-jaegeuk@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not change any partition when f2fs is changed to readonly mode.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/checkpoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 79f8281..1ee6162 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1067,6 +1067,8 @@ void write_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		goto out;
 	if (unlikely(f2fs_cp_error(sbi)))
 		goto out;
+	if (f2fs_readonly(sbi->sb))
+		goto out;
 	if (block_operations(sbi))
 		goto out;
 
-- 
2.1.1

