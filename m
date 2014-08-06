Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158AbaHFEoV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:44:21 -0400
Received: from s87.loopia.se ([194.9.94.112]:34435 "EHLO s87.loopia.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751792AbaHFEoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:44:17 -0400
X-Spam-Flag: NO
X-Spam-Score: -1
From: Hans Wennborg <hans@hanshq.net>
To: bharrosh@panasas.com, osd-dev@open-osd.org, linux-kernel@vger.kernel.org
Cc: Hans Wennborg <hans@hanshq.net>
Subject: [PATCH 13/15] exofs: fix decimal printf format specifiers prefixed with 0x
Date: Tue,  5 Aug 2014 21:44:06 -0700
Message-Id: <1407300246-454-1-git-send-email-hans@hanshq.net>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prefix suggests the number should be printed in hex, so use
the %x specifier to do that.

Found by using regex suggested by Joe Perches.

Signed-off-by: Hans Wennborg <hans@hanshq.net>
---
 fs/exofs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index 49f51ab..54ab575 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -143,7 +143,7 @@ Espan:
 bad_entry:
 	EXOFS_ERR(
 		"ERROR [exofs_check_page]: bad entry in directory(0x%lx): %s - "
-		"offset=%lu, inode=0x%llu, rec_len=%d, name_len=%d\n",
+		"offset=%lu, inode=0x%llx, rec_len=%d, name_len=%d\n",
 		dir->i_ino, error, (page->index<<PAGE_CACHE_SHIFT)+offs,
 		_LLU(le64_to_cpu(p->inode_no)),
 		rec_len, p->name_len);
-- 
2.0.0.526.g5318336

