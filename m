Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaFPR4v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 13:56:51 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:21798 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195AbaFPR4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 13:56:50 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlUHAHASn1NbtAal/2dsb2JhbABagw2rFgUBAQEBAQEFAZkkgREXdYQxLyOBGjeIRgHPKheFY4kTHYQtBJpDk1iDQjs
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH 1/1] fs/btrfs/free-space-cache.c: remove null test before kfree
Date: Mon, 16 Jun 2014 19:55:31 +0200
Message-Id: <1402941331-3067-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix checkpatch warning:
WARNING: kfree(NULL) is safe this check is probably not required

Cc: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/btrfs/free-space-cache.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/free-space-cache.c b/fs/btrfs/free-space-cache.c
index 372b05f..c8211ae 100644
--- a/fs/btrfs/free-space-cache.c
+++ b/fs/btrfs/free-space-cache.c
@@ -1884,8 +1884,7 @@ new_bitmap:
 
 out:
 	if (info) {
-		if (info->bitmap)
-			kfree(info->bitmap);
+		kfree(info->bitmap);
 		kmem_cache_free(btrfs_free_space_cachep, info);
 	}
 
@@ -3126,8 +3125,7 @@ again:
 	if (bytes)
 		goto again;
 
-	if (map)
-		kfree(map);
+	kfree(map);
 	return 0;
 }
 
-- 
1.8.4.5

