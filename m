Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404AbbAWMiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:38:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48765 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbbAWMiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:38:50 -0500
X-AuditID: cbfee61a-f79c06d000004e71-05-54c240d8662b
From: Chao Yu <chao2.yu@samsung.com>
To: Jaegeuk Kim <jaegeuk@kernel.org>, Changman Lee <cm224.lee@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [f2fs-dev][PATCH] f2fs: use f2fs_radix_tree_insert to clean codes
Date: Fri, 23 Jan 2015 20:37:53 +0800
Message-id: <000701d03709$8916a3a0$9b43eae0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AdA3BQoKQNcSHFRcTiOAej1h1GZCCg==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPLMWRmVeSWpSXmKPExsVy+t9jAd2bDodCDL5OYrS4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxq61vAX9
	bBWzllo2MPawdjFyckgImEi8mvWIBcIWk7hwbz1bFyMXh5DAIkaJ9z2zoJwfjBI3Vm5jA6li
	E1CRWN7xnwnEFhHwkpi0/wRYN7OAh0Rjx3egqRwcwkDxzve5IGEWAVWJBR+usIGEeQUsJfY0
	uYKEeQUEJX5MvgfVqSWxfudxJghbXmLzmrfMEPcoSOw4+5oRYpOexLJtyxghasQlNh65xTKB
	UWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEB/MzqR2MKxss
	DjEKcDAq8fA2bDkYIsSaWFZcmXuIUYKDWUmE11rzUIgQb0piZVVqUX58UWlOavEhRmkOFiVx
	XiX7thAhgfTEktTs1NSC1CKYLBMHp1QD48REgRgWqxtrbKszszo+d/fNP/1H+fdnzx2vnkpc
	tfn94+yDBw+Cdb9u9o0vOLJrc83l+CdvP1uY/diofcS3tXVl0oGi05cvcShGf6uvKvk6s6c0
	XeV8Q7xD2oKi4xpswqXOmwu+zPVpCS55rMCvW7JscaDaXZnK5steF/7Es0m5zr34r0aqQ4ml
	OCPRUIu5qDgRAChFXDBiAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No modification in functionality, just clean codes with f2fs_radix_tree_insert.

Signed-off-by: Chao Yu <chao2.yu@samsung.com>
---
 fs/f2fs/gc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 40887d3..180b161 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -356,11 +356,9 @@ static void add_gc_inode(struct gc_inode_list *gc_list, struct inode *inode)
 	}
 	new_ie = f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
 	new_ie->inode = inode;
-retry:
-	if (radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie)) {
-		cond_resched();
-		goto retry;
-	}
+
+	f2fs_radix_tree_insert(&gc_list->iroot, inode->i_ino, new_ie);
+
 	list_add_tail(&new_ie->list, &gc_list->ilist);
 }
 
-- 
2.2.1


