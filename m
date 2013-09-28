Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab3I1Xgo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 19:36:44 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:43909 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755297Ab3I1Xgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 19:36:40 -0400
From: "Geyslan G. Bem" <geyslan@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net
Cc: v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Geyslan G. Bem" <geyslan@gmail.com>
Subject: [PATCH] 9p: remove unused 'p9_client' struct pointer
Date: Sat, 28 Sep 2013 20:32:14 -0300
Message-Id: <1380411144-9236-2-git-send-email-geyslan@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
References: <1380411144-9236-1-git-send-email-geyslan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of the useless '*clnt' variable.

Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
---
 fs/9p/vfs_file.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/9p/vfs_file.c b/fs/9p/vfs_file.c
index aa5ecf4..42b7286 100644
--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -463,14 +463,12 @@ v9fs_file_write_internal(struct inode *inode, struct p9_fid *fid,
 	int n;
 	loff_t i_size;
 	size_t total = 0;
-	struct p9_client *clnt;
 	loff_t origin = *offset;
 	unsigned long pg_start, pg_end;
 
 	p9_debug(P9_DEBUG_VFS, "data %p count %d offset %x\n",
 		 data, (int)count, (int)*offset);
 
-	clnt = fid->clnt;
 	do {
 		n = p9_client_write(fid, NULL, data+total, origin+total, count);
 		if (n <= 0)
-- 
1.8.4

