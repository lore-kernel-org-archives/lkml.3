Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173AbaBXD3p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 22:29:45 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:62314 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaBXD3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 22:29:42 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f266d00000287c-a1-530abca4cfee
Content-transfer-encoding: 8BIT
Message-id: <1393212487.4705.44.camel@kjgkr>
Subject: Re: [RFC PATCH 2/2] f2fs: simplify free nid management
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        fsdevel <linux-fsdevel@vger.kernel.org>
Date: Mon, 24 Feb 2014 12:28:07 +0900
In-reply-to: <530725A5.5010404@cn.fujitsu.com>
References: <530725A5.5010404@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t8zI90le7iCDe68kbZ43n6A2eLSIneL
	PXtPslhc3jWHzYHF4//BScweuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2Pd0mtsBU+zKta3
	/mZsYHwb3MXIySEhYCKxZP9MVghbTOLCvfVsXYxcHEICyxgl+o/NYoYper64ASqxiFFi7YUb
	YB28AoISPybfY+li5OBgFpCXOHIpGyTMLKAuMWneImaI+leMEjsuPWeEqNeRuPHuF5gtLGAv
	8XbfczaQXjYBbYnN+w1AwkICihJv998FGy8ioCbx7N0lJpA5zALdjBI/J81lA0mwCKhK3P7c
	CWZzCuhJtDzfwg7RrCvRcqMTrJlfQFTi8MLtUA8oSexu72QHGSQhcIxd4tXBO0wQgwQkvk0+
	BPaAhICsxKYDUPWSEgdX3GCZwCgxC8mbsxDenIXkzQWMzKsYRVMLkguKk9KLTPSKE3OLS/PS
	9ZLzczcxQiJuwg7GewesDzEmA22cyCwlmpwPjNi8knhDYzMjC1MTU2Mjc0sz0oSVxHnVHiUF
	CQmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamDkv9x3pTPzsojsw5hFxR06K79z/ZywXDIn6uKk
	qYXSuZuqlVLWf+Zj3vTvlslj4co2cUe2+7Vpxxj6GXYv0GP4IrD42nnH62umqEisvRxt9kL+
	+JMZHpI1KR9Y3XU01Q5eWxK2L8vH1nnGP6usEJMjNhYs02bniEorrPpwtuV/rE5S2g6J6iQl
	luKMREMt5qLiRAAa3agDzgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprBKsWRmVeSWpSXmKPExsVy+t9jAd0le7iCDfZsELN43n6A2eLSIneL
	PXtPslhc3jWHzYHF4//BScweuxd8ZvL4vEkugDmqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON45
	3tTMwFDX0NLCXEkhLzE31VbJxSdA1y0zB2ibkkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3f
	kCC4HiMDNJCwjjFj3dJrbAVPsyrWt/5mbGB8G9zFyMkhIWAi8XxxAxuELSZx4d56IJuLQ0hg
	EaPE2gs3WEESvAKCEj8m32PpYuTgYBaQlzhyKRskzCygLjFp3iJmiPpXjBI7Lj1nhKjXkbjx
	7heYLSxgL/F233M2kF42AW2JzfsNQMJCAooSb/ffBRsvIqAm8ezdJSaQOcwC3YwSPyfNBTuI
	RUBV4vbnTjCbU0BPouX5FnaIZl2JlhudYM38AqIShxduZ4Z4QElid3sn+wRGoVlIzp6FcPYs
	JGcvYGRexSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREcz8+kdzCuarA4xCjAwajEwytRzRUs
	xJpYVlyZe4hRgoNZSYS3pgwoxJuSWFmVWpQfX1Sak1p8iDEZ6PCJzFKiyfnAVJNXEm9obGJm
	ZGlkZmFkYm5OmrCSOO/BVutAIYH0xJLU7NTUgtQimC1MHJxSDYxeDW6CH/P91WRWaJ962FB/
	kf8ab5BGfsrUS/WLcsL2qy4UObVdvnCn7bP161e+0Dq7S9np3cG9B/53P4vaECDpLbKqrd5k
	u8rued8OzNrhv2tZCg//vUOl2826RWum8zpVuc8J0gwteze9ri3o5SdOnWjpC8cu7+SL3Wfm
	UDqp/XzR5Pvi9hlKLMUZiYZazEXFiQAuZKA9KwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

The reason why I added the state of free nids was to avoid race
conditions.

[Without state transition]
Thread 1:                        Thread 2:
alloc_nid()
 -> get a free nid : X           alloc_nid()
 -> remove X from the list
                                 -> no free nids
                                 build_free_nids()
                                 -> add X into the list

--> X can be used by different two nodes, so I remained the allocated
nid, X, in the free nid list not to be added during build_free_nids().

Thanks,


2014-02-21 (금), 18:08 +0800, Gu Zheng:
> Previously, in the free nid management, we use two states to describe the state
> of a free nid entry:
> NID_NEW		/* newly added to free nid list */
> NID_ALLOC	/* it is allocated, but not really used*/
> When we alloc a new nid from free nid list,
> we just change the state from *NID_NEW* to *NID_ALLOC* and reduce the free nid
> count before complete success(nid_alloc).
> If we success finally, remove the nid entry from the free nid list(alloc_nid_done),
> else change the nid entry state to *NID_NEW* and increase the free nid count(alloc_nid_failed).
> As you know, the above three functions need to take free_nid_list_lock when search
> or remove the free nid entry.
> In the success path, we need to take free_nid_list_lock twice, one for finding
> and changing state, the other for removing the entry.
> And in the fail path, we need to take free_nid_list_lock twice too, one for finding
> and changing state, the other for finding and changing back the state.
> So you can see, the disign is not friendly to the success case, but to the fail
> case. And success case is more common than the fail case.
> So we simplify the free nid management to the following:
> Removed the nid entry state management.
> Removed the alloc nid done.
> alloc_nid will find a free nid and delete the entry from the free nid entry list.
> alloc_nid_faild will put back the free nid into the free nid entry list.
> With the above simplification, the success case will more neat, though the fail
> case will be a bit heavy.
> Besides, it also rename the function name for better descriptive.
> alloc_nid-->get_free_nid
> alloc_nid_failed-->put_back_free_nid
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/f2fs.h  |    5 +--
>  fs/f2fs/namei.c |   18 +++++----------
>  fs/f2fs/node.c  |   62 +++++++++++++++++++-----------------------------------
>  fs/f2fs/node.h  |    9 --------
>  fs/f2fs/xattr.c |   11 ++++-----
>  5 files changed, 35 insertions(+), 70 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 8cc7166..7fb6a83 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -1129,9 +1129,8 @@ struct page *get_node_page(struct f2fs_sb_info *, pgoff_t);
>  struct page *get_node_page_ra(struct page *, int);
>  void sync_inode_page(struct dnode_of_data *);
>  int sync_node_pages(struct f2fs_sb_info *, nid_t, struct writeback_control *);
> -bool alloc_nid(struct f2fs_sb_info *, nid_t *);
> -void alloc_nid_done(struct f2fs_sb_info *, nid_t);
> -void alloc_nid_failed(struct f2fs_sb_info *, nid_t);
> +bool get_free_nid(struct f2fs_sb_info *, nid_t *);
> +void put_back_free_nid(struct f2fs_sb_info *, nid_t);
>  void recover_node_page(struct f2fs_sb_info *, struct page *,
>  		struct f2fs_summary *, struct node_info *, block_t);
>  bool recover_xattr_data(struct inode *, struct page *, block_t);
> diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
> index 397d459..df956e9 100644
> --- a/fs/f2fs/namei.c
> +++ b/fs/f2fs/namei.c
> @@ -34,7 +34,7 @@ static struct inode *f2fs_new_inode(struct inode *dir, umode_t mode)
>  		return ERR_PTR(-ENOMEM);
>  
>  	f2fs_lock_op(sbi);
> -	if (!alloc_nid(sbi, &ino)) {
> +	if (!get_free_nid(sbi, &ino)) {
>  		f2fs_unlock_op(sbi);
>  		err = -ENOSPC;
>  		goto fail;
> @@ -75,7 +75,7 @@ fail:
>  	make_bad_inode(inode);
>  	iput(inode);
>  	if (nid_free)
> -		alloc_nid_failed(sbi, ino);
> +		put_back_free_nid(sbi, ino);
>  	return ERR_PTR(err);
>  }
>  
> @@ -137,8 +137,6 @@ static int f2fs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
>  	if (err)
>  		goto out;
>  
> -	alloc_nid_done(sbi, ino);
> -
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  	return 0;
> @@ -147,7 +145,7 @@ out:
>  	unlock_new_inode(inode);
>  	make_bad_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, ino);
> +	put_back_free_nid(sbi, ino);
>  	return err;
>  }
>  
> @@ -271,7 +269,6 @@ static int f2fs_symlink(struct inode *dir, struct dentry *dentry,
>  		goto out;
>  
>  	err = page_symlink(inode, symname, symlen);
> -	alloc_nid_done(sbi, inode->i_ino);
>  
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
> @@ -281,7 +278,7 @@ out:
>  	unlock_new_inode(inode);
>  	make_bad_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, inode->i_ino);
> +	put_back_free_nid(sbi, inode->i_ino);
>  	return err;
>  }
>  
> @@ -309,8 +306,6 @@ static int f2fs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode)
>  	if (err)
>  		goto out_fail;
>  
> -	alloc_nid_done(sbi, inode->i_ino);
> -
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  
> @@ -322,7 +317,7 @@ out_fail:
>  	unlock_new_inode(inode);
>  	make_bad_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, inode->i_ino);
> +	put_back_free_nid(sbi, inode->i_ino);
>  	return err;
>  }
>  
> @@ -360,7 +355,6 @@ static int f2fs_mknod(struct inode *dir, struct dentry *dentry,
>  	if (err)
>  		goto out;
>  
> -	alloc_nid_done(sbi, inode->i_ino);
>  	d_instantiate(dentry, inode);
>  	unlock_new_inode(inode);
>  	return 0;
> @@ -369,7 +363,7 @@ out:
>  	unlock_new_inode(inode);
>  	make_bad_inode(inode);
>  	iput(inode);
> -	alloc_nid_failed(sbi, inode->i_ino);
> +	put_back_free_nid(sbi, inode->i_ino);
>  	return err;
>  }
>  
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 8c5981e..7dc3246 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -396,7 +396,7 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
>  
>  		if (!nids[i] && mode == ALLOC_NODE) {
>  			/* alloc new node */
> -			if (!alloc_nid(sbi, &(nids[i]))) {
> +			if (!get_free_nid(sbi, &(nids[i]))) {
>  				err = -ENOSPC;
>  				goto release_pages;
>  			}
> @@ -404,13 +404,12 @@ int get_dnode_of_data(struct dnode_of_data *dn, pgoff_t index, int mode)
>  			dn->nid = nids[i];
>  			npage[i] = new_node_page(dn, noffset[i], NULL);
>  			if (IS_ERR(npage[i])) {
> -				alloc_nid_failed(sbi, nids[i]);
> +				put_back_free_nid(sbi, nids[i]);
>  				err = PTR_ERR(npage[i]);
>  				goto release_pages;
>  			}
>  
>  			set_nid(parent, offset[i - 1], nids[i], i == 1);
> -			alloc_nid_done(sbi, nids[i]);
>  			done = true;
>  		} else if (mode == LOOKUP_NODE_RA && i == level && level > 1) {
>  			npage[i] = get_node_page_ra(parent, offset[i - 1]);
> @@ -1317,7 +1316,6 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
>  
>  	i = f2fs_kmem_cache_alloc(free_nid_slab, GFP_NOFS);
>  	i->nid = nid;
> -	i->state = NID_NEW;
>  
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	if (__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
> @@ -1334,9 +1332,10 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
>  static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
>  {
>  	struct free_nid *i;
> +
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
> -	if (i && i->state == NID_NEW) {
> +	if (i) {
>  		__del_from_free_nid_list(i);
>  		nm_i->fcnt--;
>  	}
> @@ -1416,11 +1415,10 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
>   * from second parameter of this function.
>   * The returned nid could be used ino as well as nid when inode is created.
>   */
> -bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
> +bool get_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
>  {
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct free_nid *i = NULL;
> -	struct list_head *this;
>  retry:
>  	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->max_nid))
>  		return false;
> @@ -1430,16 +1428,12 @@ retry:
>  	/* We should not use stale free nids created by build_free_nids */
>  	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
>  		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
> -		list_for_each(this, &nm_i->free_nid_list) {
> -			i = list_entry(this, struct free_nid, list);
> -			if (i->state == NID_NEW)
> -				break;
> -		}
>  
> -		f2fs_bug_on(i->state != NID_NEW);
> +		i = list_first_entry(&nm_i->free_nid_list,
> +						struct free_nid, list);
>  		*nid = i->nid;
> -		i->state = NID_ALLOC;
>  		nm_i->fcnt--;
> +		__del_from_free_nid_list(i);
>  		spin_unlock(&nm_i->free_nid_list_lock);
>  		return true;
>  	}
> @@ -1453,40 +1447,29 @@ retry:
>  }
>  
>  /*
> - * alloc_nid() should be called prior to this function.
> + * get_free_nid() should be called prior to this function.
>   */
> -void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
> +void put_back_free_nid(struct f2fs_sb_info *sbi, nid_t nid)
>  {
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
> -	struct free_nid *i;
> -
> -	spin_lock(&nm_i->free_nid_list_lock);
> -	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
> -	f2fs_bug_on(!i || i->state != NID_ALLOC);
> -	__del_from_free_nid_list(i);
> -	spin_unlock(&nm_i->free_nid_list_lock);
> -}
> -
> -/*
> - * alloc_nid() should be called prior to this function.
> - */
> -void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
> -{
> -	struct f2fs_nm_info *nm_i = NM_I(sbi);
> -	struct free_nid *i;
> +	struct free_nid *unused_nid;
>  
>  	if (!nid)
>  		return;
>  
> +	unused_nid = f2fs_kmem_cache_alloc(free_nid_slab, GFP_NOFS);
> +	unused_nid->nid = nid;
> +
>  	spin_lock(&nm_i->free_nid_list_lock);
> -	i = __lookup_free_nid_list(nid, &nm_i->free_nid_list);
> -	f2fs_bug_on(!i || i->state != NID_ALLOC);
> -	if (nm_i->fcnt > 2 * MAX_FREE_NIDS) {
> -		__del_from_free_nid_list(i);
> -	} else {
> -		i->state = NID_NEW;
> -		nm_i->fcnt++;
> +
> +	if (nm_i->fcnt > 2 * MAX_FREE_NIDS ||
> +			__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
> +		spin_unlock(&nm_i->free_nid_list_lock);
> +		kmem_cache_free(free_nid_slab, unused_nid);
> +		return;
>  	}
> +	list_add_tail(&unused_nid->list, &nm_i->free_nid_list);
> +	nm_i->fcnt++;
>  	spin_unlock(&nm_i->free_nid_list_lock);
>  }
>  
> @@ -1869,7 +1852,6 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
>  	/* destroy free nid list */
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	list_for_each_entry_safe(i, next_i, &nm_i->free_nid_list, list) {
> -		f2fs_bug_on(i->state == NID_ALLOC);
>  		__del_from_free_nid_list(i);
>  		nm_i->fcnt--;
>  	}
> diff --git a/fs/f2fs/node.h b/fs/f2fs/node.h
> index c4c7988..89221af 100644
> --- a/fs/f2fs/node.h
> +++ b/fs/f2fs/node.h
> @@ -71,18 +71,9 @@ static inline void node_info_from_raw_nat(struct node_info *ni,
>  	ni->version = raw_ne->version;
>  }
>  
> -/*
> - * For free nid mangement
> - */
> -enum nid_state {
> -	NID_NEW,	/* newly added to free nid list */
> -	NID_ALLOC	/* it is allocated */
> -};
> -
>  struct free_nid {
>  	struct list_head list;	/* for free node id list */
>  	nid_t nid;		/* node id */
> -	int state;		/* in use or not: NID_NEW or NID_ALLOC */
>  };
>  
>  static inline int next_free_nid(struct f2fs_sb_info *sbi, nid_t *nid)
> diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
> index 89d0422..9f9741e 100644
> --- a/fs/f2fs/xattr.c
> +++ b/fs/f2fs/xattr.c
> @@ -337,7 +337,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
>  	inline_size = inline_xattr_size(inode);
>  
>  	if (hsize > inline_size && !F2FS_I(inode)->i_xattr_nid)
> -		if (!alloc_nid(sbi, &new_nid))
> +		if (!get_free_nid(sbi, &new_nid))
>  			return -ENOSPC;
>  
>  	/* write to inline xattr */
> @@ -350,7 +350,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
>  		} else {
>  			page = get_node_page(sbi, inode->i_ino);
>  			if (IS_ERR(page)) {
> -				alloc_nid_failed(sbi, new_nid);
> +				put_back_free_nid(sbi, new_nid);
>  				return PTR_ERR(page);
>  			}
>  			inline_addr = inline_xattr_addr(page);
> @@ -361,7 +361,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
>  		/* no need to use xattr node block */
>  		if (hsize <= inline_size) {
>  			err = truncate_xattr_node(inode, ipage);
> -			alloc_nid_failed(sbi, new_nid);
> +			put_back_free_nid(sbi, new_nid);
>  			return err;
>  		}
>  	}
> @@ -370,7 +370,7 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
>  	if (F2FS_I(inode)->i_xattr_nid) {
>  		xpage = get_node_page(sbi, F2FS_I(inode)->i_xattr_nid);
>  		if (IS_ERR(xpage)) {
> -			alloc_nid_failed(sbi, new_nid);
> +			put_back_free_nid(sbi, new_nid);
>  			return PTR_ERR(xpage);
>  		}
>  		f2fs_bug_on(new_nid);
> @@ -379,10 +379,9 @@ static inline int write_all_xattrs(struct inode *inode, __u32 hsize,
>  		set_new_dnode(&dn, inode, NULL, NULL, new_nid);
>  		xpage = new_node_page(&dn, XATTR_NODE_OFFSET, ipage);
>  		if (IS_ERR(xpage)) {
> -			alloc_nid_failed(sbi, new_nid);
> +			put_back_free_nid(sbi, new_nid);
>  			return PTR_ERR(xpage);
>  		}
> -		alloc_nid_done(sbi, new_nid);
>  	}
>  
>  	xattr_addr = page_address(xpage);

-- 
Jaegeuk Kim
Samsung

