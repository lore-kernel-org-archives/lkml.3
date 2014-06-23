Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaFWQZo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:25:44 -0400
Received: from mailrelay003.isp.belgacom.be ([195.238.6.53]:38215 "EHLO
	mailrelay003.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754880AbaFWQZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:25:42 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArERALNUqFNbskjJ/2dsb2JhbABZgw2rZQUBAQEBAQEFAZUOhCeBDxd1hDEvI4EaN4hGAcZzhWOITE2ESgSPcopak2ODRDuBMQEDHA
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Fabian Frederick <fabf@skynet.be>, reiserfs-devel@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/1] FS/REISERFS: replace not-standard %Lu/%Ld
Date: Mon, 23 Jun 2014 18:24:08 +0200
Message-Id: <1403540648-10182-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes checkpatch warnings:

"WARNING: %Ld/%Lu are not-standard C, use %lld/%llu"

Cc: reiserfs-devel@vger.kernel.org
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/reiserfs/item_ops.c | 4 ++--
 fs/reiserfs/prints.c   | 4 ++--
 fs/reiserfs/stree.c    | 2 +-
 fs/reiserfs/super.c    | 7 +++----
 4 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/fs/reiserfs/item_ops.c b/fs/reiserfs/item_ops.c
index cfaee91..aca73dd 100644
--- a/fs/reiserfs/item_ops.c
+++ b/fs/reiserfs/item_ops.c
@@ -54,7 +54,7 @@ static void sd_print_item(struct item_head *ih, char *item)
 	} else {
 		struct stat_data *sd = (struct stat_data *)item;
 
-		printk("\t0%-6o | %6Lu | %2u | %d | %s\n", sd_v2_mode(sd),
+		printk("\t0%-6o | %6llu | %2u | %d | %s\n", sd_v2_mode(sd),
 		       (unsigned long long)sd_v2_size(sd), sd_v2_nlink(sd),
 		       sd_v2_rdev(sd), print_time(sd_v2_mtime(sd)));
 	}
@@ -408,7 +408,7 @@ static void direntry_print_item(struct item_head *ih, char *item)
 			namebuf[namelen + 2] = 0;
 		}
 
-		printk("%d:  %-15s%-15d%-15d%-15Ld%-15Ld(%s)\n",
+		printk("%d:  %-15s%-15d%-15d%-15lld%-15lld(%s)\n",
 		       i, namebuf,
 		       deh_dir_id(deh), deh_objectid(deh),
 		       GET_HASH_VALUE(deh_offset(deh)),
diff --git a/fs/reiserfs/prints.c b/fs/reiserfs/prints.c
index c9b47e9..ae1dc84 100644
--- a/fs/reiserfs/prints.c
+++ b/fs/reiserfs/prints.c
@@ -17,7 +17,7 @@ static char off_buf[80];
 static char *reiserfs_cpu_offset(struct cpu_key *key)
 {
 	if (cpu_key_k_type(key) == TYPE_DIRENTRY)
-		sprintf(off_buf, "%Lu(%Lu)",
+		sprintf(off_buf, "%llu(%llu)",
 			(unsigned long long)
 			GET_HASH_VALUE(cpu_key_k_offset(key)),
 			(unsigned long long)
@@ -34,7 +34,7 @@ static char *le_offset(struct reiserfs_key *key)
 
 	version = le_key_version(key);
 	if (le_key_k_type(version, key) == TYPE_DIRENTRY)
-		sprintf(off_buf, "%Lu(%Lu)",
+		sprintf(off_buf, "%llu(%llu)",
 			(unsigned long long)
 			GET_HASH_VALUE(le_key_k_offset(version, key)),
 			(unsigned long long)
diff --git a/fs/reiserfs/stree.c b/fs/reiserfs/stree.c
index dd44468..24cbe01 100644
--- a/fs/reiserfs/stree.c
+++ b/fs/reiserfs/stree.c
@@ -2006,7 +2006,7 @@ int reiserfs_do_truncate(struct reiserfs_transaction_handle *th,
 					    &s_search_path) == POSITION_FOUND);
 
 	RFALSE(file_size > ROUND_UP(new_file_size),
-	       "PAP-5680: truncate did not finish: new_file_size %Ld, current %Ld, oid %d",
+	       "PAP-5680: truncate did not finish: new_file_size %lld, current %lld, oid %d",
 	       new_file_size, file_size, s_item_key.on_disk_key.k_objectid);
 
 update_and_out:
diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index a392cef..debdb8e 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -331,7 +331,7 @@ static int finish_unfinished(struct super_block *s)
 			 * not completed truncate found. New size was
 			 * committed together with "save" link
 			 */
-			reiserfs_info(s, "Truncating %k to %Ld ..",
+			reiserfs_info(s, "Truncating %k to %lld ..",
 				      INODE_PKEY(inode), inode->i_size);
 
 			/* don't update modification time */
@@ -1577,7 +1577,7 @@ static int read_super_block(struct super_block *s, int offset)
 	rs = (struct reiserfs_super_block *)bh->b_data;
 	if (sb_blocksize(rs) != s->s_blocksize) {
 		reiserfs_warning(s, "sh-2011", "can't find a reiserfs "
-				 "filesystem on (dev %s, block %Lu, size %lu)",
+				 "filesystem on (dev %s, block %llu, size %lu)",
 				 s->s_id,
 				 (unsigned long long)bh->b_blocknr,
 				 s->s_blocksize);
@@ -2441,8 +2441,7 @@ static ssize_t reiserfs_quota_write(struct super_block *sb, int type,
 	struct buffer_head tmp_bh, *bh;
 
 	if (!current->journal_info) {
-		printk(KERN_WARNING "reiserfs: Quota write (off=%Lu, len=%Lu)"
-			" cancelled because transaction is not started.\n",
+		printk(KERN_WARNING "reiserfs: Quota write (off=%llu, len=%llu) cancelled because transaction is not started.\n",
 			(unsigned long long)off, (unsigned long long)len);
 		return -EIO;
 	}
-- 
1.8.4.5

