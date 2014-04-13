Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755880AbaDMUvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 16:51:12 -0400
Received: from mailrelay009.isp.belgacom.be ([195.238.6.176]:2558 "EHLO
	mailrelay009.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbaDMUvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 16:51:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmkGAHL4SlNXQ5wQ/2dsb2JhbABZgwbENYEbF3SCUxMcIxiBAiQTiAABymiOboQ/AQOOX4oBAZJDgzM7
Date: Sun, 13 Apr 2014 22:51:07 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, jeffm <jeffm@suse.com>
Subject: [PATCH 1/1] fs/reiserfs/bitmap.c: coding style fixes
Message-Id: <20140413225107.271d3c27845c0862ea4141bc@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-Trivial code clean-up
-Fix endif }; (coccinelle warning)

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/bitmap.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/reiserfs/bitmap.c b/fs/reiserfs/bitmap.c
index dc9a682..1bcffea 100644
--- a/fs/reiserfs/bitmap.c
+++ b/fs/reiserfs/bitmap.c
@@ -142,7 +142,6 @@ static int scan_bitmap_block(struct reiserfs_transaction_handle *th,
 	int org = *beg;
 
 	BUG_ON(!th->t_trans_id);
-
 	RFALSE(bmap_n >= reiserfs_bmap_count(s), "Bitmap %u is out of "
 	       "range (0..%u)", bmap_n, reiserfs_bmap_count(s) - 1);
 	PROC_INFO_INC(s, scan_bitmap.bmap);
@@ -321,7 +320,6 @@ static int scan_bitmap(struct reiserfs_transaction_handle *th,
 	unsigned int off_max = s->s_blocksize << 3;
 
 	BUG_ON(!th->t_trans_id);
-
 	PROC_INFO_INC(s, scan_bitmap.call);
 	if (SB_FREE_BLOCKS(s) <= 0)
 		return 0;	// No point in looking for more free blocks
@@ -388,9 +386,7 @@ static void _reiserfs_free_block(struct reiserfs_transaction_handle *th,
 	unsigned int nr, offset;
 
 	BUG_ON(!th->t_trans_id);
-
 	PROC_INFO_INC(s, free_block);
-
 	rs = SB_DISK_SUPER_BLOCK(s);
 	sbh = SB_BUFFER_WITH_SB(s);
 	apbi = SB_AP_BITMAP(s);
@@ -435,8 +431,8 @@ void reiserfs_free_block(struct reiserfs_transaction_handle *th,
 			 int for_unformatted)
 {
 	struct super_block *s = th->t_super;
-	BUG_ON(!th->t_trans_id);
 
+	BUG_ON(!th->t_trans_id);
 	RFALSE(!s, "vs-4061: trying to free block on nonexistent device");
 	if (!is_reusable(s, block, 1))
 		return;
@@ -471,6 +467,7 @@ static void __discard_prealloc(struct reiserfs_transaction_handle *th,
 	unsigned long save = ei->i_prealloc_block;
 	int dirty = 0;
 	struct inode *inode = &ei->vfs_inode;
+
 	BUG_ON(!th->t_trans_id);
 #ifdef CONFIG_REISERFS_CHECK
 	if (ei->i_prealloc_count < 0)
@@ -494,6 +491,7 @@ void reiserfs_discard_prealloc(struct reiserfs_transaction_handle *th,
 			       struct inode *inode)
 {
 	struct reiserfs_inode_info *ei = REISERFS_I(inode);
+
 	BUG_ON(!th->t_trans_id);
 	if (ei->i_prealloc_count)
 		__discard_prealloc(th, ei);
@@ -504,7 +502,6 @@ void reiserfs_discard_all_prealloc(struct reiserfs_transaction_handle *th)
 	struct list_head *plist = &SB_JOURNAL(th->t_super)->j_prealloc_list;
 
 	BUG_ON(!th->t_trans_id);
-
 	while (!list_empty(plist)) {
 		struct reiserfs_inode_info *ei;
 		ei = list_entry(plist->next, struct reiserfs_inode_info,
@@ -562,7 +559,7 @@ int reiserfs_parse_alloc_options(struct super_block *s, char *options)
 		if (!strcmp(this_char, "displacing_new_packing_localities")) {
 			SET_OPTION(displacing_new_packing_localities);
 			continue;
-		};
+		}
 
 		if (!strcmp(this_char, "old_hashed_relocation")) {
 			SET_OPTION(old_hashed_relocation);
@@ -729,6 +726,7 @@ void show_alloc_options(struct seq_file *seq, struct super_block *s)
 static inline void new_hashed_relocation(reiserfs_blocknr_hint_t * hint)
 {
 	char *hash_in;
+
 	if (hint->formatted_node) {
 		hash_in = (char *)&hint->key.k_dir_id;
 	} else {
@@ -757,6 +755,7 @@ static void dirid_groups(reiserfs_blocknr_hint_t * hint)
 	__u32 dirid = 0;
 	int bm = 0;
 	struct super_block *sb = hint->th->t_super;
+
 	if (hint->inode)
 		dirid = le32_to_cpu(INODE_PKEY(hint->inode)->k_dir_id);
 	else if (hint->formatted_node)
-- 
1.8.3.2

