Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752928Ab3JVMam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:30:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:40026 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab3JVMak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:30:40 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f836d000001b39-f1-52666feeb0ad
Content-transfer-encoding: 8BIT
Message-id: <1382445005.992.70.camel@kjgkr>
Subject: Re: [PATCH V2] f2fs: introduce f2fs_kmem_cache_alloc to hide the
 unfailed, kmem cache allocation
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Haicheng Li <haicheng.li@linux.intel.com>
Date: Tue, 22 Oct 2013 21:30:05 +0900
In-reply-to: <526620AA.60007@cn.fujitsu.com>
References: <526620AA.60007@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrPIsWRmVeSWpSXmKPExsVy+t8zA913+WlBBlfmmVu8PKRpsWjTdiaL
	5+0HmC3OPOtgtLi0yN1iz96TLBaXd81hc2D3+H9wErPHvJOBHrsXfGby6NuyitHj8ya5ANYo
	LpuU1JzMstQifbsEroyPM14yFzxSqXj5ei1rA+MLmS5GTg4JAROJKdePsEDYYhIX7q1n62Lk
	4hASWMYosa5xAhtM0YwHrcwQiemMEreufmIFSfAKCEr8mHwPqJuDg1lAXuLIpWyQMLOAusSk
	eYug6l8xSrQc2MsGUa8tsfvCfjaQemGBbIlfB7lATDag8Ob9BiAVQgKKEm/33wWbLiKgJvHs
	3SUmkDHMArcZJZY9XATUys7BIqAqcUodpIRTQEfizLFrjBCt2hJrD7Yzgdj8AqIShxduZ4a4
	Xklid3snO8gYCYG37BLt+y6C/csiICDxbfIhsOslBGQlNh2AqpeUOLjiBssERolZSH6chfDj
	LCQ/LmBkXsUomlqQXFCclF5krFecmFtcmpeul5yfu4kREpn9OxjvHrA+xJgMtHEis5Rocj4w
	svNK4g2NzYwsTE1MjY3MLc1IE1YS573/MClISCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA+OU
	ummmtcW/RXlbt9x+6xP8RyznzL4Lpa+TOPwZ2jNiVYS93r+bNVM9o37G8p+/Y6M4Aq2/ftti
	vetV7bWdy4I++BR/SttdoXaK2dp/cqzwv39vTvwLN7q87ED2s/d3Q56HnTwglXjo3czwl6X/
	XU9PPcg/TdjofbzRk8Mrnpzr9DdNPq7dtsNViaU4I9FQi7moOBEA0qbuo+ICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDKsWRmVeSWpSXmKPExsVy+t9jQd13+WlBBqv/GFq8PKRpsWjTdiaL
	5+0HmC3OPOtgtLi0yN1iz96TLBaXd81hc2D3+H9wErPHvJOBHrsXfGby6NuyitHj8ya5ANao
	BkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKAjlBTK
	EnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZH2e8ZC54pFLx8vVa1gbGFzJd
	jJwcEgImEjMetDJD2GISF+6tZ+ti5OIQEpjOKHHr6idWkASvgKDEj8n3WLoYOTiYBeQljlzK
	BgkzC6hLTJq3iBmi/hWjRMuBvWwQ9doSuy/sZwOpFxbIlvh1kAvEZAMKb95vAFIhJKAo8Xb/
	XbDpIgJqEs/eXWICGcMscJtRYtnDRUCt7BwsAqoSp9RBSjgFdCTOHLvGCNGqLbH2YDsTiM0v
	ICpxeOF2qOuVJHa3d7JPYBSaheTmWQg3z0Jy8wJG5lWMoqkFyQXFSem5hnrFibnFpXnpesn5
	uZsYwXH/TGoH48oGi0OMAhyMSjy8GVapQUKsiWXFlbmHGCU4mJVEeJt904KEeFMSK6tSi/Lj
	i0pzUosPMSYDnT2RWUo0OR+YkvJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpa
	kFoEs4WJg1OqgVFwqUzjOu4FlzRZm/b+flyv9f15VsTq3ZGii38+vzAv13HLLLlKtivV9isf
	94Qamypqbv+jWSktzqxy7WOt3o/fdrsPtk3f7aBbduT+ffajB4LO6ev99Ba/tlTrxNo/m28V
	GXWIdJzj9Q39ccD0+HzzqR3NW4w1uebc+hAoavFlQ7p4gY2oUKgSS3FGoqEWc1FxIgBhGoeV
	PwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Looks good to me.

Thanks,

2013-10-22 (화), 14:52 +0800, Gu Zheng:
> Introduce the unfailed version of kmem_cache_alloc named f2fs_kmem_cache_alloc
> to hide the retry routine and make the code a bit cleaner.
> 
> v2:
>    Fix the wrong use of 'retry' tag pointed out by Gao feng.
>    Use more neat code to remove redundant tag suggested by Haicheng Li.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/checkpoint.c |   26 +++++++-------------------
>  fs/f2fs/f2fs.h       |   15 +++++++++++++++
>  fs/f2fs/gc.c         |    8 ++------
>  fs/f2fs/node.c       |   27 +++++++++++----------------
>  4 files changed, 35 insertions(+), 41 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 8d16071..6fb484c 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -226,12 +226,8 @@ void add_orphan_inode(struct f2fs_sb_info *sbi, nid_t ino)
>  			break;
>  		orphan = NULL;
>  	}
> -retry:
> -	new = kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
> -	if (!new) {
> -		cond_resched();
> -		goto retry;
> -	}
> +
> +	new = f2fs_kmem_cache_alloc(orphan_entry_slab, GFP_ATOMIC);
>  	new->ino = ino;
>  
>  	/* add new_oentry into list which is sorted by inode number */
> @@ -484,12 +480,8 @@ void set_dirty_dir_page(struct inode *inode, struct page *page)
>  
>  	if (!S_ISDIR(inode->i_mode))
>  		return;
> -retry:
> -	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> -	if (!new) {
> -		cond_resched();
> -		goto retry;
> -	}
> +
> +	new = f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
>  	new->inode = inode;
>  	INIT_LIST_HEAD(&new->list);
>  
> @@ -506,13 +498,9 @@ retry:
>  void add_dirty_dir_inode(struct inode *inode)
>  {
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> -	struct dir_inode_entry *new;
> -retry:
> -	new = kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> -	if (!new) {
> -		cond_resched();
> -		goto retry;
> -	}
> +	struct dir_inode_entry *new =
> +			f2fs_kmem_cache_alloc(inode_entry_slab, GFP_NOFS);
> +
>  	new->inode = inode;
>  	INIT_LIST_HEAD(&new->list);
>  
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 171c52f..2949275 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -18,6 +18,7 @@
>  #include <linux/crc32.h>
>  #include <linux/magic.h>
>  #include <linux/kobject.h>
> +#include <linux/sched.h>
>  
>  /*
>   * For mount options
> @@ -787,6 +788,20 @@ static inline struct kmem_cache *f2fs_kmem_cache_create(const char *name,
>  	return kmem_cache_create(name, size, 0, SLAB_RECLAIM_ACCOUNT, ctor);
>  }
>  
> +static inline void *f2fs_kmem_cache_alloc(struct kmem_cache *cachep,
> +						gfp_t flags)
> +{
> +	void *entry;
> +retry:
> +	entry = kmem_cache_alloc(cachep, flags);
> +	if (!entry) {
> +		cond_resched();
> +		goto retry;
> +	}
> +
> +	return entry;
> +}
> +
>  #define RAW_IS_INODE(p)	((p)->footer.nid == (p)->footer.ino)
>  
>  static inline bool IS_INODE(struct page *page)
> diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
> index fbad968..7914b92 100644
> --- a/fs/f2fs/gc.c
> +++ b/fs/f2fs/gc.c
> @@ -361,12 +361,8 @@ static void add_gc_inode(struct inode *inode, struct list_head *ilist)
>  		iput(inode);
>  		return;
>  	}
> -repeat:
> -	new_ie = kmem_cache_alloc(winode_slab, GFP_NOFS);
> -	if (!new_ie) {
> -		cond_resched();
> -		goto repeat;
> -	}
> +
> +	new_ie = f2fs_kmem_cache_alloc(winode_slab, GFP_NOFS);
>  	new_ie->inode = inode;
>  	list_add_tail(&new_ie->list, ilist);
>  }
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index ef80f79..4fa3fd5 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1296,23 +1296,18 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
>  	if (nid == 0)
>  		return 0;
>  
> -	if (!build)
> -		goto retry;
> -
> -	/* do not add allocated nids */
> -	read_lock(&nm_i->nat_tree_lock);
> -	ne = __lookup_nat_cache(nm_i, nid);
> -	if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
> -		allocated = true;
> -	read_unlock(&nm_i->nat_tree_lock);
> -	if (allocated)
> -		return 0;
> -retry:
> -	i = kmem_cache_alloc(free_nid_slab, GFP_NOFS);
> -	if (!i) {
> -		cond_resched();
> -		goto retry;
> +	if (build) {
> +		/* do not add allocated nids */
> +		read_lock(&nm_i->nat_tree_lock);
> +		ne = __lookup_nat_cache(nm_i, nid);
> +		if (ne && nat_get_blkaddr(ne) != NULL_ADDR)
> +			allocated = true;
> +		read_unlock(&nm_i->nat_tree_lock);
> +		if (allocated)
> +			return 0;
>  	}
> +
> +	i = f2fs_kmem_cache_alloc(free_nid_slab, GFP_NOFS);
>  	i->nid = nid;
>  	i->state = NID_NEW;
>  

-- 
Jaegeuk Kim
Samsung

