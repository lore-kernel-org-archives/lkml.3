Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab3HDOKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 10:10:36 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49005 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058Ab3HDOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 10:10:35 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Pankaj Kumar <pankaj.km@samsung.com>
Subject: [PATCH 3/3] f2fs: remove redundant code from f2fs_write_begin
Date: Sun,  4 Aug 2013 23:10:28 +0900
Message-Id: <1375625428-2869-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This code is being used for nobh_write_end() function.
But since now f2fs_write_end function is added so
there is no need for this code.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Pankaj Kumar <pankaj.km@samsung.com>
---
 fs/f2fs/data.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 19cd7c6..ae1558e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -635,9 +635,6 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 	int err = 0;
 	int ilock;
 
-	/* for nobh_write_end */
-	*fsdata = NULL;
-
 	f2fs_balance_fs(sbi);
 repeat:
 	page = grab_cache_page_write_begin(mapping, index, flags);
-- 
1.7.9.5

