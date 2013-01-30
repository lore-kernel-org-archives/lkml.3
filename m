Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3A3Nr0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 08:47:26 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:47746 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3A3NrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 08:47:24 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/3] f2fs: reorganize code for ra_node_page
Date: Wed, 30 Jan 2013 22:47:16 +0900
Message-Id: <1359553636-7483-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

We can remove unneeded label unlock_out, avoid unnecessary jump
and reorganize the returning conditions in this function.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/node.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 9bda63c..f71dfbb 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -874,15 +874,11 @@ void ra_node_page(struct f2fs_sb_info *sbi, nid_t nid)
 		return;
 
 	if (read_node_page(apage, READA))
-		goto unlock_out;
+		unlock_page(apage);
 
-	page_cache_release(apage);
-	return;
-
-unlock_out:
-	unlock_page(apage);
 release_out:
 	page_cache_release(apage);
+	return;
 }
 
 struct page *get_node_page(struct f2fs_sb_info *sbi, pgoff_t nid)
-- 
1.7.9.5

