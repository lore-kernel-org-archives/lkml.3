Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbaG2PUF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:20:05 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57251 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754070AbaG2PT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:19:58 -0400
X-IronPort-AV: E=Sophos;i="5.01,757,1400018400"; 
   d="scan'208";a="87459216"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: reiserfs-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-ia64@vger.kernel.org,
        ceph-devel@vger.kernel.org, toralf.foerster@gmx.de, hmh@hmh.eng.br,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] reiserfs: use correct structure type name in sizeof
Date: Tue, 29 Jul 2014 17:16:46 +0200
Message-Id: <1406647011-8543-5-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Correct typo in the name of the type given to sizeof.  Because it is the
size of a pointer that is wanted, the typo has no impact on compilation or
execution.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
semantic patch used can be found in message 0 of this patch series.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 fs/reiserfs/resize.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/reiserfs/resize.c b/fs/reiserfs/resize.c
index 6052d32..e69051b 100644
--- a/fs/reiserfs/resize.c
+++ b/fs/reiserfs/resize.c
@@ -99,7 +99,7 @@ int reiserfs_resize(struct super_block *s, unsigned long block_count_new)
 		 */
 		copy_size = bmap_nr_new < bmap_nr ? bmap_nr_new : bmap_nr;
 		copy_size =
-		    copy_size * sizeof(struct reiserfs_list_bitmap_node *);
+		    copy_size * sizeof(struct reiserfs_bitmap_node *);
 		for (i = 0; i < JOURNAL_NUM_BITMAPS; i++) {
 			struct reiserfs_bitmap_node **node_tmp;
 			jb = SB_JOURNAL(s)->j_list_bitmap + i;

