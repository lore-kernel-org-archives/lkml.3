Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbaGXJqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:46:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758346AbaGXJqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:46:45 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Liu Bo <bo.li.liu@oracle.com>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/128] Btrfs: use right type to get real comparison
Date: Thu, 24 Jul 2014 10:44:21 +0100
Message-Id: <1406195177-8656-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Bo <bo.li.liu@oracle.com>

commit cd857dd6bc2ae9ecea14e75a34e8a8fdc158e307 upstream.

We want to make sure the point is still within the extent item, not to verify
the memory it's pointing to.

Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
Signed-off-by: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 8bc5e8ccb091..2b3d7ba4ad33 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -1388,7 +1388,7 @@ static int __get_extent_inline_ref(unsigned long *ptr, struct extent_buffer *eb,
 			*out_eiref = (struct btrfs_extent_inline_ref *)(ei + 1);
 		}
 		*ptr = (unsigned long)*out_eiref;
-		if ((void *)*ptr >= (void *)ei + item_size)
+		if ((unsigned long)(*ptr) >= (unsigned long)ei + item_size)
 			return -ENOENT;
 	}
 
-- 
1.9.1

