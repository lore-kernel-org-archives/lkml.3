Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab3EIJVx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:21:53 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:60392 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946Ab3EIJVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:21:51 -0400
From: Denis Efremov <yefremov.denis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Denis Efremov <yefremov.denis@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH 10/21] mm: filemap: remove inline marking of EXPORT_SYMBOL functions
Date: Thu,  9 May 2013 13:19:41 +0400
Message-Id: <1368091192-10245-5-git-send-email-yefremov.denis@gmail.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
References: <1368086241-9357-1-git-send-email-yefremov.denis@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

EXPORT_SYMBOL and inline directives are contradictory to each other.
The patch fixes this inconsistency.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Denis Efremov <yefremov.denis@gmail.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 7905fe7..6aca7a2 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2092,7 +2092,7 @@ EXPORT_SYMBOL(iov_iter_single_seg_count);
  * Returns appropriate error code that caller should return or
  * zero in case that write should be allowed.
  */
-inline int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk)
+int generic_write_checks(struct file *file, loff_t *pos, size_t *count, int isblk)
 {
 	struct inode *inode = file->f_mapping->host;
 	unsigned long limit = rlimit(RLIMIT_FSIZE);
-- 
1.8.1.4

