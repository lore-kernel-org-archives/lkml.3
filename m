Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaDAJWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 05:22:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaDAJQd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 05:16:33 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Fabian Frederick <fabf@skynet.be>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 16/29] GFS2: global conversion to pr_foo()
Date: Tue,  1 Apr 2014 10:15:28 +0100
Message-Id: <1396343741-1524-17-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
References: <1396343741-1524-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>

-All printk(KERN_foo converted to pr_foo().
-Messages updated to fit in 80 columns.
-fs_macros converted as well.
-fs_printk removed.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
index ffcfdd1..39c7081 100644
--- a/fs/gfs2/dir.c
+++ b/fs/gfs2/dir.c
@@ -507,7 +507,7 @@ static int gfs2_check_dirent(struct gfs2_dirent *dent, unsigned int offset,
 		goto error;
 	return 0;
 error:
-	printk(KERN_WARNING "gfs2_check_dirent: %s (%s)\n", msg,
+	pr_warn("gfs2_check_dirent: %s (%s)\n", msg,
 	       first ? "first in block" : "not first in block");
 	return -EIO;
 }
@@ -531,8 +531,8 @@ static int gfs2_dirent_offset(const void *buf)
 	}
 	return offset;
 wrong_type:
-	printk(KERN_WARNING "gfs2_scan_dirent: wrong block type %u\n",
-	       be32_to_cpu(h->mh_type));
+	pr_warn("gfs2_scan_dirent: wrong block type %u\n",
+	        be32_to_cpu(h->mh_type));
 	return -1;
 }
 
@@ -1006,7 +1006,7 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
 	len = 1 << (dip->i_depth - be16_to_cpu(oleaf->lf_depth));
 	half_len = len >> 1;
 	if (!half_len) {
-		printk(KERN_WARNING "i_depth %u lf_depth %u index %u\n", dip->i_depth, be16_to_cpu(oleaf->lf_depth), index);
+		pr_warn("i_depth %u lf_depth %u index %u\n", dip->i_depth, be16_to_cpu(oleaf->lf_depth), index);
 		gfs2_consist_inode(dip);
 		error = -EIO;
 		goto fail_brelse;
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index ca0be6c..329dc80 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -468,7 +468,7 @@ retry:
 			do_xmote(gl, gh, LM_ST_UNLOCKED);
 			break;
 		default: /* Everything else */
-			printk(KERN_ERR "GFS2: wanted %u got %u\n", gl->gl_target, state);
+			pr_err("GFS2: wanted %u got %u\n", gl->gl_target, state);
 			GLOCK_BUG_ON(gl, 1);
 		}
 		spin_unlock(&gl->gl_spin);
@@ -542,7 +542,7 @@ __acquires(&gl->gl_spin)
 		/* lock_dlm */
 		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
 		if (ret) {
-			printk(KERN_ERR "GFS2: lm_lock ret %d\n", ret);
+			pr_err("GFS2: lm_lock ret %d\n", ret);
 			GLOCK_BUG_ON(gl, 1);
 		}
 	} else { /* lock_nolock */
@@ -935,7 +935,7 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
 		vaf.fmt = fmt;
 		vaf.va = &args;
 
-		printk(KERN_ERR " %pV", &vaf);
+		pr_err(" %pV", &vaf);
 	}
 
 	va_end(args);
@@ -1010,13 +1010,13 @@ do_cancel:
 	return;
 
 trap_recursive:
-	printk(KERN_ERR "original: %pSR\n", (void *)gh2->gh_ip);
-	printk(KERN_ERR "pid: %d\n", pid_nr(gh2->gh_owner_pid));
-	printk(KERN_ERR "lock type: %d req lock state : %d\n",
+	pr_err("original: %pSR\n", (void *)gh2->gh_ip);
+	pr_err("pid: %d\n", pid_nr(gh2->gh_owner_pid));
+	pr_err("lock type: %d req lock state : %d\n",
 	       gh2->gh_gl->gl_name.ln_type, gh2->gh_state);
-	printk(KERN_ERR "new: %pSR\n", (void *)gh->gh_ip);
-	printk(KERN_ERR "pid: %d\n", pid_nr(gh->gh_owner_pid));
-	printk(KERN_ERR "lock type: %d req lock state : %d\n",
+	pr_err("new: %pSR\n", (void *)gh->gh_ip);
+	pr_err("pid: %d\n", pid_nr(gh->gh_owner_pid));
+	pr_err("lock type: %d req lock state : %d\n",
 	       gh->gh_gl->gl_name.ln_type, gh->gh_state);
 	gfs2_dump_glock(NULL, gl);
 	BUG();
diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
index 6b97d98..a664ddd 100644
--- a/fs/gfs2/lock_dlm.c
+++ b/fs/gfs2/lock_dlm.c
@@ -176,7 +176,7 @@ static void gdlm_bast(void *arg, int mode)
 		gfs2_glock_cb(gl, LM_ST_SHARED);
 		break;
 	default:
-		printk(KERN_ERR "unknown bast mode %d", mode);
+		pr_err("unknown bast mode %d", mode);
 		BUG();
 	}
 }
@@ -195,7 +195,7 @@ static int make_mode(const unsigned int lmstate)
 	case LM_ST_SHARED:
 		return DLM_LOCK_PR;
 	}
-	printk(KERN_ERR "unknown LM state %d", lmstate);
+	pr_err("unknown LM state %d", lmstate);
 	BUG();
 	return -1;
 }
@@ -308,8 +308,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
 	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_VALBLK,
 			   NULL, gl);
 	if (error) {
-		printk(KERN_ERR "gdlm_unlock %x,%llx err=%d\n",
-		       gl->gl_name.ln_type,
+		pr_err("gdlm_unlock %x,%llx err=%d\n", gl->gl_name.ln_type,
 		       (unsigned long long)gl->gl_name.ln_number, error);
 		return;
 	}
diff --git a/fs/gfs2/main.c b/fs/gfs2/main.c
index c272e73..ae9b02b 100644
--- a/fs/gfs2/main.c
+++ b/fs/gfs2/main.c
@@ -165,7 +165,7 @@ static int __init init_gfs2_fs(void)
 
 	gfs2_register_debugfs();
 
-	printk("GFS2 installed\n");
+	pr_info("GFS2 installed\n");
 
 	return 0;
 
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index e0d0db5..c3ef844 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -152,7 +152,7 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 	if (sb->sb_magic != GFS2_MAGIC ||
 	    sb->sb_type != GFS2_METATYPE_SB) {
 		if (!silent)
-			printk(KERN_WARNING "GFS2: not a GFS2 filesystem\n");
+			pr_warn("GFS2: not a GFS2 filesystem\n");
 		return -EINVAL;
 	}
 
@@ -174,7 +174,7 @@ static void end_bio_io_page(struct bio *bio, int error)
 	if (!error)
 		SetPageUptodate(page);
 	else
-		printk(KERN_WARNING "gfs2: error %d reading superblock\n", error);
+		pr_warn("gfs2: error %d reading superblock\n", error);
 	unlock_page(page);
 }
 
@@ -945,7 +945,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
 		lm = &gfs2_dlm_ops;
 #endif
 	} else {
-		printk(KERN_INFO "GFS2: can't find protocol %s\n", proto);
+		pr_info("GFS2: can't find protocol %s\n", proto);
 		return -ENOENT;
 	}
 
@@ -1052,7 +1052,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
 
 	sdp = init_sbd(sb);
 	if (!sdp) {
-		printk(KERN_WARNING "GFS2: can't alloc struct gfs2_sbd\n");
+		pr_warn("GFS2: can't alloc struct gfs2_sbd\n");
 		return -ENOMEM;
 	}
 	sdp->sd_args = *args;
@@ -1300,7 +1300,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
 
 	error = gfs2_mount_args(&args, data);
 	if (error) {
-		printk(KERN_WARNING "GFS2: can't parse mount arguments\n");
+		pr_warn("GFS2: can't parse mount arguments\n");
 		goto error_super;
 	}
 
@@ -1350,7 +1350,7 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
 
 	error = kern_path(dev_name, LOOKUP_FOLLOW, &path);
 	if (error) {
-		printk(KERN_WARNING "GFS2: path_lookup on %s returned error %d\n",
+		pr_warn("GFS2: path_lookup on %s returned error %d\n",
 		       dev_name, error);
 		return ERR_PTR(error);
 	}
@@ -1358,7 +1358,7 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
 		 path.dentry->d_inode->i_sb->s_bdev);
 	path_put(&path);
 	if (IS_ERR(s)) {
-		printk(KERN_WARNING "GFS2: gfs2 mount does not exist\n");
+		pr_warn("GFS2: gfs2 mount does not exist\n");
 		return ERR_CAST(s);
 	}
 	if ((flags ^ s->s_flags) & MS_RDONLY) {
diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
index a5cccf6..6e25ee4 100644
--- a/fs/gfs2/quota.c
+++ b/fs/gfs2/quota.c
@@ -1081,7 +1081,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
 {
 	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
 
-	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\n",
+	pr_info("GFS2: fsid=%s: quota %s for %s %u\n",
 	       sdp->sd_fsname, type,
 	       (qd->qd_id.type == USRQUOTA) ? "user" : "group",
 	       from_kqid(&init_user_ns, qd->qd_id));
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index f585746..8d12038 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -99,11 +99,11 @@ static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
 	cur_state = (*byte1 >> bit) & GFS2_BIT_MASK;
 
 	if (unlikely(!valid_change[new_state * 4 + cur_state])) {
-		printk(KERN_WARNING "GFS2: buf_blk = 0x%x old_state=%d, "
+		pr_warn("GFS2: buf_blk = 0x%x old_state=%d, "
 		       "new_state=%d\n", rbm->offset, cur_state, new_state);
-		printk(KERN_WARNING "GFS2: rgrp=0x%llx bi_start=0x%x\n",
+		pr_warn("GFS2: rgrp=0x%llx bi_start=0x%x\n",
 		       (unsigned long long)rbm->rgd->rd_addr, bi->bi_start);
-		printk(KERN_WARNING "GFS2: bi_offset=0x%x bi_len=0x%x\n",
+		pr_warn("GFS2: bi_offset=0x%x bi_len=0x%x\n",
 		       bi->bi_offset, bi->bi_len);
 		dump_stack();
 		gfs2_consist_rgrpd(rbm->rgd);
@@ -736,11 +736,11 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
 
 static void gfs2_rindex_print(const struct gfs2_rgrpd *rgd)
 {
-	printk(KERN_INFO "  ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
-	printk(KERN_INFO "  ri_length = %u\n", rgd->rd_length);
-	printk(KERN_INFO "  ri_data0 = %llu\n", (unsigned long long)rgd->rd_data0);
-	printk(KERN_INFO "  ri_data = %u\n", rgd->rd_data);
-	printk(KERN_INFO "  ri_bitbytes = %u\n", rgd->rd_bitbytes);
+	pr_info("  ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
+	pr_info("  ri_length = %u\n", rgd->rd_length);
+	pr_info("  ri_data0 = %llu\n", (unsigned long long)rgd->rd_data0);
+	pr_info("  ri_data = %u\n", rgd->rd_data);
+	pr_info("  ri_bitbytes = %u\n", rgd->rd_bitbytes);
 }
 
 /**
@@ -2278,7 +2278,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
 		}
 	}
 	if (rbm.rgd->rd_free < *nblocks) {
-		printk(KERN_WARNING "nblocks=%u\n", *nblocks);
+		pr_warn("nblocks=%u\n", *nblocks);
 		goto rgrp_error;
 	}
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 2574744..584c757 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -175,7 +175,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			break;
 		case Opt_debug:
 			if (args->ar_errors == GFS2_ERRORS_PANIC) {
-				printk(KERN_WARNING "GFS2: -o debug and -o errors=panic "
+				pr_warn("GFS2: -o debug and -o errors=panic "
 				       "are mutually exclusive.\n");
 				return -EINVAL;
 			}
@@ -228,21 +228,21 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 		case Opt_commit:
 			rv = match_int(&tmp[0], &args->ar_commit);
 			if (rv || args->ar_commit <= 0) {
-				printk(KERN_WARNING "GFS2: commit mount option requires a positive numeric argument\n");
+				pr_warn("GFS2: commit mount option requires a positive numeric argument\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
 		case Opt_statfs_quantum:
 			rv = match_int(&tmp[0], &args->ar_statfs_quantum);
 			if (rv || args->ar_statfs_quantum < 0) {
-				printk(KERN_WARNING "GFS2: statfs_quantum mount option requires a non-negative numeric argument\n");
+				pr_warn("GFS2: statfs_quantum mount option requires a non-negative numeric argument\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
 		case Opt_quota_quantum:
 			rv = match_int(&tmp[0], &args->ar_quota_quantum);
 			if (rv || args->ar_quota_quantum <= 0) {
-				printk(KERN_WARNING "GFS2: quota_quantum mount option requires a positive numeric argument\n");
+				pr_warn("GFS2: quota_quantum mount option requires a positive numeric argument\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
@@ -250,7 +250,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			rv = match_int(&tmp[0], &args->ar_statfs_percent);
 			if (rv || args->ar_statfs_percent < 0 ||
 			    args->ar_statfs_percent > 100) {
-				printk(KERN_WARNING "statfs_percent mount option requires a numeric argument between 0 and 100\n");
+				pr_warn("statfs_percent mount option requires a numeric argument between 0 and 100\n");
 				return rv ? rv : -EINVAL;
 			}
 			break;
@@ -259,7 +259,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			break;
 		case Opt_err_panic:
 			if (args->ar_debug) {
-				printk(KERN_WARNING "GFS2: -o debug and -o errors=panic "
+				pr_warn("GFS2: -o debug and -o errors=panic "
 					"are mutually exclusive.\n");
 				return -EINVAL;
 			}
@@ -279,7 +279,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
 			break;
 		case Opt_error:
 		default:
-			printk(KERN_WARNING "GFS2: invalid mount option: %s\n", o);
+			pr_warn("GFS2: invalid mount option: %s\n", o);
 			return -EINVAL;
 		}
 	}
diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
index 295f400..3fe8e34 100644
--- a/fs/gfs2/trans.c
+++ b/fs/gfs2/trans.c
@@ -99,11 +99,10 @@ static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
 
 static void gfs2_print_trans(const struct gfs2_trans *tr)
 {
-	printk(KERN_WARNING "GFS2: Transaction created at: %pSR\n",
-	       (void *)tr->tr_ip);
-	printk(KERN_WARNING "GFS2: blocks=%u revokes=%u reserved=%u touched=%u\n",
+	pr_warn("GFS2: Transaction created at: %pSR\n", (void *)tr->tr_ip);
+	pr_warn("GFS2: blocks=%u revokes=%u reserved=%u touched=%u\n",
 	       tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
-	printk(KERN_WARNING "GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
+	pr_warn("GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
 	       tr->tr_num_buf_new, tr->tr_num_buf_rm,
 	       tr->tr_num_databuf_new, tr->tr_num_databuf_rm,
 	       tr->tr_num_revoke, tr->tr_num_revoke_rm);
@@ -232,8 +231,8 @@ static void meta_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
 	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
 	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
 	if (unlikely(mh->mh_magic != cpu_to_be32(GFS2_MAGIC))) {
-		printk(KERN_ERR
-		       "Attempting to add uninitialised block to journal (inplace block=%lld)\n",
+		pr_err("Attempting to add uninitialised block to journal "
+		       "(inplace block=%lld)\n",
 		       (unsigned long long)bd->bd_bh->b_blocknr);
 		BUG();
 	}
diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
index f7109f6..e9d7001 100644
--- a/fs/gfs2/util.c
+++ b/fs/gfs2/util.c
@@ -30,8 +30,7 @@ mempool_t *gfs2_page_pool __read_mostly;
 
 void gfs2_assert_i(struct gfs2_sbd *sdp)
 {
-	printk(KERN_EMERG "GFS2: fsid=%s: fatal assertion failed\n",
-	       sdp->sd_fsname);
+	pr_emerg("GFS2: fsid=%s: fatal assertion failed\n", sdp->sd_fsname);
 }
 
 int gfs2_lm_withdraw(struct gfs2_sbd *sdp, char *fmt, ...)
@@ -105,8 +104,7 @@ int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
 		return -2;
 
 	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW)
-		printk(KERN_WARNING
-		       "GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
+		pr_warn("GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
 		       "GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
 		       sdp->sd_fsname, assertion,
 		       sdp->sd_fsname, function, file, line);
-- 
1.8.3.1

