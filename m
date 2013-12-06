Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789Ab3LFENQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 23:13:16 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:9291 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3LFENF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 23:13:05 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f5c6d000004aff-dc-52a14ece41a1
Content-transfer-encoding: 8BIT
Message-id: <1386303123.2101.18.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 2/5 V2] f2fs: add unlikely() macro for compiler
 optimization
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=E8=B0=AD=E5=A7=9D?= <shu.tan@samsung.com>
Date: Fri, 06 Dec 2013 13:12:03 +0900
In-reply-to: <000001cef19a$a4bed330$ee3c7990$@samsung.com>
References: <000001cef19a$a4bed330$ee3c7990$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t8zQ91zfguDDJqemVn8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoErY9kWz4J1
	rhUver8zNjD2mncxcnJICJhINHTvY4awxSQu3FvP1sXIxSEksIxRYvXWAywwRf9+vmeCSCxi
	lPh1+A0jSIJXQFDix+R7QEUcHMwC8hJHLmWDhJkF1CUmzVvEDFH/Cqj+3m8miHodiafbV4P1
	CgvESjTPXcUM0ssmoC2xeb8BSFhIQFHi7f67rCC2iICSxK/5i1hB5jALLGSUOLjgJhtIPYuA
	qkTfZF2QGk4BK4mmBa/YIHotJeYv/A7Wyy8gKnF44Xaox5Qkdrd3soPMkRA4xy5x/jXE/SwC
	AhLfJh8Cu19CQFZi0wGoekmJgytusExglJiF5MtZCF/OQvLlAkbmVYyiqQXJBcVJ6UWGesWJ
	ucWleel6yfm5mxghcde7g/H2AetDjMlAGycyS4km5wPjNq8k3tDYzMjC1MTU2Mjc0ow0YSVx
	3qSHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGEUuz4rNP5ds8WwX88Jrs1comWYKv6pV
	vt2+++3Zlp9nP2z7uu69nm+v8lLLpGuJ+jaHN8hJyuslJfYtOzB7psm+QJ1jv5hbk7Rr/mc1
	u7/LnKac2hXty/XGV2n/1qg2n7umPsJLfmgs+8XSqxqlxXZrCtvO2c7B9XMdd9oGLT/Jdnxx
	wIc7/UosxRmJhlrMRcWJAGqebUHRAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNKsWRmVeSWpSXmKPExsVy+t9jAd1zfguDDM6sN7T43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8ayLZ4F61wrXvR+Z2xg7DXvYuTkkBAwkfj38z0ThC0mceHeerYu
	Ri4OIYFFjBK/Dr9hBEnwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh6l8B1d/7zQRR
	ryPxdPtqsF5hgViJ5rmrmEF62QS0JTbvNwAJCwkoSrzdf5cVxBYRUJL4NX8RK8gcZoGFjBIH
	F9xkA6lnEVCV6JusC1LDKWAl0bTgFRtEr6XE/IXfwXr5BUQlDi/czgxxv5LE7vZO9gmMQrOQ
	XD0L4epZSK5ewMi8ilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyM4qp9J7WBc2WBxiFGAg1GJ
	h5dj1YIgIdbEsuLK3EOMEhzMSiK8PeILg4R4UxIrq1KL8uOLSnNSiw8xJgPdPZFZSjQ5H5hw
	8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcdfmSdcUBTaG
	zk7fm+PZpWHz6YbVdx6t/TPN5sbGzpvy/GeVdHHYtFfm5/dIxbwqWTutm9GDad32fTVbPbgC
	IwvTJe/v9Gzz1P5bfvhSeFjfq73BMwUfiDX76fLKWfW8ZhUVPf1pZ/uf3LzNF65uV4g4Fu/u
	9P+PoZTVLZGfT3+KzOXMWLcrRImlOCPRUIu5qDgRABbcIxUuAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Just in case, if you agreed the following comments, I'll fix those and
merge the patch by myself.
Thanks,

2013-12-05 (목), 17:15 +0800, Chao Yu:
> As we know, some of our branch condition will rarely be true. So we could add
> 'unlikely' to let compiler optimize these code, by this way we could drop
> unneeded 'jump' assemble code to improve performance.
> 
> change log:
>  o add *unlikely* as many as possible across the whole source files at once
>    suggested by Jaegeuk Kim.
> 
> Suggested-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> ---
>  fs/f2fs/checkpoint.c |   10 +++++-----
>  fs/f2fs/data.c       |    4 ++--
>  fs/f2fs/dir.c        |    4 ++--
>  fs/f2fs/f2fs.h       |    8 ++++----
>  fs/f2fs/node.c       |   16 ++++++++--------
>  fs/f2fs/segment.h    |    2 +-
>  6 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index 38f4a224..6580808 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -82,8 +82,8 @@ static int f2fs_write_meta_page(struct page *page,
>  	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
>  
>  	/* Should not write any meta pages, if any IO error was occurred */
> -	if (wbc->for_reclaim || sbi->por_doing ||
> -			is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG)) {
> +	if (unlikely(wbc->for_reclaim || sbi->por_doing ||
> +			is_set_ckpt_flags(F2FS_CKPT(sbi), CP_ERROR_FLAG))) {

	if (unlikely(sbi->por_doing || is_set_ckpt_flags(F2FS_CKPT(sbi),
CP_ERROR_FLAG)))
		goto redirty_out;
	if (wbc->for_reclaim)
		goto redirty_out;

redirty_out:
>  		dec_page_count(sbi, F2FS_DIRTY_META);
>  		wbc->pages_skipped++;
>  		set_page_dirty(page);
> @@ -137,7 +137,7 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
>  		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
>  				PAGECACHE_TAG_DIRTY,
>  				min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
> -		if (nr_pages == 0)
> +		if (unlikely(nr_pages == 0))
>  			break;
>  
>  		for (i = 0; i < nr_pages; i++) {
> @@ -150,7 +150,7 @@ long sync_meta_pages(struct f2fs_sb_info *sbi, enum page_type type,
>  				unlock_page(page);
>  				break;
>  			}
> -			if (nwritten++ >= nr_to_write)
> +			if (unlikely(nwritten++ >= nr_to_write))

nwritten++;

if (unlikely(nwritten >= nr_to_write))


>  				break;
>  		}
>  		pagevec_release(&pvec);
> @@ -200,7 +200,7 @@ int acquire_orphan_inode(struct f2fs_sb_info *sbi)
>  	max_orphans = (sbi->blocks_per_seg - 2 - NR_CURSEG_TYPE)
>  				* F2FS_ORPHANS_PER_BLOCK;
>  	mutex_lock(&sbi->orphan_inode_mutex);
> -	if (sbi->n_orphans >= max_orphans)
> +	if (unlikely(sbi->n_orphans >= max_orphans))
>  		err = -ENOSPC;
>  	else
>  		sbi->n_orphans++;
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 4e2fc09..2ce5a9e 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -251,7 +251,7 @@ int reserve_new_block(struct dnode_of_data *dn)
>  
>  	if (is_inode_flag_set(F2FS_I(dn->inode), FI_NO_ALLOC))
>  		return -EPERM;
> -	if (!inc_valid_block_count(sbi, dn->inode, 1))
> +	if (unlikely(!inc_valid_block_count(sbi, dn->inode, 1)))
>  		return -ENOSPC;
>  
>  	trace_f2fs_reserve_new_block(dn->inode, dn->nid, dn->ofs_in_node);
> @@ -711,7 +711,7 @@ static int f2fs_write_data_page(struct page *page,
>  
>  	zero_user_segment(page, offset, PAGE_CACHE_SIZE);
>  write:
> -	if (sbi->por_doing) {
> +	if (unlikely(sbi->por_doing)) {
>  		err = AOP_WRITEPAGE_ACTIVATE;
>  		goto redirty_out;
>  	}
> diff --git a/fs/f2fs/dir.c b/fs/f2fs/dir.c
> index 594fc1b..0cc26ba 100644
> --- a/fs/f2fs/dir.c
> +++ b/fs/f2fs/dir.c
> @@ -190,7 +190,7 @@ struct f2fs_dir_entry *f2fs_find_entry(struct inode *dir,
>  	unsigned int max_depth;
>  	unsigned int level;
>  
> -	if (namelen > F2FS_NAME_LEN)
> +	if (unlikely(namelen > F2FS_NAME_LEN))
>  		return NULL;
>  
>  	if (npages == 0)
> @@ -461,7 +461,7 @@ int __f2fs_add_link(struct inode *dir, const struct qstr *name, struct inode *in
>  	}
>  
>  start:
> -	if (current_depth == MAX_DIR_HASH_DEPTH)
> +	if (unlikely(current_depth == MAX_DIR_HASH_DEPTH))
>  		return -ENOSPC;
>  
>  	/* Increase the depth, if required */
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index 10eca02..dca18b3 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -574,7 +574,7 @@ static inline void f2fs_unlock_all(struct f2fs_sb_info *sbi)
>  static inline int check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
>  {
>  	WARN_ON((nid >= NM_I(sbi)->max_nid));
> -	if (nid >= NM_I(sbi)->max_nid)
> +	if (unlikely(nid >= NM_I(sbi)->max_nid))
>  		return -EINVAL;
>  	return 0;
>  }
> @@ -600,7 +600,7 @@ static inline bool inc_valid_block_count(struct f2fs_sb_info *sbi,
>  	spin_lock(&sbi->stat_lock);
>  	valid_block_count =
>  		sbi->total_valid_block_count + (block_t)count;
> -	if (valid_block_count > sbi->user_block_count) {
> +	if (unlikely(valid_block_count > sbi->user_block_count)) {
>  		spin_unlock(&sbi->stat_lock);
>  		return false;
>  	}
> @@ -719,13 +719,13 @@ static inline bool inc_valid_node_count(struct f2fs_sb_info *sbi,
>  	spin_lock(&sbi->stat_lock);
>  
>  	valid_block_count = sbi->total_valid_block_count + 1;
> -	if (valid_block_count > sbi->user_block_count) {
> +	if (unlikely(valid_block_count > sbi->user_block_count)) {
>  		spin_unlock(&sbi->stat_lock);
>  		return false;
>  	}
>  
>  	valid_node_count = sbi->total_valid_node_count + 1;
> -	if (valid_node_count > sbi->total_node_count) {
> +	if (unlikely(valid_node_count > sbi->total_node_count)) {
>  		spin_unlock(&sbi->stat_lock);
>  		return false;
>  	}
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 5e2588f..48cbf76 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -94,7 +94,7 @@ static void ra_nat_pages(struct f2fs_sb_info *sbi, int nid)
>  	int i;
>  
>  	for (i = 0; i < FREE_NID_PAGES; i++, nid += NAT_ENTRY_PER_BLOCK) {
> -		if (nid >= nm_i->max_nid)
> +		if (unlikely(nid >= nm_i->max_nid))
>  			nid = 0;
>  		index = current_nat_addr(sbi, nid);
>  
> @@ -1160,7 +1160,7 @@ int wait_on_node_pages_writeback(struct f2fs_sb_info *sbi, nid_t ino)
>  			struct page *page = pvec.pages[i];
>  
>  			/* until radix tree lookup accepts end_index */
> -			if (page->index > end)
> +			if (unlikely(page->index > end))
>  				continue;
>  
>  			if (ino && ino_of_node(page) == ino) {
> @@ -1190,7 +1190,7 @@ static int f2fs_write_node_page(struct page *page,
>  	block_t new_addr;
>  	struct node_info ni;
>  
> -	if (sbi->por_doing)
> +	if (unlikely(sbi->por_doing))
>  		goto redirty_out;
>  
>  	wait_on_page_writeback(page);
> @@ -1326,7 +1326,7 @@ static int add_free_nid(struct f2fs_nm_info *nm_i, nid_t nid, bool build)
>  		return -1;
>  
>  	/* 0 nid should not be used */
> -	if (nid == 0)
> +	if (unlikely(nid == 0))
>  		return 0;
>  
>  	if (build) {
> @@ -1379,7 +1379,7 @@ static void scan_nat_page(struct f2fs_nm_info *nm_i,
>  
>  	for (; i < NAT_ENTRY_PER_BLOCK; i++, start_nid++) {
>  
> -		if (start_nid >= nm_i->max_nid)
> +		if (unlikely(start_nid >= nm_i->max_nid))
>  			break;
>  
>  		blk_addr = le32_to_cpu(nat_blk->entries[i].block_addr);
> @@ -1413,7 +1413,7 @@ static void build_free_nids(struct f2fs_sb_info *sbi)
>  		f2fs_put_page(page, 1);
>  
>  		nid += (NAT_ENTRY_PER_BLOCK - (nid % NAT_ENTRY_PER_BLOCK));
> -		if (nid >= nm_i->max_nid)
> +		if (unlikely(nid >= nm_i->max_nid))
>  			nid = 0;
>  
>  		if (i++ == FREE_NID_PAGES)
> @@ -1447,7 +1447,7 @@ bool alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
>  	struct free_nid *i = NULL;
>  	struct list_head *this;
>  retry:
> -	if (sbi->total_valid_node_count + 1 >= nm_i->max_nid)
> +	if (unlikely(sbi->total_valid_node_count + 1 >= nm_i->max_nid))
>  		return false;
>  
>  	spin_lock(&nm_i->free_nid_list_lock);
> @@ -1557,7 +1557,7 @@ int recover_inode_page(struct f2fs_sb_info *sbi, struct page *page)
>  	new_ni = old_ni;
>  	new_ni.ino = ino;
>  
> -	if (!inc_valid_node_count(sbi, NULL))
> +	if (unlikely(!inc_valid_node_count(sbi, NULL)))
>  		WARN_ON(1);
>  	set_node_addr(sbi, &new_ni, NEW_ADDR);
>  	inc_valid_inode_count(sbi);
> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> index 26812fc..ea56376 100644
> --- a/fs/f2fs/segment.h
> +++ b/fs/f2fs/segment.h
> @@ -457,7 +457,7 @@ static inline bool has_not_enough_free_secs(struct f2fs_sb_info *sbi, int freed)
>  	int node_secs = get_blocktype_secs(sbi, F2FS_DIRTY_NODES);
>  	int dent_secs = get_blocktype_secs(sbi, F2FS_DIRTY_DENTS);
>  
> -	if (sbi->por_doing)
> +	if (unlikely(sbi->por_doing))
>  		return false;
>  
>  	return ((free_sections(sbi) + freed) <= (node_secs + 2 * dent_secs +

-- 
Jaegeuk Kim
Samsung

