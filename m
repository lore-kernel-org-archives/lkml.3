Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261AbbAHSLJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 13:11:09 -0500
Received: from mail.kernel.org ([198.145.29.136]:58407 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbbAHSLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 13:11:08 -0500
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 1/6] f2fs: fix wrong unlock_page call
Date: Thu,  8 Jan 2015 10:10:56 -0800
Message-Id: <1420740661-72288-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes wrongly called unlock_page.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/data.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b48b355..a7b905c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -837,7 +837,6 @@ write:
 	/* we should bypass data pages to proceed the kworkder jobs */
 	if (unlikely(f2fs_cp_error(sbi))) {
 		SetPageError(page);
-		unlock_page(page);
 		goto out;
 	}
 
-- 
2.1.1

