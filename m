Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbaF3MaT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:30:19 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750815AbaF3MaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:30:17 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Liu Bo <bo.li.liu@oracle.com>,
        Chris Mason <clm@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 172/181] Btrfs: use right type to get real comparison
Date: Mon, 30 Jun 2014 13:53:13 +0200
Message-Id: <1831e484b78eab0467b0b27be9634a3323273549.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Bo <bo.li.liu@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit cd857dd6bc2ae9ecea14e75a34e8a8fdc158e307 upstream.

We want to make sure the point is still within the extent item, not to verify
the memory it's pointing to.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 5eb50b5df777..79559682255a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1409,7 +1409,7 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 			*out_eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
 		}
 		*ptr = (unsigned long)*out_eiref;
-		if ((void *)*ptr >= (void *)ei + item_size)
+		if ((unsigned long)(*ptr) >= (unsigned long)ei + item_size)
 			return -ENOENT;
 	}
 
-- 
2.0.0

