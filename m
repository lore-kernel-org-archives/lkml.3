Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3CBDlA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:41:00 -0500
Received: from mail-da0-f49.google.com ([209.85.210.49]:33868 "EHLO
	mail-da0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3CBDk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:40:58 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 2/5] f2fs: optimize and change return path in lookup_free_nid_list
Date: Sat,  2 Mar 2013 12:40:50 +0900
Message-Id: <1362195650-20717-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Optimize and change return path in lookup_free_nid_list

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/node.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index e275218..e24f747 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1195,14 +1195,13 @@ const struct address_space_operations f2fs_node_aops = {
 static struct free_nid *__lookup_free_nid_list(nid_t n, struct list_head *head)
 {
 	struct list_head *this;
-	struct free_nid *i = NULL;
+	struct free_nid *i;
 	list_for_each(this, head) {
 		i = list_entry(this, struct free_nid, list);
 		if (i->nid == n)
-			break;
-		i = NULL;
+			return i;
 	}
-	return i;
+	return NULL;
 }
 
 static void __del_from_free_nid_list(struct free_nid *i)
-- 
1.7.9.5

