Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580AbaDAMG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:06:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33205 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaDAMGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:06:21 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-dc-533aabba5ee5
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1396353865.12401.2.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 1/2] f2fs: avoid free slab cache under spinlock
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 01 Apr 2014 21:04:25 +0900
In-reply-to: <000001cf4aff$295d4cd0$7c17e670$@samsung.com>
References: <000001cf4aff$295d4cd0$7c17e670$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsVy+t8zI91dq62CDZp/y1r8b/rIZnFpkbvF
	nr0nWSwu75rD5sDisXvBZyaPvi2rGD0+b5ILYI7isklJzcksSy3St0vgyvh4opmtYIFexcUb
	K5gaGFtUuxg5OSQETCR+TJnLBGGLSVy4t56ti5GLQ0hgGaPErO03WGGK2rf8Z4FITGeUaJ59
	lA0kwSsgKPFj8j0WEJtZQF1i0rxFzBC2iMT23c/YIWxtiWULXzNDNL9ilLj1FWIdr4COxMnj
	n8AahAX8JPbvfQlkc3CwATVs3m8AEhYSUJR4u/8u2BEiAkoSv+YvYoWYmSlxr2kGWCuLgKrE
	levLwW7gFLCSOPd6MSNEr6XE7S8Qq/gFRCUOL9zODPGMksTu9k52kHskBI6xSyy4sokRYpCA
	xLfJh1hAbpAQkJXYdACqXlLi4IobLBMYJWcheXkWkpdnIXl5FpKXFzCyrGIUTS1ILihOSi8y
	1CtOzC0uzUvXS87P3cQIidHeHYy3D1gfYkwGWj+RWUo0OR8Y43kl8YbGZkYWpiamxkbmlmak
	CSuJ8yY9TAoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwJimwiRqanTgj8anHQWH3YsWZj/r
	kZBaqLTn6yNZTuUn6+ftrJZglZ3fcNKcoTmBSVLm/63v7jV/Zl8U5fl/1jp4+RWVCvcOi58r
	DbdUBm5oOvgsv/LBdJEavp4Y3Ufr1LODyss0X1x94G9b7Pl0vQzPdzmTPTwPGzQaxIMzH1em
	nb0tIuF7SImlOCPRUIu5qDgRAJrK8CLnAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jQd1dq62CDQ5skrT43/SRzeLSIneL
	PXtPslhc3jWHzYHFY/eCz0wefVtWMXp83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5jR1T6RteCebsW6X63sDYyHVLoYOTkkBEwk2rf8Z4GwxSQu3FvP1sXIxSEk
	MJ1Ronn2UTaQBK+AoMSPyfeAijg4mAXkJY5cygYJMwuoS0yat4gZov4Vo8Str3OZIOp1JE4e
	/8QMYgsL+Ens3/uSGaSXTUBbYvN+A5CwkICixNv9d1lBbBEBJYlf8xexQszMlLjXNAOslUVA
	VeLK9eVgt3EKWEmce72YEaLXUuL2F4hV/AKiEocXbmeGuF9JYnd7J/sERqFZSK6ehXD1LCRX
	L2BkXsUomlqQXFCclJ5rqFecmFtcmpeul5yfu4kRHM3PpHYwrmywOMQowMGoxMMr8dEyWIg1
	say4MvcQowQHs5IIr/UKq2Ah3pTEyqrUovz4otKc1OJDjMlAh09klhJNzgcmmrySeENjEzMj
	SyMzCyMTc3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYAy4p37qc+Jegb2ezFvnxK/V
	EL7v+qNlU+Gpjw/49KMzmMQv9e3grd51s9Hw/geFppADex/Pz1r4yoVpkU7uagPGXv4HN8R2
	Pk1TjoifkjGtyF4hN8766ObW/K39W/VjUxdfnWe0XszU/0bNc2mZkxumLk7h3faZJ8Y0Tl/T
	46WXzeIogc8HriqxFGckGmoxFxUnAgDVBtL6KgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chao,

One minor thing as below.

2014-03-29 (토), 11:29 +0800, Chao Yu:
> Move kmem_cache_free out of spinlock protection region for better performance.
> 
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/checkpoint.c |   27 +++++++++++++++++----------
>  fs/f2fs/node.c       |   15 ++++++++++++++-
>  2 files changed, 31 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index a80be51..d877f46 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -347,10 +347,11 @@ void remove_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  	list_for_each_entry(orphan, head, list) {
>  		if (orphan->ino == ino) {
>  			list_del(&orphan->list);
> -			kmem_cache_free(orphan_entry_slab, orphan);
>  			f2fs_bug_on(sbi->n_orphans == 0);
>  			sbi->n_orphans--;
> -			break;
> +			spin_unlock(&sbi->orphan_inode_lock);
> +			kmem_cache_free(orphan_entry_slab, orphan);
> +			return;
>  		}
>  	}
>  	spin_unlock(&sbi->orphan_inode_lock);
> @@ -577,6 +578,7 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	struct dir_inode_entry *new;
> +	int ret = 0;
>  
>  	if (!S_ISDIR(inode->i_mode))
>  		return;
> @@ -586,12 +588,13 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
>  	INIT_LIST_HEAD(&new->list);
>  
>  	spin_lock(&sbi->dir_inode_lock);
> -	if (__add_dirty_inode(inode, new))
> -		kmem_cache_free(inode_entry_slab, new);
> -
> +	ret = __add_dirty_inode(inode, new);
>  	inode_inc_dirty_dents(inode);
>  	SetPagePrivate(page);
>  	spin_unlock(&sbi->dir_inode_lock);
> +
> +	if (ret)
> +		kmem_cache_free(inode_entry_slab, new);
>  }
>  
>  void add_dirty_dir_inode(struct inode *inode)
> @@ -599,20 +602,22 @@ void add_dirty_dir_inode(struct inode *inode)
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  	struct dir_inode_entry *new =
>  			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> +	int ret = 0;
>  
>  	new->inode = inode;
>  	INIT_LIST_HEAD(&new->list);
>  
>  	spin_lock(&sbi->dir_inode_lock);
> -	if (__add_dirty_inode(inode, new))
> -		kmem_cache_free(inode_entry_slab, new);
> +	ret = __add_dirty_inode(inode, new);
>  	spin_unlock(&sbi->dir_inode_lock);
> +
> +	if (ret)
> +		kmem_cache_free(inode_entry_slab, new);
>  }
>  
>  void remove_dirty_dir_inode(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -
>  	struct list_head *this, *head;
>  
>  	if (!S_ISDIR(inode->i_mode))
> @@ -630,13 +635,15 @@ void remove_dirty_dir_inode(struct inode *inode)
>  		entry = list_entry(this, struct dir_inode_entry, list);
>  		if (entry->inode == inode) {
>  			list_del(&entry->list);
> -			kmem_cache_free(inode_entry_slab, entry);
>  			stat_dec_dirty_dir(sbi);
> -			break;
> +			spin_unlock(&sbi->dir_inode_lock);
> +			kmem_cache_free(inode_entry_slab, entry);
> +			goto done;
>  		}
>  	}
>  	spin_unlock(&sbi->dir_inode_lock);
>  
> +done:
>  	/* Only from the recovery routine */
>  	if (is_inode_flag_set(F2FS_I(inode), FI_DELAY_IPUT)) {
>  		clear_inode_flag(F2FS_I(inode), FI_DELAY_IPUT);
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index eced8d7..0021056 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1314,7 +1314,6 @@ static void __del_from_free_nid_list(struct f2fs_nm_info *nm_i,
>  {
>  	list_del(&i->list);
>  	radix_tree_delete(&nm_i->free_nid_root, i->nid);
> -	kmem_cache_free(free_nid_slab, i);
>  }
>  
>  static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
> @@ -1361,13 +1360,19 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
>  static void remove_free_nid(struct f2fs_nm_info *nm_i, nid_t nid)
>  {
>  	struct free_nid *i;
> +	bool need_free = false;
> +
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	i = __lookup_free_nid_list(nm_i, nid);
>  	if (i && i->state == NID_NEW) {
>  		__del_from_free_nid_list(nm_i, i);
>  		nm_i->fcnt--;
> +		need_free = true;
>  	}
>  	spin_unlock(&nm_i->free_nid_list_lock);
> +
> +	if (need_free)
> +		kmem_cache_free(free_nid_slab, i);
>  }
>  
>  static void scan_nat_page(struct f2fs_nm_info *nm_i,
> @@ -1492,6 +1497,8 @@ void alloc_nid_done(struct f2fs_sb_info *sbi, nid_t nid)
>  	f2fs_bug_on(!i || i->state != NID_ALLOC);
>  	__del_from_free_nid_list(nm_i, i);
>  	spin_unlock(&nm_i->free_nid_list_lock);
> +
> +	kmem_cache_free(free_nid_slab, i);
>  }
>  
>  /*
> @@ -1501,6 +1508,7 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
>  {
>  	struct f2fs_nm_info *nm_i = NM_I(sbi);
>  	struct free_nid *i;
> +	bool need_free = false;
>  
>  	if (!nid)
>  		return;
> @@ -1510,11 +1518,15 @@ void alloc_nid_failed(struct f2fs_sb_info *sbi, nid_t nid)
>  	f2fs_bug_on(!i || i->state != NID_ALLOC);
>  	if (!available_free_memory(nm_i, FREE_NIDS)) {
>  		__del_from_free_nid_list(nm_i, i);
> +		need_free = true;
>  	} else {
>  		i->state = NID_NEW;
>  		nm_i->fcnt++;
>  	}
>  	spin_unlock(&nm_i->free_nid_list_lock);
> +
> +	if (need_free)
> +		kmem_cache_free(free_nid_slab, i);
>  }
>  
>  void recover_node_page(struct f2fs_sb_info *sbi, struct page *page,
> @@ -1926,6 +1938,7 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
>  		f2fs_bug_on(i->state == NID_ALLOC);
>  		__del_from_free_nid_list(nm_i, i);
>  		nm_i->fcnt--;
> +		kmem_cache_free(free_nid_slab, i);

It seems that we need to do this too.

               spin_unlock(&nm_i->free_nid_list_lock);
               kmem_cache_free(free_nid_slab, i);
               spin_lock(&nm_i->free_nid_list_lock);

Right?

>  	}
>  	f2fs_bug_on(nm_i->fcnt);
>  	spin_unlock(&nm_i->free_nid_list_lock);

-- 
Jaegeuk Kim
Samsung

