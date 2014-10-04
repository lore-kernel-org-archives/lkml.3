Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaJDHFS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 03:05:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:60855 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939AbaJDHFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 03:05:16 -0400
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH] f2fs: remove unused return vale
Date: Sat,  4 Oct 2014 00:05:20 -0700
Message-Id: <1412406320-48178-1-git-send-email-jaegeuk@kernel.org>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't return any value without any usage.

Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/node.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
index bd826d9..8d5e6e0 100644
--- a/fs/f2fs/node.h
+++ b/fs/f2fs/node.h
@@ -130,7 +130,7 @@ struct free_nid {
 	int state;		/* in use or not: NID_NEW or NID_ALLOC */
 };
 
-static inline int next_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
+static inline void next_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 {
 	struct f2fs_nm_info *nm_i = NM_I(sbi);
 	struct free_nid *fnid;
@@ -138,12 +138,11 @@ static inline int next_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 	spin_lock(&nm_i->free_nid_list_lock);
 	if (nm_i->fcnt <= 0) {
 		spin_unlock(&nm_i->free_nid_list_lock);
-		return -1;
+		return;
 	}
 	fnid = list_entry(nm_i->free_nid_list.next, struct free_nid, list);
 	*nid = fnid->nid;
 	spin_unlock(&nm_i->free_nid_list_lock);
-	return 0;
 }
 
 /*
-- 
2.1.1

