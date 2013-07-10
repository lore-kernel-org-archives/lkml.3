Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912Ab3GJJth (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 05:49:37 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:31276 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752857Ab3GJJte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 05:49:34 -0400
From: "Peng, Tao" <tao.peng@emc.com>
To: Waiman Long <Waiman.Long@hp.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>, Fan Yong <fan.yong@intel.com>,
        Ned Bass <bass6@llnl.gov>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: RE: [PATCH v6 12/14] lustre-fs: Use the standard d_count() helper
 to access refcount
Thread-Topic: [PATCH v6 12/14] lustre-fs: Use the standard d_count() helper
 to access refcount
Thread-Index: AQHOfEIoo+0DZb6Rd0OmAODZ5qKBZ5ldq85A
Date: Wed, 10 Jul 2013 09:47:13 +0000
Message-ID: <1882637210201641A747464075FFC6490E5A480D@MX101CL02.corp.emc.com>
References: <1373332204-10379-1-git-send-email-Waiman.Long@hp.com>
 <1373332204-10379-13-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1373332204-10379-13-git-send-email-Waiman.Long@hp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.32.218.73]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r6A9noEx015765

> -----Original Message-----
> From: Waiman Long [mailto:Waiman.Long@hp.com]
> Sent: Tuesday, July 09, 2013 9:10 AM
> To: Alexander Viro; Jeff Layton; Miklos Szeredi; Ingo Molnar; Thomas Gleixner
> Cc: Waiman Long; linux-fsdevel@vger.kernel.org; Greg Kroah-Hartman; Andreas Dilger; Peng, Tao; Oleg Drokin;
> Fan Yong; Ned Bass; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org; Peter Zijlstra; Steven
> Rostedt; Linus Torvalds; Benjamin Herrenschmidt; Andi Kleen; Chandramouleeswaran, Aswin; Norton, Scott J
> Subject: [PATCH v6 12/14] lustre-fs: Use the standard d_count() helper to access refcount
> 
> The Lustre FS should use the newly defined d_count() helper function
> to access the dentry's reference count instead of defining its own
> d_refcount() macro for the same purpose. Since the current lustre
> code is marked as broken, no build test was attempted for this change.
> 
This was already fixed by Al. See commit 193deee199c55ce06bca2b3e5e2d3c10208a942a in Linus tree.

Thanks,
Tao

> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  .../lustre/include/linux/lustre_patchless_compat.h |    2 --
>  drivers/staging/lustre/lustre/include/linux/lvfs.h |    2 +-
>  drivers/staging/lustre/lustre/llite/dcache.c       |    8 ++++----
>  .../staging/lustre/lustre/llite/llite_internal.h   |    4 ++--
>  drivers/staging/lustre/lustre/llite/llite_lib.c    |    2 +-
>  drivers/staging/lustre/lustre/llite/namei.c        |    4 ++--
>  drivers/staging/lustre/lustre/lvfs/lvfs_linux.c    |    4 ++--
>  7 files changed, 12 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> index f050808..a8e9c0c 100644
> --- a/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> +++ b/drivers/staging/lustre/lustre/include/linux/lustre_patchless_compat.h
> @@ -60,8 +60,6 @@ truncate_complete_page(struct address_space *mapping, struct page *page)
>  	ll_delete_from_page_cache(page);
>  }
> 
> -#  define d_refcount(d)		 ((d)->d_count)
> -
>  #ifdef ATTR_OPEN
>  # define ATTR_FROM_OPEN ATTR_OPEN
>  #else
> diff --git a/drivers/staging/lustre/lustre/include/linux/lvfs.h
> b/drivers/staging/lustre/lustre/include/linux/lvfs.h
> index b4db6cb..eb59ac7 100644
> --- a/drivers/staging/lustre/lustre/include/linux/lvfs.h
> +++ b/drivers/staging/lustre/lustre/include/linux/lvfs.h
> @@ -99,7 +99,7 @@ static inline void l_dput(struct dentry *de)
>  	if (!de || IS_ERR(de))
>  		return;
>  	//shrink_dcache_parent(de);
> -	LASSERT(d_refcount(de) > 0);
> +	LASSERT(d_count(de) > 0);
>  	dput(de);
>  }
> 
> diff --git a/drivers/staging/lustre/lustre/llite/dcache.c b/drivers/staging/lustre/lustre/llite/dcache.c
> index 7d6abff..ff0d085 100644
> --- a/drivers/staging/lustre/lustre/llite/dcache.c
> +++ b/drivers/staging/lustre/lustre/llite/dcache.c
> @@ -98,7 +98,7 @@ int ll_dcompare(const struct dentry *parent, const struct inode *pinode,
> 
>  	CDEBUG(D_DENTRY, "found name %.*s(%p) flags %#x refc %d\n",
>  	       name->len, name->name, dentry, dentry->d_flags,
> -	       d_refcount(dentry));
> +	       d_count(dentry));
> 
>  	/* mountpoint is always valid */
>  	if (d_mountpoint((struct dentry *)dentry))
> @@ -165,7 +165,7 @@ static int ll_ddelete(const struct dentry *de)
>  	       list_empty(&de->d_subdirs) ? "" : "subdirs");
> 
>  	/* kernel >= 2.6.38 last refcount is decreased after this function. */
> -	LASSERT(d_refcount(de) == 1);
> +	LASSERT(d_count(de) == 1);
> 
>  	/* Disable this piece of code temproarily because this is called
>  	 * inside dcache_lock so it's not appropriate to do lots of work
> @@ -190,7 +190,7 @@ static int ll_set_dd(struct dentry *de)
> 
>  	CDEBUG(D_DENTRY, "ldd on dentry %.*s (%p) parent %p inode %p refc %d\n",
>  		de->d_name.len, de->d_name.name, de, de->d_parent, de->d_inode,
> -		d_refcount(de));
> +		d_count(de));
> 
>  	if (de->d_fsdata == NULL) {
>  		struct ll_dentry_data *lld;
> @@ -540,7 +540,7 @@ out:
>  		CDEBUG(D_DENTRY, "revalidated dentry %.*s (%p) parent %p "
>  		       "inode %p refc %d\n", de->d_name.len,
>  		       de->d_name.name, de, de->d_parent, de->d_inode,
> -		       d_refcount(de));
> +		       d_count(de));
> 
>  		ll_set_lock_data(exp, de->d_inode, it, &bits);
> 
> diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h
> b/drivers/staging/lustre/lustre/llite/llite_internal.h
> index 992cd20..5227c5c 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_internal.h
> +++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
> @@ -1529,12 +1529,12 @@ static inline void d_lustre_invalidate(struct dentry *dentry, int nested)
>  {
>  	CDEBUG(D_DENTRY, "invalidate dentry %.*s (%p) parent %p inode %p "
>  	       "refc %d\n", dentry->d_name.len, dentry->d_name.name, dentry,
> -	       dentry->d_parent, dentry->d_inode, d_refcount(dentry));
> +	       dentry->d_parent, dentry->d_inode, d_count(dentry));
> 
>  	spin_lock_nested(&dentry->d_lock,
>  			 nested ? DENTRY_D_LOCK_NESTED : DENTRY_D_LOCK_NORMAL);
>  	__d_lustre_invalidate(dentry);
> -	if (d_refcount(dentry) == 0)
> +	if (d_count(dentry) == 0)
>  		__d_drop(dentry);
>  	spin_unlock(&dentry->d_lock);
>  }
> diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c
> b/drivers/staging/lustre/lustre/llite/llite_lib.c
> index 2311b20..afae801 100644
> --- a/drivers/staging/lustre/lustre/llite/llite_lib.c
> +++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
> @@ -659,7 +659,7 @@ void lustre_dump_dentry(struct dentry *dentry, int recur)
>  	       " flags=0x%x, fsdata=%p, %d subdirs\n", dentry,
>  	       dentry->d_name.len, dentry->d_name.name,
>  	       dentry->d_parent->d_name.len, dentry->d_parent->d_name.name,
> -	       dentry->d_parent, dentry->d_inode, d_refcount(dentry),
> +	       dentry->d_parent, dentry->d_inode, d_count(dentry),
>  	       dentry->d_flags, dentry->d_fsdata, subdirs);
>  	if (dentry->d_inode != NULL)
>  		ll_dump_inode(dentry->d_inode);
> diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
> index 58d59aa..ff8f63d 100644
> --- a/drivers/staging/lustre/lustre/llite/namei.c
> +++ b/drivers/staging/lustre/lustre/llite/namei.c
> @@ -409,7 +409,7 @@ struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
>  			iput(inode);
>  			CDEBUG(D_DENTRY,
>  			       "Reuse dentry %p inode %p refc %d flags %#x\n",
> -			      new, new->d_inode, d_refcount(new), new->d_flags);
> +			      new, new->d_inode, d_count(new), new->d_flags);
>  			return new;
>  		}
>  	}
> @@ -417,7 +417,7 @@ struct dentry *ll_splice_alias(struct inode *inode, struct dentry *de)
>  	__d_lustre_invalidate(de);
>  	d_add(de, inode);
>  	CDEBUG(D_DENTRY, "Add dentry %p inode %p refc %d flags %#x\n",
> -	       de, de->d_inode, d_refcount(de), de->d_flags);
> +	       de, de->d_inode, d_count(de), de->d_flags);
>  	return de;
>  }
> 
> diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
> b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
> index 1e6f32c..e70d8fe 100644
> --- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
> +++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
> @@ -121,8 +121,8 @@ void push_ctxt(struct lvfs_run_ctxt *save, struct lvfs_run_ctxt *new_ctx,
>  	OBD_SET_CTXT_MAGIC(save);
> 
>  	save->fs = get_fs();
> -	LASSERT(d_refcount(cfs_fs_pwd(current->fs)));
> -	LASSERT(d_refcount(new_ctx->pwd));
> +	LASSERT(d_count(cfs_fs_pwd(current->fs)));
> +	LASSERT(d_count(new_ctx->pwd));
>  	save->pwd = dget(cfs_fs_pwd(current->fs));
>  	save->pwdmnt = mntget(cfs_fs_mnt(current->fs));
>  	save->luc.luc_umask = current_umask();
> --
> 1.7.1
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
