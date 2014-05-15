Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbaEORUG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:20:06 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:13046 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752530AbaEORUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:20:04 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooRAMT2dFNXQwiB/2dsb2JhbABZFoJwT4JvqFoEAQEBAQEBBQGaGQICgREXdIJTExwjGIECJBOIRQEI0SOFVIcBgXmERwSPKoomAYE9iVCIB4M4OzAB
Date: Thu, 15 May 2014 19:19:59 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Subject: [PATCH 2/3] FS/HPFS: use pr_fmt for logging
Message-Id: <20140515191959.d0677effa35a2895bf07ea21@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also remove redundant level names (warning:...)

Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/hpfs/buffer.c  | 12 ++++++------
 fs/hpfs/dir.c     |  2 +-
 fs/hpfs/dnode.c   | 28 ++++++++++++++--------------
 fs/hpfs/ea.c      |  6 +++---
 fs/hpfs/hpfs_fn.h |  5 +++++
 fs/hpfs/inode.c   |  2 +-
 fs/hpfs/map.c     | 14 +++++++-------
 fs/hpfs/name.c    |  6 +++---
 fs/hpfs/namei.c   |  2 +-
 fs/hpfs/super.c   | 30 +++++++++++++++---------------
 10 files changed, 56 insertions(+), 51 deletions(-)

diff --git a/fs/hpfs/buffer.c b/fs/hpfs/buffer.c
index 4b61be3..e5f62d4 100644
--- a/fs/hpfs/buffer.c
+++ b/fs/hpfs/buffer.c
@@ -55,7 +55,7 @@ void *hpfs_map_sector(struct super_block *s, unsigned secno, struct buffer_head
 	if (bh != NULL)
 		return bh->b_data;
 	else {
-		pr_warn("HPFS: hpfs_map_sector: read error\n");
+		pr_warn("hpfs_map_sector: read error\n");
 		return NULL;
 	}
 }
@@ -76,7 +76,7 @@ void *hpfs_get_sector(struct super_block *s, unsigned secno, struct buffer_head
 		set_buffer_uptodate(bh);
 		return bh->b_data;
 	} else {
-		pr_warn("HPFS: hpfs_get_sector: getblk failed\n");
+		pr_warn("hpfs_get_sector: getblk failed\n");
 		return NULL;
 	}
 }
@@ -93,7 +93,7 @@ void *hpfs_map_4sectors(struct super_block *s, unsigned secno, struct quad_buffe
 	cond_resched();
 
 	if (secno & 3) {
-		pr_warn("HPFS: hpfs_map_4sectors: unaligned read\n");
+		pr_warn("hpfs_map_4sectors: unaligned read\n");
 		return NULL;
 	}
 
@@ -112,7 +112,7 @@ void *hpfs_map_4sectors(struct super_block *s, unsigned secno, struct quad_buffe
 
 	qbh->data = data = kmalloc(2048, GFP_NOFS);
 	if (!data) {
-		pr_warn("HPFS: hpfs_map_4sectors: out of memory\n");
+		pr_warn("hpfs_map_4sectors: out of memory\n");
 		goto bail4;
 	}
 
@@ -145,7 +145,7 @@ void *hpfs_get_4sectors(struct super_block *s, unsigned secno,
 	hpfs_lock_assert(s);
 
 	if (secno & 3) {
-		pr_warn("HPFS: hpfs_get_4sectors: unaligned read\n");
+		pr_warn("hpfs_get_4sectors: unaligned read\n");
 		return NULL;
 	}
 
@@ -161,7 +161,7 @@ void *hpfs_get_4sectors(struct super_block *s, unsigned secno,
 	}
 
 	if (!(qbh->data = kmalloc(2048, GFP_NOFS))) {
-		pr_warn("HPFS: hpfs_get_4sectors: out of memory\n");
+		pr_warn("hpfs_get_4sectors: out of memory\n");
 		goto bail4;
 	}
 	return qbh->data;
diff --git a/fs/hpfs/dir.c b/fs/hpfs/dir.c
index 11ea936..3377eba73 100644
--- a/fs/hpfs/dir.c
+++ b/fs/hpfs/dir.c
@@ -127,7 +127,7 @@ static int hpfs_readdir(struct file *file, struct dir_context *ctx)
 		if (ctx->pos == 12)
 			goto out;
 		if (ctx->pos == 3 || ctx->pos == 4 || ctx->pos == 5) {
-			pr_warn("HPFS: warning: pos==%d\n", (int)ctx->pos);
+			pr_warn("pos==%d\n", (int)ctx->pos);
 			goto out;
 		}
 		if (ctx->pos == 0) {
diff --git a/fs/hpfs/dnode.c b/fs/hpfs/dnode.c
index ff4f898..69554e2 100644
--- a/fs/hpfs/dnode.c
+++ b/fs/hpfs/dnode.c
@@ -17,7 +17,7 @@ static loff_t get_pos(struct dnode *d, struct hpfs_dirent *fde)
 		if (de == fde) return ((loff_t) le32_to_cpu(d->self) << 4) | (loff_t)i;
 		i++;
 	}
-	pr_info("HPFS: get_pos: not_found\n");
+	pr_info("get_pos: not_found\n");
 	return ((loff_t)le32_to_cpu(d->self) << 4) | (loff_t)1;
 }
 
@@ -32,7 +32,7 @@ void hpfs_add_pos(struct inode *inode, loff_t *pos)
 			if (hpfs_inode->i_rddir_off[i] == pos) return;
 	if (!(i&0x0f)) {
 		if (!(ppos = kmalloc((i+0x11) * sizeof(loff_t*), GFP_NOFS))) {
-			pr_warn("HPFS: out of memory for position list\n");
+			pr_warn("out of memory for position list\n");
 			return;
 		}
 		if (hpfs_inode->i_rddir_off) {
@@ -63,7 +63,7 @@ void hpfs_del_pos(struct inode *inode, loff_t *pos)
 	}
 	return;
 	not_f:
-	/*pr_info("HPFS: warning: position pointer %p->%08x not found\n",
+	/*pr_warn("position pointer %p->%08x not found\n",
 		  pos, (int)*pos);*/
 	return;
 }
@@ -94,7 +94,7 @@ static void hpfs_pos_ins(loff_t *p, loff_t d, loff_t c)
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) + c;
 		if (n > 0x3f)
-			pr_warn("HPFS: hpfs_pos_ins: %08x + %d\n",
+			pr_warn("hpfs_pos_ins: %08x + %d\n",
 				(int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
@@ -106,7 +106,7 @@ static void hpfs_pos_del(loff_t *p, loff_t d, loff_t c)
 	if ((*p & ~0x3f) == (d & ~0x3f) && (*p & 0x3f) >= (d & 0x3f)) {
 		int n = (*p & 0x3f) - c;
 		if (n < 1)
-			pr_warn("HPFS: hpfs_pos_ins: %08x - %d\n",
+			pr_warn("hpfs_pos_ins: %08x - %d\n",
 				(int)*p, (int)c >> 8);
 		else
 			*p = (*p & ~0x3f) | n;
@@ -246,7 +246,7 @@ static int hpfs_add_to_dnode(struct inode *i, dnode_secno dno,
 	struct fnode *fnode;
 	int c1, c2 = 0;
 	if (!(nname = kmalloc(256, GFP_NOFS))) {
-		pr_warn("HPFS: out of memory, can't add to dnode\n");
+		pr_warn("out of memory, can't add to dnode\n");
 		return 1;
 	}
 	go_up:
@@ -288,7 +288,7 @@ static int hpfs_add_to_dnode(struct inode *i, dnode_secno dno,
 		   not be any error while splitting dnodes, otherwise the
 		   whole directory, not only file we're adding, would
 		   be lost. */
-		pr_warn("HPFS: out of memory for dnode splitting\n");
+		pr_warn("out of memory for dnode splitting\n");
 		hpfs_brelse4(&qbh);
 		kfree(nname);
 		return 1;
@@ -604,7 +604,7 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 		if (!de_next->down) goto endm;
 		ndown = de_down_pointer(de_next);
 		if (!(de_cp = kmalloc(le16_to_cpu(de->length), GFP_NOFS))) {
-			pr_warn("HPFS: out of memory for dtree balancing\n");
+			pr_warn("out of memory for dtree balancing\n");
 			goto endm;
 		}
 		memcpy(de_cp, de, le16_to_cpu(de->length));
@@ -645,15 +645,15 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 			if (!dlp && down) {
 				if (le32_to_cpu(d1->first_free) > 2044) {
 					if (hpfs_sb(i->i_sb)->sb_chk >= 2) {
-						pr_warn("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
-						pr_warn("HPFS: warning: terminating balancing operation\n");
+						pr_warn("unbalanced dnode tree, see hpfs.txt 4 more info\n");
+						pr_warn("terminating balancing operation\n");
 					}
 					hpfs_brelse4(&qbh1);
 					goto endm;
 				}
 				if (hpfs_sb(i->i_sb)->sb_chk >= 2) {
-					pr_warn("HPFS: warning: unbalanced dnode tree, see hpfs.txt 4 more info\n");
-					pr_warn("HPFS: warning: goin'on\n");
+					pr_warn("unbalanced dnode tree, see hpfs.txt 4 more info\n");
+					pr_warn("goin'on\n");
 				}
 				le16_add_cpu(&del->length, 4);
 				del->down = 1;
@@ -667,7 +667,7 @@ static void delete_empty_dnode(struct inode *i, dnode_secno dno)
 				*(__le32 *) ((void *) del + le16_to_cpu(del->length) - 4) = cpu_to_le32(down);
 		} else goto endm;
 		if (!(de_cp = kmalloc(le16_to_cpu(de_prev->length), GFP_NOFS))) {
-			pr_warn("HPFS: out of memory for dtree balancing\n");
+			pr_warn("out of memory for dtree balancing\n");
 			hpfs_brelse4(&qbh1);
 			goto endm;
 		}
@@ -1008,7 +1008,7 @@ struct hpfs_dirent *map_fnode_dirent(struct super_block *s, fnode_secno fno,
 	int d1, d2 = 0;
 	name1 = f->name;
 	if (!(name2 = kmalloc(256, GFP_NOFS))) {
-		pr_warn("HPFS: out of memory, can't map dirent\n");
+		pr_warn("out of memory, can't map dirent\n");
 		return NULL;
 	}
 	if (f->len <= 15)
diff --git a/fs/hpfs/ea.c b/fs/hpfs/ea.c
index 6ac822a..8178059 100644
--- a/fs/hpfs/ea.c
+++ b/fs/hpfs/ea.c
@@ -51,7 +51,7 @@ static char *get_indirect_ea(struct super_block *s, int ano, secno a, int size)
 {
 	char *ret;
 	if (!(ret = kmalloc(size + 1, GFP_NOFS))) {
-		pr_warn("HPFS: out of memory for EA\n");
+		pr_warn("out of memory for EA\n");
 		return NULL;
 	}
 	if (hpfs_ea_read(s, a, ano, 0, size, ret)) {
@@ -139,7 +139,7 @@ char *hpfs_get_ea(struct super_block *s, struct fnode *fnode, char *key, int *si
 			if (ea_indirect(ea))
 				return get_indirect_ea(s, ea_in_anode(ea), ea_sec(ea), *size = ea_len(ea));
 			if (!(ret = kmalloc((*size = ea_valuelen(ea)) + 1, GFP_NOFS))) {
-				pr_warn("HPFS: out of memory for EA\n");
+				pr_warn("out of memory for EA\n");
 				return NULL;
 			}
 			memcpy(ret, ea_data(ea), ea_valuelen(ea));
@@ -165,7 +165,7 @@ char *hpfs_get_ea(struct super_block *s, struct fnode *fnode, char *key, int *si
 			if (ea_indirect(ea))
 				return get_indirect_ea(s, ea_in_anode(ea), ea_sec(ea), *size = ea_len(ea));
 			if (!(ret = kmalloc((*size = ea_valuelen(ea)) + 1, GFP_NOFS))) {
-				pr_warn("HPFS: out of memory for EA\n");
+				pr_warn("out of memory for EA\n");
 				return NULL;
 			}
 			if (hpfs_ea_read(s, a, ano, pos + 4 + ea->namelen + 1, ea_valuelen(ea), ret)) {
diff --git a/fs/hpfs/hpfs_fn.h b/fs/hpfs/hpfs_fn.h
index 3ba49c0..b63b75f 100644
--- a/fs/hpfs/hpfs_fn.h
+++ b/fs/hpfs/hpfs_fn.h
@@ -8,6 +8,11 @@
 
 //#define DBG
 //#define DEBUG_LOCKS
+#ifdef pr_fmt
+#undef pr_fmt
+#endif
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
diff --git a/fs/hpfs/inode.c b/fs/hpfs/inode.c
index 42c2908..89e5a0b 100644
--- a/fs/hpfs/inode.c
+++ b/fs/hpfs/inode.c
@@ -184,7 +184,7 @@ void hpfs_write_inode(struct inode *i)
 	if (i->i_ino == hpfs_sb(i->i_sb)->sb_root) return;
 	if (hpfs_inode->i_rddir_off && !atomic_read(&i->i_count)) {
 		if (*hpfs_inode->i_rddir_off)
-			pr_warn("HPFS: write_inode: some position still there\n");
+			pr_warn("write_inode: some position still there\n");
 		kfree(hpfs_inode->i_rddir_off);
 		hpfs_inode->i_rddir_off = NULL;
 	}
diff --git a/fs/hpfs/map.c b/fs/hpfs/map.c
index 398d7b1..6ac8f7a 100644
--- a/fs/hpfs/map.c
+++ b/fs/hpfs/map.c
@@ -65,13 +65,13 @@ unsigned char *hpfs_load_code_page(struct super_block *s, secno cps)
 	struct code_page_directory *cp = hpfs_map_sector(s, cps, &bh, 0);
 	if (!cp) return NULL;
 	if (le32_to_cpu(cp->magic) != CP_DIR_MAGIC) {
-		pr_warn("HPFS: Code page directory magic doesn't match (magic = %08x)\n",
+		pr_warn("Code page directory magic doesn't match (magic = %08x)\n",
 			le32_to_cpu(cp->magic));
 		brelse(bh);
 		return NULL;
 	}
 	if (!le32_to_cpu(cp->n_code_pages)) {
-		pr_warn("HPFS: n_code_pages == 0\n");
+		pr_warn("n_code_pages == 0\n");
 		brelse(bh);
 		return NULL;
 	}
@@ -80,19 +80,19 @@ unsigned char *hpfs_load_code_page(struct super_block *s, secno cps)
 	brelse(bh);
 
 	if (cpi >= 3) {
-		pr_warn("HPFS: Code page index out of array\n");
+		pr_warn("Code page index out of array\n");
 		return NULL;
 	}
 	
 	if (!(cpd = hpfs_map_sector(s, cpds, &bh, 0))) return NULL;
 	if (le16_to_cpu(cpd->offs[cpi]) > 0x178) {
-		pr_warn("HPFS: Code page index out of sector\n");
+		pr_warn("Code page index out of sector\n");
 		brelse(bh);
 		return NULL;
 	}
 	ptr = (unsigned char *)cpd + le16_to_cpu(cpd->offs[cpi]) + 6;
 	if (!(cp_table = kmalloc(256, GFP_KERNEL))) {
-		pr_warn("HPFS: out of memory for code page table\n");
+		pr_warn("out of memory for code page table\n");
 		brelse(bh);
 		return NULL;
 	}
@@ -115,7 +115,7 @@ __le32 *hpfs_load_bitmap_directory(struct super_block *s, secno bmp)
 	int i;
 	__le32 *b;
 	if (!(b = kmalloc(n * 512, GFP_KERNEL))) {
-		pr_warn("HPFS: can't allocate memory for bitmap directory\n");
+		pr_warn("can't allocate memory for bitmap directory\n");
 		return NULL;
 	}	
 	for (i=0;i<n;i++) {
@@ -283,7 +283,7 @@ struct dnode *hpfs_map_dnode(struct super_block *s, unsigned secno,
 				goto bail;
 			}
 			if (b == 3)
-				pr_warn("HPFS: warning: unbalanced dnode tree, dnode %08x; see hpfs.txt 4 more info\n",
+				pr_warn("unbalanced dnode tree, dnode %08x; see hpfs.txt 4 more info\n",
 					secno);
 		}
 	return dnode;
diff --git a/fs/hpfs/name.c b/fs/hpfs/name.c
index 61ffd04..91f4cc1 100644
--- a/fs/hpfs/name.c
+++ b/fs/hpfs/name.c
@@ -56,15 +56,15 @@ unsigned char *hpfs_translate_name(struct super_block *s, unsigned char *from,
 	unsigned char *to;
 	int i;
 	if (hpfs_sb(s)->sb_chk >= 2) if (hpfs_is_name_long(from, len) != lng) {
-		pr_warn("HPFS: Long name flag mismatch - name ");
+		pr_warn("Long name flag mismatch - name ");
 		for (i = 0; i < len; i++)
 			pr_cont("%c", from[i]);
 		pr_cont(" misidentified as %s.\n", lng ? "short" : "long");
-		pr_warn("HPFS: It's nothing serious. It could happen because of bug in OS/2.\nHPFS: Set checks=normal to disable this message.\n");
+		pr_warn("It's nothing serious. It could happen because of bug in OS/2.\nSet checks=normal to disable this message.\n");
 	}
 	if (!lc) return from;
 	if (!(to = kmalloc(len, GFP_KERNEL))) {
-		pr_warn("HPFS: can't allocate memory for name conversion buffer\n");
+		pr_warn("can't allocate memory for name conversion buffer\n");
 		return from;
 	}
 	for (i = 0; i < len; i++) to[i] = locase(hpfs_sb(s)->sb_cp_table,from[i]);
diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index d11e6ed..bdbc2c3 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -404,7 +404,7 @@ again:
 			d_rehash(dentry);
 		} else {
 			struct iattr newattrs;
-			/*pr_info("HPFS: truncating file before delete.\n");*/
+			/*pr_info("truncating file before delete.\n");*/
 			newattrs.ia_size = 0;
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 			err = notify_change(dentry, &newattrs, NULL);
diff --git a/fs/hpfs/super.c b/fs/hpfs/super.c
index e229b3f..92fd3ce 100644
--- a/fs/hpfs/super.c
+++ b/fs/hpfs/super.c
@@ -62,7 +62,7 @@ void hpfs_error(struct super_block *s, const char *fmt, ...)
 	vsnprintf(err_buf, sizeof(err_buf), fmt, args);
 	va_end(args);
 
-	pr_err("HPFS: filesystem error: %s", err_buf);
+	pr_err("filesystem error: %s", err_buf);
 	if (!hpfs_sb(s)->sb_was_error) {
 		if (hpfs_sb(s)->sb_err == 2) {
 			pr_cont("; crashing the system because you wanted it\n");
@@ -438,7 +438,7 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 
 	if (!(o = parse_opts(data, &uid, &gid, &umask, &lowercase,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
-		pr_warn("HPFS: bad mount options.\n");
+		pr_warn("bad mount options.\n");
 		goto out_err;
 	}
 	if (o == 2) {
@@ -446,7 +446,7 @@ static int hpfs_remount_fs(struct super_block *s, int *flags, char *data)
 		goto out_err;
 	}
 	if (timeshift != sbi->sb_timeshift) {
-		pr_warn("HPFS: timeshift can't be changed using remount.\n");
+		pr_warn("timeshift can't be changed using remount.\n");
 		goto out_err;
 	}
 
@@ -527,7 +527,7 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	if (!(o = parse_opts(options, &uid, &gid, &umask, &lowercase,
 	    &eas, &chk, &errs, &chkdsk, &timeshift))) {
-		pr_warn("HPFS: bad mount options.\n");
+		pr_warn("bad mount options.\n");
 		goto bail0;
 	}
 	if (o==2) {
@@ -547,16 +547,16 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	    ||*/ le32_to_cpu(superblock->magic) != SB_MAGIC
 	    || le32_to_cpu(spareblock->magic) != SP_MAGIC) {
 		if (!silent)
-			pr_warn("HPFS: Bad magic ... probably not HPFS\n");
+			pr_warn("Bad magic ... probably not HPFS\n");
 		goto bail4;
 	}
 
 	/* Check version */
 	if (!(s->s_flags & MS_RDONLY) &&
 	      superblock->funcversion != 2 && superblock->funcversion != 3) {
-		pr_warn("HPFS: Bad version %d,%d. Mount readonly to go around\n",
+		pr_warn("Bad version %d,%d. Mount readonly to go around\n",
 			(int)superblock->version, (int)superblock->funcversion);
-		pr_warn("HPFS: please try recent version of HPFS driver at http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi and if it still can't understand this format, contact author - mikulas@artax.karlin.mff.cuni.cz\n");
+		pr_warn("please try recent version of HPFS driver at http://artax.karlin.mff.cuni.cz/~mikulas/vyplody/hpfs/index-e.cgi and if it still can't understand this format, contact author - mikulas@artax.karlin.mff.cuni.cz\n");
 		goto bail4;
 	}
 
@@ -602,7 +602,7 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 	/* Check for general fs errors*/
 	if (spareblock->dirty && !spareblock->old_wrote) {
 		if (errs == 2) {
-			pr_warn("HPFS: Improperly stopped, not mounted\n");
+			pr_warn("Improperly stopped, not mounted\n");
 			goto bail4;
 		}
 		hpfs_error(s, "improperly stopped");
@@ -616,25 +616,25 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 
 	if (spareblock->hotfixes_used || spareblock->n_spares_used) {
 		if (errs >= 2) {
-			pr_warn("HPFS: Hotfixes not supported here, try chkdsk\n");
+			pr_warn("Hotfixes not supported here, try chkdsk\n");
 			mark_dirty(s, 0);
 			goto bail4;
 		}
 		hpfs_error(s, "hotfixes not supported here, try chkdsk");
 		if (errs == 0)
-			pr_warn("HPFS: Proceeding, but your filesystem will be probably corrupted by this driver...\n");
+			pr_warn("Proceeding, but your filesystem will be probably corrupted by this driver...\n");
 		else
-			pr_warn("HPFS: This driver may read bad files or crash when operating on disk with hotfixes.\n");
+			pr_warn("This driver may read bad files or crash when operating on disk with hotfixes.\n");
 	}
 	if (le32_to_cpu(spareblock->n_dnode_spares) != le32_to_cpu(spareblock->n_dnode_spares_free)) {
 		if (errs >= 2) {
-			pr_warn("HPFS: Spare dnodes used, try chkdsk\n");
+			pr_warn("Spare dnodes used, try chkdsk\n");
 			mark_dirty(s, 0);
 			goto bail4;
 		}
 		hpfs_error(s, "warning: spare dnodes used, try chkdsk");
 		if (errs == 0)
-			pr_warn("HPFS: Proceeding, but your filesystem could be corrupted if you delete files or directories\n");
+			pr_warn("Proceeding, but your filesystem could be corrupted if you delete files or directories\n");
 	}
 	if (chk) {
 		unsigned a;
@@ -654,12 +654,12 @@ static int hpfs_fill_super(struct super_block *s, void *options, int silent)
 		}
 		sbi->sb_dirband_size = a;
 	} else
-		pr_warn("HPFS: You really don't want any checks? You are crazy...\n");
+		pr_warn("You really don't want any checks? You are crazy...\n");
 
 	/* Load code page table */
 	if (le32_to_cpu(spareblock->n_code_pages))
 		if (!(sbi->sb_cp_table = hpfs_load_code_page(s, le32_to_cpu(spareblock->code_page_dir))))
-			pr_warn("HPFS: Warning: code page support is disabled\n");
+			pr_warn("code page support is disabled\n");
 
 	brelse(bh2);
 	brelse(bh1);
-- 
1.8.4.5

