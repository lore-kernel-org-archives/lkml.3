Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaCFSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:25:56 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:43060 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753044AbaCFSZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:25:54 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AooeANa8GFNbsmBr/2dsb2JhbABaKIJeO4MLpgCYZwICgRoXdIIlAQEBAwEaDRMcIwULCAMOCi45HgYTh3EMAc9JF44OTQeEOAEDiUqOcwGKVIdXgzovgSwBHwI
Date: Thu, 6 Mar 2014 18:27:24 +0800
From: Fabian Frederick <fabf@skynet.be>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] fs: gfs2: global conversion to pr_foo()
Message-Id: <20140306182724.6754407d4c629085d9fc318e@skynet.be>
In-Reply-To: <1394128662.2729.23.camel@menhir>
References: <20140305220642.9405a88f040c5d5f183e1119@skynet.be>
	<1394120644.2729.21.camel@menhir>
	<20140306172452.221bfd542784ee9688a53c4a@skynet.be>
	<1394128662.2729.23.camel@menhir>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Mar 2014 17:57:42 +0000
Steven Whitehouse <swhiteho@redhat.com> wrote:

> Hi,
> 
> On Thu, 2014-03-06 at 17:24 +0800, Fabian Frederick wrote:
> > On Thu, 06 Mar 2014 15:44:04 +0000
> > Steven Whitehouse <swhiteho@redhat.com> wrote:
> > 
> > > Hi,
> > > 
> > > On Wed, 2014-03-05 at 22:06 +0800, Fabian Frederick wrote:
> > > > -All printk(KERN_foo converted to pr_foo().
> > > > -Messages updated to fit in 80 columns.
> > > > -fs_macros converted as well.
> > > > -fs_printk removed.
> > > > 
> > > > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > > 
> > > Due to various other patches, this didn't apply directly, so I've fixed
> > > it up by hand. I have pushed it to the -nmw tree, so please do take a
> > > look and check that I didn't miss anything. Thanks,
> > > 
> > > Steve.
> > 
> > Hi Steve,
> > 
> >    Maybe I'm not looking at the right place (steve/gfs2-3.0-nmw.git/) but gfs2 in that tree (with patch applied) still has 25 printk entries. Original patch just keeps 3 printk : 1 commented line, "GFS2 installed" and vprintk(fmt...
> > 
> > Fabian
> > 
> Yes, I see now... I think git didn't give me the full list of files with
> rejects or something like that. Anyway I've picked up the other bits
> that were missing now and I think it should now be complete,
> 
> Steve.

Thanks :) It seems better now except fs_macros in util.h but I guess Joe will update all that stuff anyway.

Fabian
> 
> > 
> > 
> > > 
> > > > ---
> > > >  fs/gfs2/dir.c        |  7 ++++---
> > > >  fs/gfs2/glock.c      | 19 ++++++++++---------
> > > >  fs/gfs2/lock_dlm.c   |  6 +++---
> > > >  fs/gfs2/log.c        |  4 ++--
> > > >  fs/gfs2/ops_fstype.c | 18 +++++++++---------
> > > >  fs/gfs2/quota.c      |  2 +-
> > > >  fs/gfs2/rgrp.c       | 18 +++++++++---------
> > > >  fs/gfs2/super.c      | 21 ++++++++++++++-------
> > > >  fs/gfs2/trans.c      |  8 ++++----
> > > >  fs/gfs2/util.c       | 12 ++++++------
> > > >  fs/gfs2/util.h       | 11 ++++-------
> > > >  11 files changed, 66 insertions(+), 60 deletions(-)
> > > > 
> > > > diff --git a/fs/gfs2/dir.c b/fs/gfs2/dir.c
> > > > index fa32655..abcac94 100644
> > > > --- a/fs/gfs2/dir.c
> > > > +++ b/fs/gfs2/dir.c
> > > > @@ -507,7 +507,7 @@ static int gfs2_check_dirent(struct gfs2_dirent *dent, unsigned int offset,
> > > >  		goto error;
> > > >  	return 0;
> > > >  error:
> > > > -	printk(KERN_WARNING "gfs2_check_dirent: %s (%s)\n", msg,
> > > > +	pr_warn("gfs2_check_dirent: %s (%s)\n", msg,
> > > >  	       first ? "first in block" : "not first in block");
> > > >  	return -EIO;
> > > >  }
> > > > @@ -531,7 +531,7 @@ static int gfs2_dirent_offset(const void *buf)
> > > >  	}
> > > >  	return offset;
> > > >  wrong_type:
> > > > -	printk(KERN_WARNING "gfs2_scan_dirent: wrong block type %u\n",
> > > > +	pr_warn("gfs2_scan_dirent: wrong block type %u\n",
> > > >  	       be32_to_cpu(h->mh_type));
> > > >  	return -1;
> > > >  }
> > > > @@ -1006,7 +1006,8 @@ static int dir_split_leaf(struct inode *inode, const struct qstr *name)
> > > >  	len = 1 << (dip->i_depth - be16_to_cpu(oleaf->lf_depth));
> > > >  	half_len = len >> 1;
> > > >  	if (!half_len) {
> > > > -		printk(KERN_WARNING "i_depth %u lf_depth %u index %u\n", dip->i_depth, be16_to_cpu(oleaf->lf_depth), index);
> > > > +		pr_warn("i_depth %u lf_depth %u index %u\n", dip->i_depth,
> > > > +			be16_to_cpu(oleaf->lf_depth), index);
> > > >  		gfs2_consist_inode(dip);
> > > >  		error = -EIO;
> > > >  		goto fail_brelse;
> > > > diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> > > > index ca0be6c..eac3d24 100644
> > > > --- a/fs/gfs2/glock.c
> > > > +++ b/fs/gfs2/glock.c
> > > > @@ -468,7 +468,8 @@ retry:
> > > >  			do_xmote(gl, gh, LM_ST_UNLOCKED);
> > > >  			break;
> > > >  		default: /* Everything else */
> > > > -			printk(KERN_ERR "GFS2: wanted %u got %u\n", gl->gl_target, state);
> > > > +			pr_err("GFS2: wanted %u got %u\n",
> > > > +			       gl->gl_target, state);
> > > >  			GLOCK_BUG_ON(gl, 1);
> > > >  		}
> > > >  		spin_unlock(&gl->gl_spin);
> > > > @@ -542,7 +543,7 @@ __acquires(&gl->gl_spin)
> > > >  		/* lock_dlm */
> > > >  		ret = sdp->sd_lockstruct.ls_ops->lm_lock(gl, target, lck_flags);
> > > >  		if (ret) {
> > > > -			printk(KERN_ERR "GFS2: lm_lock ret %d\n", ret);
> > > > +			pr_err("GFS2: lm_lock ret %d\n", ret);
> > > >  			GLOCK_BUG_ON(gl, 1);
> > > >  		}
> > > >  	} else { /* lock_nolock */
> > > > @@ -935,7 +936,7 @@ void gfs2_print_dbg(struct seq_file *seq, const char *fmt, ...)
> > > >  		vaf.fmt = fmt;
> > > >  		vaf.va = &args;
> > > >  
> > > > -		printk(KERN_ERR " %pV", &vaf);
> > > > +		pr_err(" %pV", &vaf);
> > > >  	}
> > > >  
> > > >  	va_end(args);
> > > > @@ -1010,13 +1011,13 @@ do_cancel:
> > > >  	return;
> > > >  
> > > >  trap_recursive:
> > > > -	printk(KERN_ERR "original: %pSR\n", (void *)gh2->gh_ip);
> > > > -	printk(KERN_ERR "pid: %d\n", pid_nr(gh2->gh_owner_pid));
> > > > -	printk(KERN_ERR "lock type: %d req lock state : %d\n",
> > > > +	pr_err("original: %pSR\n", (void *)gh2->gh_ip);
> > > > +	pr_err("pid: %d\n", pid_nr(gh2->gh_owner_pid));
> > > > +	pr_err("lock type: %d req lock state : %d\n",
> > > >  	       gh2->gh_gl->gl_name.ln_type, gh2->gh_state);
> > > > -	printk(KERN_ERR "new: %pSR\n", (void *)gh->gh_ip);
> > > > -	printk(KERN_ERR "pid: %d\n", pid_nr(gh->gh_owner_pid));
> > > > -	printk(KERN_ERR "lock type: %d req lock state : %d\n",
> > > > +	pr_err("new: %pSR\n", (void *)gh->gh_ip);
> > > > +	pr_err("pid: %d\n", pid_nr(gh->gh_owner_pid));
> > > > +	pr_err("lock type: %d req lock state : %d\n",
> > > >  	       gh->gh_gl->gl_name.ln_type, gh->gh_state);
> > > >  	gfs2_dump_glock(NULL, gl);
> > > >  	BUG();
> > > > diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
> > > > index 2a6ba06..93a14ad 100644
> > > > --- a/fs/gfs2/lock_dlm.c
> > > > +++ b/fs/gfs2/lock_dlm.c
> > > > @@ -176,7 +176,7 @@ static void gdlm_bast(void *arg, int mode)
> > > >  		gfs2_glock_cb(gl, LM_ST_SHARED);
> > > >  		break;
> > > >  	default:
> > > > -		printk(KERN_ERR "unknown bast mode %d", mode);
> > > > +		pr_err("unknown bast mode %d", mode);
> > > >  		BUG();
> > > >  	}
> > > >  }
> > > > @@ -195,7 +195,7 @@ static int make_mode(const unsigned int lmstate)
> > > >  	case LM_ST_SHARED:
> > > >  		return DLM_LOCK_PR;
> > > >  	}
> > > > -	printk(KERN_ERR "unknown LM state %d", lmstate);
> > > > +	pr_err("unknown LM state %d", lmstate);
> > > >  	BUG();
> > > >  	return -1;
> > > >  }
> > > > @@ -308,7 +308,7 @@ static void gdlm_put_lock(struct gfs2_glock *gl)
> > > >  	error = dlm_unlock(ls->ls_dlm, gl->gl_lksb.sb_lkid, DLM_LKF_VALBLK,
> > > >  			   NULL, gl);
> > > >  	if (error) {
> > > > -		printk(KERN_ERR "gdlm_unlock %x,%llx err=%d\n",
> > > > +		pr_err("gdlm_unlock %x,%llx err=%d\n",
> > > >  		       gl->gl_name.ln_type,
> > > >  		       (unsigned long long)gl->gl_name.ln_number, error);
> > > >  		return;
> > > > diff --git a/fs/gfs2/log.c b/fs/gfs2/log.c
> > > > index 9dcb977..8606e5e 100644
> > > > --- a/fs/gfs2/log.c
> > > > +++ b/fs/gfs2/log.c
> > > > @@ -690,12 +690,12 @@ void gfs2_log_flush(struct gfs2_sbd *sdp, struct gfs2_glock *gl)
> > > >  	}
> > > >  
> > > >  	if (sdp->sd_log_num_buf != sdp->sd_log_commited_buf) {
> > > > -		printk(KERN_INFO "GFS2: log buf %u %u\n", sdp->sd_log_num_buf,
> > > > +		pr_info("GFS2: log buf %u %u\n", sdp->sd_log_num_buf,
> > > >  		       sdp->sd_log_commited_buf);
> > > >  		gfs2_assert_withdraw(sdp, 0);
> > > >  	}
> > > >  	if (sdp->sd_log_num_databuf != sdp->sd_log_commited_databuf) {
> > > > -		printk(KERN_INFO "GFS2: log databuf %u %u\n",
> > > > +		pr_info("GFS2: log databuf %u %u\n",
> > > >  		       sdp->sd_log_num_databuf, sdp->sd_log_commited_databuf);
> > > >  		gfs2_assert_withdraw(sdp, 0);
> > > >  	}
> > > > diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
> > > > index c6872d0..6db84b7 100644
> > > > --- a/fs/gfs2/ops_fstype.c
> > > > +++ b/fs/gfs2/ops_fstype.c
> > > > @@ -154,7 +154,7 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
> > > >  	if (sb->sb_magic != GFS2_MAGIC ||
> > > >  	    sb->sb_type != GFS2_METATYPE_SB) {
> > > >  		if (!silent)
> > > > -			printk(KERN_WARNING "GFS2: not a GFS2 filesystem\n");
> > > > +			pr_warn("GFS2: not a GFS2 filesystem\n");
> > > >  		return -EINVAL;
> > > >  	}
> > > >  
> > > > @@ -176,7 +176,7 @@ static void end_bio_io_page(struct bio *bio, int error)
> > > >  	if (!error)
> > > >  		SetPageUptodate(page);
> > > >  	else
> > > > -		printk(KERN_WARNING "gfs2: error %d reading superblock\n", error);
> > > > +		pr_warn("gfs2: error %d reading superblock\n", error);
> > > >  	unlock_page(page);
> > > >  }
> > > >  
> > > > @@ -555,7 +555,7 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
> > > >  		rc = gfs2_block_map(jd->jd_inode, lb, &bh, 0);
> > > >  		db = bh.b_blocknr;
> > > >  		if (rc || !db) {
> > > > -			printk(KERN_INFO "GFS2 journal mapping error %d: lb="
> > > > +			pr_info("GFS2 journal mapping error %d: lb="
> > > >  			       "%u db=%llu\n", rc, lb, (unsigned long long)db);
> > > >  			break;
> > > >  		}
> > > > @@ -563,7 +563,7 @@ static int map_journal_extents(struct gfs2_sbd *sdp)
> > > >  			jext = kzalloc(sizeof(struct gfs2_journal_extent),
> > > >  				       GFP_KERNEL);
> > > >  			if (!jext) {
> > > > -				printk(KERN_INFO "GFS2 error: out of memory "
> > > > +				pr_info("GFS2 error: out of memory "
> > > >  				       "mapping journal extents.\n");
> > > >  				rc = -ENOMEM;
> > > >  				break;
> > > > @@ -1008,7 +1008,7 @@ static int gfs2_lm_mount(struct gfs2_sbd *sdp, int silent)
> > > >  		lm = &gfs2_dlm_ops;
> > > >  #endif
> > > >  	} else {
> > > > -		printk(KERN_INFO "GFS2: can't find protocol %s\n", proto);
> > > > +		pr_info("GFS2: can't find protocol %s\n", proto);
> > > >  		return -ENOENT;
> > > >  	}
> > > >  
> > > > @@ -1115,7 +1115,7 @@ static int fill_super(struct super_block *sb, struct gfs2_args *args, int silent
> > > >  
> > > >  	sdp = init_sbd(sb);
> > > >  	if (!sdp) {
> > > > -		printk(KERN_WARNING "GFS2: can't alloc struct gfs2_sbd\n");
> > > > +		pr_warn("GFS2: can't alloc struct gfs2_sbd\n");
> > > >  		return -ENOMEM;
> > > >  	}
> > > >  	sdp->sd_args = *args;
> > > > @@ -1363,7 +1363,7 @@ static struct dentry *gfs2_mount(struct file_system_type *fs_type, int flags,
> > > >  
> > > >  	error = gfs2_mount_args(&args, data);
> > > >  	if (error) {
> > > > -		printk(KERN_WARNING "GFS2: can't parse mount arguments\n");
> > > > +		pr_warn("GFS2: can't parse mount arguments\n");
> > > >  		goto error_super;
> > > >  	}
> > > >  
> > > > @@ -1413,7 +1413,7 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
> > > >  
> > > >  	error = kern_path(dev_name, LOOKUP_FOLLOW, &path);
> > > >  	if (error) {
> > > > -		printk(KERN_WARNING "GFS2: path_lookup on %s returned error %d\n",
> > > > +		pr_warn("GFS2: path_lookup on %s returned error %d\n",
> > > >  		       dev_name, error);
> > > >  		return ERR_PTR(error);
> > > >  	}
> > > > @@ -1421,7 +1421,7 @@ static struct dentry *gfs2_mount_meta(struct file_system_type *fs_type,
> > > >  		 path.dentry->d_inode->i_sb->s_bdev);
> > > >  	path_put(&path);
> > > >  	if (IS_ERR(s)) {
> > > > -		printk(KERN_WARNING "GFS2: gfs2 mount does not exist\n");
> > > > +		pr_warn("GFS2: gfs2 mount does not exist\n");
> > > >  		return ERR_CAST(s);
> > > >  	}
> > > >  	if ((flags ^ s->s_flags) & MS_RDONLY) {
> > > > diff --git a/fs/gfs2/quota.c b/fs/gfs2/quota.c
> > > > index 8bec0e31..96a592f 100644
> > > > --- a/fs/gfs2/quota.c
> > > > +++ b/fs/gfs2/quota.c
> > > > @@ -1081,7 +1081,7 @@ static int print_message(struct gfs2_quota_data *qd, char *type)
> > > >  {
> > > >  	struct gfs2_sbd *sdp = qd->qd_gl->gl_sbd;
> > > >  
> > > > -	printk(KERN_INFO "GFS2: fsid=%s: quota %s for %s %u\n",
> > > > +	pr_info("GFS2: fsid=%s: quota %s for %s %u\n",
> > > >  	       sdp->sd_fsname, type,
> > > >  	       (qd->qd_id.type == USRQUOTA) ? "user" : "group",
> > > >  	       from_kqid(&init_user_ns, qd->qd_id));
> > > > diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
> > > > index a1da213..e95cc17 100644
> > > > --- a/fs/gfs2/rgrp.c
> > > > +++ b/fs/gfs2/rgrp.c
> > > > @@ -99,11 +99,11 @@ static inline void gfs2_setbit(const struct gfs2_rbm *rbm, bool do_clone,
> > > >  	cur_state = (*byte1 >> bit) & GFS2_BIT_MASK;
> > > >  
> > > >  	if (unlikely(!valid_change[new_state * 4 + cur_state])) {
> > > > -		printk(KERN_WARNING "GFS2: buf_blk = 0x%x old_state=%d, "
> > > > +		pr_warn("GFS2: buf_blk = 0x%x old_state=%d, "
> > > >  		       "new_state=%d\n", rbm->offset, cur_state, new_state);
> > > > -		printk(KERN_WARNING "GFS2: rgrp=0x%llx bi_start=0x%x\n",
> > > > +		pr_warn("GFS2: rgrp=0x%llx bi_start=0x%x\n",
> > > >  		       (unsigned long long)rbm->rgd->rd_addr, bi->bi_start);
> > > > -		printk(KERN_WARNING "GFS2: bi_offset=0x%x bi_len=0x%x\n",
> > > > +		pr_warn("GFS2: bi_offset=0x%x bi_len=0x%x\n",
> > > >  		       bi->bi_offset, bi->bi_len);
> > > >  		dump_stack();
> > > >  		gfs2_consist_rgrpd(rbm->rgd);
> > > > @@ -736,11 +736,11 @@ void gfs2_clear_rgrpd(struct gfs2_sbd *sdp)
> > > >  
> > > >  static void gfs2_rindex_print(const struct gfs2_rgrpd *rgd)
> > > >  {
> > > > -	printk(KERN_INFO "  ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
> > > > -	printk(KERN_INFO "  ri_length = %u\n", rgd->rd_length);
> > > > -	printk(KERN_INFO "  ri_data0 = %llu\n", (unsigned long long)rgd->rd_data0);
> > > > -	printk(KERN_INFO "  ri_data = %u\n", rgd->rd_data);
> > > > -	printk(KERN_INFO "  ri_bitbytes = %u\n", rgd->rd_bitbytes);
> > > > +	pr_info("  ri_addr = %llu\n", (unsigned long long)rgd->rd_addr);
> > > > +	pr_info("  ri_length = %u\n", rgd->rd_length);
> > > > +	pr_info("  ri_data0 = %llu\n", (unsigned long long)rgd->rd_data0);
> > > > +	pr_info("  ri_data = %u\n", rgd->rd_data);
> > > > +	pr_info("  ri_bitbytes = %u\n", rgd->rd_bitbytes);
> > > >  }
> > > >  
> > > >  /**
> > > > @@ -2278,7 +2278,7 @@ int gfs2_alloc_blocks(struct gfs2_inode *ip, u64 *bn, unsigned int *nblocks,
> > > >  		}
> > > >  	}
> > > >  	if (rbm.rgd->rd_free < *nblocks) {
> > > > -		printk(KERN_WARNING "nblocks=%u\n", *nblocks);
> > > > +		pr_warn("nblocks=%u\n", *nblocks);
> > > >  		goto rgrp_error;
> > > >  	}
> > > >  
> > > > diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
> > > > index 60f60f6..0dfe0aa 100644
> > > > --- a/fs/gfs2/super.c
> > > > +++ b/fs/gfs2/super.c
> > > > @@ -175,7 +175,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
> > > >  			break;
> > > >  		case Opt_debug:
> > > >  			if (args->ar_errors == GFS2_ERRORS_PANIC) {
> > > > -				printk(KERN_WARNING "GFS2: -o debug and -o errors=panic "
> > > > +				pr_warn("GFS2: -o debug and -o errors=panic "
> > > >  				       "are mutually exclusive.\n");
> > > >  				return -EINVAL;
> > > >  			}
> > > > @@ -228,21 +228,26 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
> > > >  		case Opt_commit:
> > > >  			rv = match_int(&tmp[0], &args->ar_commit);
> > > >  			if (rv || args->ar_commit <= 0) {
> > > > -				printk(KERN_WARNING "GFS2: commit mount option requires a positive numeric argument\n");
> > > > +				pr_warn("GFS2: commit mount option requires"
> > > > +					" a positive numeric argument\n");
> > > >  				return rv ? rv : -EINVAL;
> > > >  			}
> > > >  			break;
> > > >  		case Opt_statfs_quantum:
> > > >  			rv = match_int(&tmp[0], &args->ar_statfs_quantum);
> > > >  			if (rv || args->ar_statfs_quantum < 0) {
> > > > -				printk(KERN_WARNING "GFS2: statfs_quantum mount option requires a non-negative numeric argument\n");
> > > > +				pr_warn("GFS2: statfs_quantum mount option"
> > > > +					" requires a non-negative numeric"
> > > > +					" argument\n");
> > > >  				return rv ? rv : -EINVAL;
> > > >  			}
> > > >  			break;
> > > >  		case Opt_quota_quantum:
> > > >  			rv = match_int(&tmp[0], &args->ar_quota_quantum);
> > > >  			if (rv || args->ar_quota_quantum <= 0) {
> > > > -				printk(KERN_WARNING "GFS2: quota_quantum mount option requires a positive numeric argument\n");
> > > > +				pr_warn("GFS2: quota_quantum mount option"
> > > > +					" requires a positive numeric"
> > > > +					" argument\n");
> > > >  				return rv ? rv : -EINVAL;
> > > >  			}
> > > >  			break;
> > > > @@ -250,7 +255,9 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
> > > >  			rv = match_int(&tmp[0], &args->ar_statfs_percent);
> > > >  			if (rv || args->ar_statfs_percent < 0 ||
> > > >  			    args->ar_statfs_percent > 100) {
> > > > -				printk(KERN_WARNING "statfs_percent mount option requires a numeric argument between 0 and 100\n");
> > > > +				pr_warn("statfs_percent mount option requires"
> > > > +					" a numeric argument between 0"
> > > > +					" and 100\n");
> > > >  				return rv ? rv : -EINVAL;
> > > >  			}
> > > >  			break;
> > > > @@ -259,7 +266,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
> > > >  			break;
> > > >  		case Opt_err_panic:
> > > >  			if (args->ar_debug) {
> > > > -				printk(KERN_WARNING "GFS2: -o debug and -o errors=panic "
> > > > +				pr_warn("GFS2: -o debug and -o errors=panic "
> > > >  					"are mutually exclusive.\n");
> > > >  				return -EINVAL;
> > > >  			}
> > > > @@ -279,7 +286,7 @@ int gfs2_mount_args(struct gfs2_args *args, char *options)
> > > >  			break;
> > > >  		case Opt_error:
> > > >  		default:
> > > > -			printk(KERN_WARNING "GFS2: invalid mount option: %s\n", o);
> > > > +			pr_warn("GFS2: invalid mount option: %s\n", o);
> > > >  			return -EINVAL;
> > > >  		}
> > > >  	}
> > > > diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
> > > > index 2b20d70..f570819 100644
> > > > --- a/fs/gfs2/trans.c
> > > > +++ b/fs/gfs2/trans.c
> > > > @@ -96,11 +96,11 @@ static void gfs2_log_release(struct gfs2_sbd *sdp, unsigned int blks)
> > > >  
> > > >  static void gfs2_print_trans(const struct gfs2_trans *tr)
> > > >  {
> > > > -	printk(KERN_WARNING "GFS2: Transaction created at: %pSR\n",
> > > > +	pr_warn("GFS2: Transaction created at: %pSR\n",
> > > >  	       (void *)tr->tr_ip);
> > > > -	printk(KERN_WARNING "GFS2: blocks=%u revokes=%u reserved=%u touched=%d\n",
> > > > +	pr_warn("GFS2: blocks=%u revokes=%u reserved=%u touched=%d\n",
> > > >  	       tr->tr_blocks, tr->tr_revokes, tr->tr_reserved, tr->tr_touched);
> > > > -	printk(KERN_WARNING "GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
> > > > +	pr_warn("GFS2: Buf %u/%u Databuf %u/%u Revoke %u/%u\n",
> > > >  	       tr->tr_num_buf_new, tr->tr_num_buf_rm,
> > > >  	       tr->tr_num_databuf_new, tr->tr_num_databuf_rm,
> > > >  	       tr->tr_num_revoke, tr->tr_num_revoke_rm);
> > > > @@ -230,7 +230,7 @@ static void meta_lo_add(struct gfs2_sbd *sdp, struct gfs2_bufdata *bd)
> > > >  	set_bit(GLF_DIRTY, &bd->bd_gl->gl_flags);
> > > >  	mh = (struct gfs2_meta_header *)bd->bd_bh->b_data;
> > > >  	if (unlikely(mh->mh_magic != cpu_to_be32(GFS2_MAGIC))) {
> > > > -		printk(KERN_ERR
> > > > +		pr_err(
> > > >  		       "Attempting to add uninitialised block to journal (inplace block=%lld)\n",
> > > >  		       (unsigned long long)bd->bd_bh->b_blocknr);
> > > >  		BUG();
> > > > diff --git a/fs/gfs2/util.c b/fs/gfs2/util.c
> > > > index f7109f6..c83765a 100644
> > > > --- a/fs/gfs2/util.c
> > > > +++ b/fs/gfs2/util.c
> > > > @@ -30,7 +30,7 @@ mempool_t *gfs2_page_pool __read_mostly;
> > > >  
> > > >  void gfs2_assert_i(struct gfs2_sbd *sdp)
> > > >  {
> > > > -	printk(KERN_EMERG "GFS2: fsid=%s: fatal assertion failed\n",
> > > > +	pr_emerg("GFS2: fsid=%s: fatal assertion failed\n",
> > > >  	       sdp->sd_fsname);
> > > >  }
> > > >  
> > > > @@ -105,11 +105,11 @@ int gfs2_assert_warn_i(struct gfs2_sbd *sdp, char *assertion,
> > > >  		return -2;
> > > >  
> > > >  	if (sdp->sd_args.ar_errors == GFS2_ERRORS_WITHDRAW)
> > > > -		printk(KERN_WARNING
> > > > -		       "GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
> > > > -		       "GFS2: fsid=%s:   function = %s, file = %s, line = %u\n",
> > > > -		       sdp->sd_fsname, assertion,
> > > > -		       sdp->sd_fsname, function, file, line);
> > > > +		pr_warn("GFS2: fsid=%s: warning: assertion \"%s\" failed\n"
> > > > +			"GFS2: fsid=%s:   function = %s, file = %s,"
> > > > +			" line = %u\n",
> > > > +			sdp->sd_fsname, assertion,
> > > > +			sdp->sd_fsname, function, file, line);
> > > >  
> > > >  	if (sdp->sd_args.ar_debug)
> > > >  		BUG();
> > > > diff --git a/fs/gfs2/util.h b/fs/gfs2/util.h
> > > > index b7ffb09..7c90b1e 100644
> > > > --- a/fs/gfs2/util.h
> > > > +++ b/fs/gfs2/util.h
> > > > @@ -14,17 +14,14 @@
> > > >  
> > > >  #include "incore.h"
> > > >  
> > > > -#define fs_printk(level, fs, fmt, arg...) \
> > > > -	printk(level "GFS2: fsid=%s: " fmt , (fs)->sd_fsname , ## arg)
> > > > -
> > > >  #define fs_info(fs, fmt, arg...) \
> > > > -	fs_printk(KERN_INFO , fs , fmt , ## arg)
> > > > +	pr_info("GFS2: fsid=%s: " fmt , (fs)->sd_fsname , ## arg)
> > > >  
> > > >  #define fs_warn(fs, fmt, arg...) \
> > > > -	fs_printk(KERN_WARNING , fs , fmt , ## arg)
> > > > +	pr_warn("GFS2: fsid=%s: " fmt , (fs)->sd_fsname , ## arg)
> > > >  
> > > >  #define fs_err(fs, fmt, arg...) \
> > > > -	fs_printk(KERN_ERR, fs , fmt , ## arg)
> > > > +	pr_err("GFS2: fsid=%s: " fmt , (fs)->sd_fsname , ## arg)
> > > >  
> > > > 
> > > >  void gfs2_assert_i(struct gfs2_sbd *sdp);
> > > > @@ -85,7 +82,7 @@ static inline int gfs2_meta_check(struct gfs2_sbd *sdp,
> > > >  	struct gfs2_meta_header *mh = (struct gfs2_meta_header *)bh->b_data;
> > > >  	u32 magic = be32_to_cpu(mh->mh_magic);
> > > >  	if (unlikely(magic != GFS2_MAGIC)) {
> > > > -		printk(KERN_ERR "GFS2: Magic number missing at %llu\n",
> > > > +		pr_err("GFS2: Magic number missing at %llu\n",
> > > >  		       (unsigned long long)bh->b_blocknr);
> > > >  		return -EIO;
> > > >  	}
> > > 
> > > 
> 
> 
