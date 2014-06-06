Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaFFRfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:35:07 -0400
Received: from mout.web.de ([212.227.17.11]:55730 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403AbaFFRfD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:35:03 -0400
From: Ken Helias <kenhelias@web.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ken Helias <kenhelias@firemail.de>,
        jfs-discussion@lists.sourceforge.net
Subject: [PATCH 09/13] jfs: Use list_add_(before|after) macros
Date: Fri,  6 Jun 2014 19:34:28 +0200
Message-Id: <1402076072-4044-9-git-send-email-kenhelias@web.de>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402076072-4044-1-git-send-email-kenhelias@web.de>
References: <1402076072-4044-1-git-send-email-kenhelias@web.de>
X-Provags-ID: V03:K0:0iMHNJA4wCwhHyC9VZARaGJNxupu5CzMGEjAn7zkinureY7qHpi
 orredQJkWUVTibf8ndmQ0oRnDEi2f+TWcGy0xr6X+qYfI0xlDdm45jClUKcT+TQMdF7AKXb
 WXK4MCNV+1OT0lxnKHfVYvJUkJu8/p4RuOGFTqvVQrjyp6+9wFSJznkkuiRfkaFmTvqdtft
 mRu3TxrscUhmDKKIQ5nAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ken Helias <kenhelias@firemail.de>

Many places in the code uses list_add_tail/list_add to insert an entry
before/after another entry. This confuses the reader because these are usually
used to add an item to a list_head and not an entry. Better use the self
explaining function name.

Signed-off-by: Ken Helias <kenhelias@firemail.de>
Cc: jfs-discussion@lists.sourceforge.net
---
 fs/jfs/jfs_dmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 2d514c7..d08c6d6 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -560,7 +560,7 @@ dbUpdatePMap(struct inode *ipbmap,
 
 			/* insert bp after tblock in logsync list */
 			log->count++;
-			list_add(&mp->synclist, &tblk->synclist);
+			list_add_after(&mp->synclist, &tblk->synclist);
 
 			mp->clsn = tblk->clsn;
 		}
-- 
2.0.0

