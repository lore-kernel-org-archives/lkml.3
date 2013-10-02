Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698Ab3JBOcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:32:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49024 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab3JBO27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:28:59 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-mm@kvack.org, Jan Kara <jack@suse.cz>,
        Greg Kroah-Hartman <greg@kroah.com>, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>, hpdd-discuss@ml01.01.org
Subject: [PATCH 10/26] lustre: Convert ll_get_user_pages() to use get_user_pages_fast()
Date: Wed,  2 Oct 2013 16:27:51 +0200
Message-Id: <1380724087-13927-11-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1380724087-13927-1-git-send-email-jack@suse.cz>
References: <1380724087-13927-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Greg Kroah-Hartman <greg@kroah.com>
CC: Peng Tao <tao.peng@emc.com>
CC: Andreas Dilger <andreas.dilger@intel.com>
CC: hpdd-discuss@lists.01.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 drivers/staging/lustre/lustre/llite/rw26.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/rw26.c b/drivers/staging/lustre/lustre/llite/rw26.c
index 96c29ad2fc8c..7e3e0967993b 100644
--- a/drivers/staging/lustre/lustre/llite/rw26.c
+++ b/drivers/staging/lustre/lustre/llite/rw26.c
@@ -202,11 +202,8 @@ static inline int ll_get_user_pages(int rw, unsigned long user_addr,
 
 	OBD_ALLOC_LARGE(*pages, *max_pages * sizeof(**pages));
 	if (*pages) {
-		down_read(&current->mm->mmap_sem);
-		result = get_user_pages(current, current->mm, user_addr,
-					*max_pages, (rw == READ), 0, *pages,
-					NULL);
-		up_read(&current->mm->mmap_sem);
+		result = get_user_pages_fast(user_addr, *max_pages,
+					     (rw == READ), *pages);
 		if (unlikely(result <= 0))
 			OBD_FREE_LARGE(*pages, *max_pages * sizeof(**pages));
 	}
-- 
1.8.1.4

