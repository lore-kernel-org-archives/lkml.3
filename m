Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaHZGjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:39:51 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:33396 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbaHZGjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:39:49 -0400
X-AuditID: cbfee61a-f79e46d00000134f-ab-53fc2bb35f25
From: Chao Yu <chao2.yu@samsung.com>
To: "'Jaegeuk Kim'" <jaegeuk@kernel.org>
Cc: "'Changman Lee'" <cm224.lee@samsung.com>,
        linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <00c101cfb37c$79a58140$6cf083c0$@samsung.com>
 <20140821204517.GB85961@jaegeuk-mac02.mot-mobility.com>
In-reply-to: <20140821204517.GB85961@jaegeuk-mac02.mot-mobility.com>
Subject: RE: [f2fs-dev][PATCH 3/5] f2fs: add key function to handle inline dir
Date: Tue, 26 Aug 2014 14:39:03 +0800
Message-id: <008501cfc0f8$87f31170$97d93450$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ+ISZ2VHAtiURznwAL9ejDb7/HxgF2qIvEmnUBZ6A=
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOLMWRmVeSWpSXmKPExsVy+t9jQd0t2n+CDa6uZLW4tq+RyeLJ+lnM
	FpcWuVtc3jWHzYHFY9OqTjaP3Qs+M3n0bVnF6PF5k1wASxSXTUpqTmZZapG+XQJXxvdFJ9kL
	pllVrD98m6WB8ZluFyMnh4SAicTT2VuYIWwxiQv31rN1MXJxCAlMZ5RY17GOFcL5wSjx/XI3
	WBWbgIrE8o7/TCC2iICaRO++KUA2BwezQJHEqhUCIGEhgWKJJ7vWMYLYnAIuEr3TZrN0MbJz
	CAv4SWwAG8IioCqx7MpRsEZeAUuJBWsjQMK8AoISPybfYwGxmQW0JNbvPM4EYctLbF7zFupK
	BYkdZ18zQuy3kphyoIEZokZcYuORWywTGIVmIRk1C8moWUhGzULSsoCRZRWjaGpBckFxUnqu
	oV5xYm5xaV66XnJ+7iZGcPA/k9rBuLLB4hCjAAejEg/vjfjfwUKsiWXFlbmHGCU4mJVEeBke
	AoV4UxIrq1KL8uOLSnNSiw8xSnOwKInzHmi1DhQSSE8sSc1OTS1ILYLJMnFwSjUwrmhKmSo/
	gU1qz0ODfV56zlr6XuVKCpqv2pNE3BYGBO+6fqLz04ol+1WcpSyv9R+oaC47yBO96Nxyxbr0
	2Bdn+f2jjhiuVQi7mL7JObB0y2e9fcxz7s0xKUl5lle/aeKfN3wn7jA4VFx7u+bURC8nOwvB
	PybVe/WDxbPcmd5tXThtqk2Br9MWJZbijERDLeai4kQAtnbmyHoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jaegeuk,

> -----Original Message-----
> From: Jaegeuk Kim [mailto:jaegeuk@kernel.org]
> Sent: Friday, August 22, 2014 4:45 AM
> To: Chao Yu
> Cc: Changman Lee; linux-f2fs-devel@lists.sourceforge.net; linux-kernel@vger.kernel.org
> Subject: Re: [f2fs-dev][PATCH 3/5] f2fs: add key function to handle inline dir
> 
> Hi Chao,
> 
> On Sat, Aug 09, 2014 at 10:48:20AM +0800, Chao Yu wrote:
> > Adds Functions to implement inline dir init/lookup/insert/delete/convert ops.
> >
> > Signed-off-by: Chao Yu <chao2.yu@samsung.com>
> > ---
> >  fs/f2fs/f2fs.h   |   9 ++
> >  fs/f2fs/inline.c | 388 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 397 insertions(+)
> >
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index 58c1a49..436a498 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -1450,4 +1450,13 @@ int f2fs_convert_inline_data(struct inode *, pgoff_t);
> >  int f2fs_write_inline_data(struct inode *, struct page *, unsigned int);
> >  void truncate_inline_data(struct inode *, u64);
> >  int recover_inline_data(struct inode *, struct page *);
> > +struct f2fs_dir_entry *find_in_inline_dir(struct inode *, struct qstr *,
> > +							struct page **);
> > +struct f2fs_dir_entry *f2fs_parent_inline_dir(struct inode *, struct page **);
> > +int make_empty_inline_dir(struct inode *inode, struct inode *, struct page *);
> > +int f2fs_add_inline_entry(struct inode *, const struct qstr *, struct inode *);
> > +void f2fs_delete_inline_entry(struct f2fs_dir_entry *, struct page *,
> > +						struct inode *, struct inode *);
> > +bool f2fs_empty_inline_dir(struct inode *);
> > +int f2fs_read_inline_dir(struct file *, struct dir_context *);
> >  #endif
> > diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
> > index 5beecce..58d2623 100644
> > --- a/fs/f2fs/inline.c
> > +++ b/fs/f2fs/inline.c
> > @@ -249,3 +249,391 @@ process_inline:
> >  	}
> >  	return 0;
> >  }
> > +
> > +struct f2fs_dir_entry *find_in_inline_dir(struct inode *dir,
> > +				struct qstr *name, struct page **res_page)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> > +	struct page *ipage;
> > +	struct f2fs_dir_entry *de;
> > +	f2fs_hash_t namehash;
> > +	unsigned long bit_pos = 0;
> > +	struct f2fs_inline_dentry *dentry_blk;
> > +	const void *dentry_bits;
> > +
> > +	ipage = get_node_page(sbi, dir->i_ino);
> > +	if (IS_ERR(ipage))
> > +		return NULL;
> > +
> > +	namehash = f2fs_dentry_hash(name);
> > +
> > +	kmap(ipage);
> 
> Don't need kmap for ipage.

Will delete all 'kmap/kunmap' for ipage.

> 
> > +	dentry_blk = inline_data_addr(ipage);
> > +	dentry_bits = &dentry_blk->dentry_bitmap;
> > +
> > +	while (bit_pos < NR_INLINE_DENTRY) {
> > +		if (!test_bit_le(bit_pos, dentry_bits)) {
> > +			bit_pos++;
> > +			continue;
> > +		}
> > +		de = &dentry_blk->dentry[bit_pos];
> > +		if (early_match_name(name->len, namehash, de)) {
> > +			if (!memcmp(dentry_blk->filename[bit_pos],
> > +							name->name,
> > +							name->len)) {
> > +				*res_page = ipage;
> > +				goto found;
> > +			}
> > +		}
> > +
> > +		/*
> > +		 * For the most part, it should be a bug when name_len is zero.
> > +		 * We stop here for figuring out where the bugs are occurred.
> > +		 */
> > +		f2fs_bug_on(!de->name_len);
> > +
> > +		bit_pos += GET_DENTRY_SLOTS(le16_to_cpu(de->name_len));
> > +	}
> > +
> > +	de = NULL;
> > +	kunmap(ipage);
> 
> Ditto.
> 
> > +found:
> > +	unlock_page(ipage);
> > +	return de;
> > +}
> > +
> > +struct f2fs_dir_entry *f2fs_parent_inline_dir(struct inode *dir,
> > +							struct page **p)
> > +{
> > +	struct f2fs_sb_info *sbi = F2FS_SB(dir->i_sb);
> > +	struct page *ipage;
> > +	struct f2fs_dir_entry *de;
> > +	struct f2fs_inline_dentry *dentry_blk;
> > +
> > +	ipage = get_node_page(sbi, dir->i_ino);
> > +	if (IS_ERR(ipage))
> > +		return NULL;
> > +
> > +	kmap(ipage);
> 
> Ditto.
> 
> > +	dentry_blk = inline_data_addr(ipage);
> > +	de = &dentry_blk->dentry[1];
> > +	*p = ipage;
> > +	unlock_page(ipage);
> > +	return de;
> > +}
> > +

[snip]

> > +int f2fs_convert_inline_dir(struct inode *dir, struct page *ipage,
> > +				struct f2fs_inline_dentry *inline_dentry)
> > +{
> > +	struct page *page;
> > +	struct dnode_of_data dn;
> > +	block_t new_blk_addr;
> > +	struct f2fs_dentry_block *dentry_blk;
> > +	struct f2fs_io_info fio = {
> > +		.type = DATA,
> > +		.rw = WRITE_SYNC | REQ_PRIO,
> > +	};
> > +	int err;
> > +
> > +	page = grab_cache_page(dir->i_mapping, 0);
> > +	if (!page)
> > +		return -ENOMEM;
> > +
> > +	set_new_dnode(&dn, dir, ipage, NULL, 0);
> > +	err = f2fs_reserve_block(&dn, 0);
> > +	if (err)
> > +		goto out;
> 
> At a glance, we don't need to care about dentry blocks to sync, since checkpoint
> handles that.

Yeah, agreed. Thanks for reminding me the issue! I got the reason why
convert_inline_data should sync dentry blocks, but convert_inline_dir
do not need to care about it from the scenario given from you to
Huajun Li.

> It needs to consider about checkpoint and f2fs_sync_file.

If this directory inode is being fsynced, do_checkpoint will be invoked for
data consistent, is there any special case convert_inline_dir will encounter?

> 
> The addition and deletion stuffs are almost same as the existing codes.
> Can we reuse those to avoid potential bugs?

Yes, it could be, and I tried before, it seems not very clean to me when
I implement f2fs_{add,delete}_inline_entry inside f2fs_{add,delete}_dentry.

I think it's better to introduce inner function including the same part
of code between f2fs_add_entry and f2fs_add_inline_entry or between
f2fs_inline_entry and f2fs_delete_inline_entry.

How do you think?

> 
> And it'd be better to add inline_dentry mount option separately for now.

OK.

Thanks,
Yu

> 
> Thanks,
> 
> > +
> > +	f2fs_wait_on_page_writeback(page, DATA);
> > +	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
> > +
> > +	dentry_blk = kmap(page);
> > +
> > +	/* copy data from inline dentry block to new dentry block */
> > +	memcpy(dentry_blk->dentry_bitmap, inline_dentry->dentry_bitmap,
> > +					INLINE_DENTRY_BITMAP_SIZE);
> > +	memcpy(dentry_blk->reserved, inline_dentry->reserved,
> > +					INLINE_RESERVED_SIZE);
> > +	memcpy(dentry_blk->dentry, inline_dentry->dentry,
> > +			sizeof(struct f2fs_dir_entry) * NR_INLINE_DENTRY);
> > +	memcpy(dentry_blk->filename, inline_dentry->filename,
> > +					NR_INLINE_DENTRY * F2FS_SLOT_LEN);
> > +
> > +	kunmap(page);
> > +	SetPageUptodate(page);
> > +
> > +	/* writeback dentry page to make data consistent */
> > +	set_page_writeback(page);
> > +	write_data_page(page, &dn, &new_blk_addr, &fio);
> > +	update_extent_cache(new_blk_addr, &dn);
> > +	f2fs_wait_on_page_writeback(page, DATA);
> > +
> > +	/* clear inline dir and flag after data writeback */
> > +	zero_user_segment(ipage, INLINE_DATA_OFFSET,
> > +				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> > +	clear_inode_flag(F2FS_I(dir), FI_INLINE_DATA);
> > +	stat_dec_inline_inode(dir);
> > +
> > +	if (i_size_read(dir) < PAGE_CACHE_SIZE) {
> > +		i_size_write(dir, PAGE_CACHE_SIZE);
> > +		set_inode_flag(F2FS_I(dir), FI_UPDATE_DIR);
> > +	}
> > +
> > +	sync_inode_page(&dn);
> > +out:
> > +
> > +	f2fs_put_page(page, 1);
> > +	return err;
> > +}
> > +

[snip]


