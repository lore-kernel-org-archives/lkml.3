Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121AbaGVWZi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:25:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44656 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778AbaGVWZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:25:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Maurizio Lombardi <mlombard@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 033/116] ext4: fix wrong assert in ext4_mb_normalize_request()
Date: Tue, 22 Jul 2014 15:20:44 -0700
Message-Id: <1406067727-19683-34-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

commit b5b60778558cafad17bbcbf63e0310bd3c68eb17 upstream.

The variable "size" is expressed as number of blocks and not as
number of clusters, this could trigger a kernel panic when using
ext4 with the size of a cluster different from the size of a block.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ext4/mballoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 2167e90..a72f1c0 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -3030,7 +3030,7 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
 	}
 	BUG_ON(start + size <= ac->ac_o_ex.fe_logical &&
 			start > ac->ac_o_ex.fe_logical);
-	BUG_ON(size <= 0 || size > EXT4_CLUSTERS_PER_GROUP(ac->ac_sb));
+	BUG_ON(size <= 0 || size > EXT4_BLOCKS_PER_GROUP(ac->ac_sb));
 
 	/* now prepare goal request */
 
-- 
1.9.1

