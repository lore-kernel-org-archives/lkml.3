Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880Ab3D1AEo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 20:04:44 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:35998 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab3D1AEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 20:04:42 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 2/2] f2fs: wait for page writeback to provide stable pages
Date: Sun, 28 Apr 2013 09:04:33 +0900
Message-Id: <1367107474-2476-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

When stable pages are required, we have to wait if the page is just
going to disk and we want to modify it.  Add proper callback to
f2fs_vm_page_mkwrite.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/f2fs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index dc76f9b..0cb83a0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -90,7 +90,7 @@ static int f2fs_vm_page_mkwrite(struct vm_area_struct *vma,
 
 mapped:
 	/* fill the page */
-	wait_on_page_writeback(page);
+	wait_for_stable_page(page);
 out:
 	sb_end_pagefault(inode->i_sb);
 	return block_page_mkwrite_return(err);
-- 
1.7.9.5

