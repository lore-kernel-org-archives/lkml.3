Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbbAUW0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 17:26:50 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:45098 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751751AbbAUW0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 17:26:43 -0500
X-AuditID: cbfee691-f79b86d000004a5a-0d-54c027a1c84b
Date: Thu, 22 Jan 2015 07:25:30 +0900
From: Changman Lee <cm224.lee@samsung.com>
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Changman Lee'" <cm224.lee@gmail.com>,
        "'Jaegeuk Kim'" <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree
 extent cache
Message-id: <20150121222530.GA20106@lcm>
References: <000a01d02e37$8e245890$aa6d09b0$@samsung.com>
 <CAN863PvqoS4EpUJRLYxhra6ZyUG6ATMSGnJh_NNj_QpznUuu6Q@mail.gmail.com>
 <00a501d03556$2a882750$7f9875f0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
In-reply-to: <00a501d03556$2a882750$7f9875f0$@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNIsWRmVeSWpSXmKPExsVy+t8zA92F6gdCDM6cYrH43/SRzeJMTzeb
	xZP1s5gtLi1yt7i8aw6bA6vHzll32T02repk89i94DOTR9+WVYwenzfJBbBGcdmkpOZklqUW
	6dslcGV0ztjOWvDdvuL+j+9sDYw7tLsYOTkkBEwkdr86ywZhi0lcuLceyObiEBJYxijxqbmF
	Gabo74NFjBCJ6YwSJ542MUE4Pxkl/n27zwRSxSKgKvFi3gSwDjYBLYn202tZQGwRASWJX/MX
	sYI0MAtMYZRom7ccLCEsECPxZ/1zsAZeAQ2JhYuWQe3ewChxffUEJoiEoMSPyffAGpiBpq7f
	eZwJwpaWePR3BjuIzSlgJfG/vRdskKiAisSUk9vABkkI7GOX2NL8iBXiPAGJb5MPAQ3iAErI
	Smw6APWbpMTBFTdYJjCKzUKybhaSdbOQrFvAyLyKUTS1ILmgOCm9yFSvODG3uDQvXS85P3cT
	IyTOJu5gvH/A+hCjAAejEg/vC8X9IUKsiWXFlbmHGE2BrpjILCWanA+M5rySeENjMyMLUxNT
	YyNzSzMlcV4d6Z/BQgLpiSWp2ampBalF8UWlOanFhxiZODilGhiPGeaw37zK9MzO3v+eje6L
	lHcerXfK33162qW5Z7ZNr87bmD6RE6sSLjzwXBNyNpBv6n/+8Hj3jfITNpnN/x3G2Lhj1snS
	x0yBuaZuxqntHjaPtvts+PnDk3G1zKzaA8uKtN+b5q046bTKlYNTdbre05/RK5ZZ3hRnKlas
	j3teWqk31ePGvmNKLMUZiYZazEXFiQAVCPynrgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKIsWRmVeSWpSXmKPExsVy+t9jQd0F6gdCDO7+trH43/SRzeJMTzeb
	xZP1s5gtLi1yt7i8aw6bA6vHzll32T02repk89i94DOTR9+WVYwenzfJBbBGNTDaZKQmpqQW
	KaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE6Lpl5gAtV1IoS8wpBQoFJBYX
	K+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmdM7Yzlrw3b7i/o/vbA2MO7S7GDk5JARMJP4+
	WMQIYYtJXLi3nq2LkYtDSGA6o8SJp01MEM5PRol/3+4zgVSxCKhKvJg3gRnEZhPQkmg/vZYF
	xBYRUJL4NX8RK0gDs8AURom2ecvBEsICMRJ/1j8Ha+AV0JBYuGgZ1IoNjBLXV09ggkgISvyY
	fA+sgRlo6vqdx5kgbGmJR39nsIPYnAJWEv/be8EGiQqoSEw5uY1tAqPALCTts5C0z0LSvoCR
	eRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcBQ/k9rBuLLB4hCjAAejEg/vC8X9IUKsiWXF
	lbmHGCU4mJVEeKcpHwgR4k1JrKxKLcqPLyrNSS0+xGgKDI+JzFKiyfnABJNXEm9obGJmZGlk
	ZmFkYm6uJM6rZN8WIiSQnliSmp2aWpBaBNPHxMEp1cAoZpaX/ebEofWPZZddNk+XiZv8Z5mV
	geGvNzuXfeQIfDoz8sOnvWtNfjomBBpfdBS9l1iXXmJtfP2vGcev0AdHU5SOt0c5f2tY2C88
	t0U0T+d66BvNiOX3zz1on3Qz+vMq9an+vNq1qzkjyy3LOI8qzbGT/H1f/vqefUxvP0VnsZWc
	bj7wq/uKEktxRqKhFnNRcSIAF1+DZvgCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 04:41:17PM +0800, Chao Yu wrote:
> Hi Changman,
> 
> > -----Original Message-----
> > From: Changman Lee [mailto:cm224.lee@gmail.com]
> > Sent: Tuesday, January 20, 2015 11:06 PM
> > To: Chao Yu
> > Cc: Jaegeuk Kim; Changman Lee; linux-f2fs-devel@lists.sourceforge.net;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [f2fs-dev][RFC PATCH 06/10] f2fs: add core functions for rb-tree extent cache
> > 
> > Hi Chao,
> > 
> > Great works. :)
> 
> Thanks! :)
> 
> > 
> > 2015-01-12 16:14 GMT+09:00 Chao Yu <chao2.yu@samsung.com>:
> > > This patch adds core functions including slab cache init function and
> > > init/lookup/update/shrink/destroy function for rb-tree based extent cache.
> > >
> > > Thank Jaegeuk Kim and Changman Lee as they gave much suggestion about detail
> > > design and implementation of extent cache.
> > >
> > > Todo:
> > >  * add a cached_ei into struct extent_tree for a quick recent cache.
> > >  * register rb-based extent cache shrink with mm shrink interface.
> > >  * disable dir inode's extent cache.
> > >
> > > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > > Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> > > Signed-off-by: Changman Lee <cm224.lee@samsung.com>
> 
> If you do not object, I'd like to keep this as lots of details and ideas are from
> you and Jaegeuk.
> 

I have no objection.

> > > ---
> > >  fs/f2fs/data.c | 458 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> > >  fs/f2fs/node.c |   9 +-
> > >  2 files changed, 466 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> > > index 4f5b871e..bf8c5eb 100644
> > > --- a/fs/f2fs/data.c
> > > +++ b/fs/f2fs/data.c
> > > @@ -25,6 +25,9 @@
> > >  #include "trace.h"
> > >  #include <trace/events/f2fs.h>
> > >
> > 
> > ~ snip ~
> > 
> > > +
> > > +static void f2fs_update_extent_tree(struct inode *inode, pgoff_t fofs,
> > > +                                                       block_t blkaddr)
> > > +{
> > > +       struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
> > > +       nid_t ino = inode->i_ino;
> > > +       struct extent_tree *et;
> > > +       struct extent_node *en = NULL, *en1 = NULL, *en2 = NULL, *en3 = NULL;
> > > +       struct extent_node *den = NULL;
> > > +       struct extent_info *pei;
> > > +       struct extent_info ei;
> > > +       unsigned int endofs;
> > > +
> > > +       if (is_inode_flag_set(F2FS_I(inode), FI_NO_EXTENT))
> > > +               return;
> > > +
> > > +retry:
> > > +       down_write(&sbi->extent_tree_lock);
> > > +       et = radix_tree_lookup(&sbi->extent_tree_root, ino);
> > > +       if (!et) {
> > 
> > We've already made some useful functions.
> > How about using f2fs_kmem_cache_alloc and f2fs_radix_tree_insert ?
> 
> IMO, we'd better to use original function kmem_cache_alloc and radix_tree_insert,
> because if we use f2fs_{kmem_cache_alloc, radix_tree_insert}, we may loop in these
> functions without releasing extent_tree_lock lock when OOM, so it will block lock
> grabbers for long time which we do not wish to see.
> 

I see. If so, let's use cond_resched() in front of goto retry after
up_write. And also look into kmem_cache_alloc in __insert_extent_tree, please.

> > 
> > > +               et = kmem_cache_alloc(extent_tree_slab, GFP_ATOMIC);
> > > +               if (!et) {
> > > +                       up_write(&sbi->extent_tree_lock);
> > > +                       goto retry;
> > > +               }
> > > +               if (radix_tree_insert(&sbi->extent_tree_root, ino, et)) {
> > > +                       up_write(&sbi->extent_tree_lock);
> > > +                       kmem_cache_free(extent_tree_slab, et);
> > > +                       goto retry;
> > > +               }
> > > +               memset(et, 0, sizeof(struct extent_tree));
> > > +               et->ino = ino;
> > > +               et->root = RB_ROOT;
> > > +               rwlock_init(&et->lock);
> > > +               atomic_set(&et->refcount, 0);
> > > +               et->count = 0;
> > > +               sbi->total_ext_tree++;
> > > +       }
> > > +       atomic_inc(&et->refcount);
> > > +       up_write(&sbi->extent_tree_lock);
> > > +
> > 
> > ~ snip ~
> > 
> > > +
> > > +       write_unlock(&et->lock);
> > > +       atomic_dec(&et->refcount);
> > > +}
> > > +
> > > +void f2fs_shrink_extent_tree(struct f2fs_sb_info *sbi, int nr_shrink)
> > > +{
> > > +       struct extent_tree *treevec[EXT_TREE_VEC_SIZE];
> > > +       struct extent_node *en, *tmp;
> > > +       unsigned long ino = F2FS_ROOT_INO(sbi);
> > > +       struct radix_tree_iter iter;
> > > +       void **slot;
> > > +       unsigned int found;
> > > +       unsigned int node_cnt = 0, tree_cnt = 0;
> > > +
> > > +       if (available_free_memory(sbi, EXTENT_CACHE))
> > > +               return;
> > > +
> > > +       spin_lock(&sbi->extent_lock);
> > > +       list_for_each_entry_safe(en, tmp, &sbi->extent_list, list) {
> > > +               if (!nr_shrink--)
> > > +                       break;
> > > +               list_del_init(&en->list);
> > > +       }
> > > +       spin_unlock(&sbi->extent_lock);
> > > +
> > 
> > IMHO, it's expensive to retrieve all extent_tree to free extent_node
> > that list_empty() is true.
> 
> Yes, it will cause heavy overhead to release extent_node in extent cache
> which has huge number of extent_node.
> 
> > Is there any idea to improve this?
> > For example, if each extent_node has its extent_root, it would be more
> > fast by not to retrieve all trees.
> > Of course, however, it uses more memory.
> 
> I think your solution is a good way to improve the performance.
> 
> > 
> > But, I think that your patchset might just as well be merged because
> > patches are well made and it's clearly separated with mount option. 
> 
> I hope so.
> 
> > In the next time, we could improve this.
> 
> There are also some thoughts in *todo* list, these can be added to developing list
> if this patch set is applied.

Cheers,
Changman

> 
> Thanks for your review and suggestion! :)
> 
> Regards,
> Yu
> 
> > 
> > Regards,
> > Changman
> > 
> > > +       down_read(&sbi->extent_tree_lock);
> > > +       while ((found = radix_tree_gang_lookup(&sbi->extent_tree_root,
> > > +                               (void **)treevec, ino, EXT_TREE_VEC_SIZE))) {
> > > +               unsigned i;
> > > +
> > > +               ino = treevec[found - 1]->ino + 1;
> > > +               for (i = 0; i < found; i++) {
> > > +                       struct extent_tree *et = treevec[i];
> > > +
> > > +                       atomic_inc(&et->refcount);
> > > +                       write_lock(&et->lock);
> > > +                       node_cnt += __free_extent_tree(sbi, et, false);
> > > +                       write_unlock(&et->lock);
> > > +                       atomic_dec(&et->refcount);
> > > +               }
> > > +       }
> > > +       up_read(&sbi->extent_tree_lock);
> > > +
> > > +       down_write(&sbi->extent_tree_lock);
> > > +       radix_tree_for_each_slot(slot, &sbi->extent_tree_root, &iter,
> > > +                                                       F2FS_ROOT_INO(sbi)) {
> > > +               struct extent_tree *et = (struct extent_tree *)*slot;
> > > +
> > > +               if (!atomic_read(&et->refcount) && !et->count) {
> > > +                       radix_tree_delete(&sbi->extent_tree_root, et->ino);
> > > +                       kmem_cache_free(extent_tree_slab, et);
> > > +                       sbi->total_ext_tree--;
> > > +                       tree_cnt++;
> > > +               }
> > > +       }
> > > +       up_write(&sbi->extent_tree_lock);
> > > +}
> > > +
> > 
> > ~ snip ~
> > 
> > > --
> > > 2.2.1
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
