Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757929Ab3BBOx0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:53:26 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46837 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab3BBOxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:53:24 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: jaegeuk.kim@samsung.com
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 6/6] f2fs: optimize the return condition for has_not_enough_free_secs
Date: Sat,  2 Feb 2013 23:53:15 +0900
Message-Id: <1359816795-16424-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Instead of evaluating the free_sections and then deciding to return
true/false from that path. We can directly use the evaluation condition
for returning proper value.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/f2fs/segment.h |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index a9417b9..458bf5c 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -464,10 +464,8 @@ static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi)
 	if (sbi->por_doing)
 		return false;
 
-	if (free_sections(sbi) <= (node_secs + 2 * dent_secs +
-						reserved_sections(sbi)))
-		return true;
-	return false;
+	return (free_sections(sbi) <= (node_secs + 2 * dent_secs +
+						reserved_sections(sbi)));
 }
 
 static inline int utilization(struct f2fs_sb_info *sbi)
-- 
1.7.9.5

