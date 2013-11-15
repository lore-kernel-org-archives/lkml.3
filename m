Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab3KOHuK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:50:10 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:57421 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3KOHuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:50:01 -0500
X-AuditID: cbfee68f-b7f836d000001b39-95-5285d22511ec
Message-id: <1384501749.14041.107.camel@kjgkr>
Subject: Re: [f2fs-dev][PATCH V2 4/6] f2fs: Key functions to handle inline data
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Huajun Li <huajun.li.lee@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Huajun Li <huajun.li@intel.com>,
        Haicheng Li <haicheng.li@linux.intel.com>,
        Weihong Xu <weihong.xu@intel.com>
Date: Fri, 15 Nov 2013 16:49:09 +0900
In-reply-to: <1384096401-25169-5-git-send-email-huajun.li.lee@gmail.com>
References: <1384096401-25169-1-git-send-email-huajun.li.lee@gmail.com>
 <1384096401-25169-5-git-send-email-huajun.li.lee@gmail.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLIsWRmVeSWpSXmKPExsVy+t8zI13VS61BBi+msli8PKRpceZZB6PF
	li0xFl/777BZXFrkbrFn70kWi8u75rBZbDr5i9WBw2PnrLvsHov3vGTymHcy0GP3gs9MHn1b
	VjF6fN4kF8AWxWWTkpqTWZZapG+XwJVx/fUL1oKHfBUHn+5kbGB8yd3FyMkhIWAi8aGliw3C
	FpO4cG89mC0ksIxRYl+jPFzNnJ+MXYxcQPHpjBKnJ/xgh3BeMUp0vl3DDlLFK6An8ejHdWYQ
	W1jAX+LbtfdAkzg42AS0JTbvN4AYqijxdv9dVhBbREBd4vWLuawgc5gFbjFKPGw9wgKSYBFQ
	lXj3cz7YFZwCHhJ3/7xigljWyijRe3U2E0iCX0BU4vDC7WDLmIEmTZq3iBniVCWJ3e2d7BBx
	eYnNa94yQxwnKPFj8j0WkEESAj/ZJX5//8gOsU1A4tvkQywgl0oIyEpsOgA1R1Li4IobLBMY
	JWYhWTELydhZSMYuYGRexSiaWpBcUJyUXmSsV5yYW1yal66XnJ+7iREStf07GO8esD7EmAy0
	ciKzlGhyPjDq80riDY3NjCxMTUyNjcwtzUgTVhLnvf8wKUhIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDo7N3WYAD1yJ7PuFpKyRmfPjLtT64zmOC1jm7Wm3f5ZGijccbNxcF6z156WvQ1LaV
	R0CYZ43KywfTy2WYeqZVrFzTpL/k3sy7LxXtS3Ud0jRP7/9R8n2az1K9Jn3Jw/2m0RknPi64
	v+zNIe9XSntU/vw0D9r25GTjvFxlrbasb8H1spM/yOemK7EUZyQaajEXFScCAAlZ1jrwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNKsWRmVeSWpSXmKPExsVy+t9jQV2VS61BBrfO21i8PKRpceZZB6PF
	li0xFl/777BZXFrkbrFn70kWi8u75rBZbDr5i9WBw2PnrLvsHov3vGTymHcy0GP3gs9MHn1b
	VjF6fN4kF8AW1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQN0jZJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4x4/rrF6wFD/kq
	Dj7dydjA+JK7i5GTQ0LAROLDnJ+MELaYxIV769m6GLk4hASmM0qcnvCDHcJ5xSjR+XYNO0gV
	r4CexKMf15lBbGEBf4lv194DdXBwsAloS2zebwASFhJQlHi7/y4riC0ioC7x+sVcVpA5zAK3
	GCUeth5hAUmwCKhKvPs5nw3E5hTwkLj75xUTxLJWRoneq7OZQBL8AqIShxduB1vGDDRp0rxF
	zBCnKknsbu9kh4jLS2xe85YZ4jhBiR+T77FMYBSahaRlFpKyWUjKFjAyr2IUTS1ILihOSs81
	1CtOzC0uzUvXS87P3cQITgrPpHYwrmywOMQowMGoxMMbId0aJMSaWFZcmXuIUYKDWUmE91kC
	UIg3JbGyKrUoP76oNCe1+BBjMtB7E5mlRJPzgQkrryTe0NjEzMjSyMzCyMTcnDRhJXHeA63W
	gUIC6YklqdmpqQWpRTBbmDg4pRoY519aZHjjctr5SYrrmNLMBUQ0dnw4sXsKX5eGMss9tzfP
	K5otOU911h9lVimsdWo+wG28ZmX/j0kf97A9YzLe9n6/p0im+Cf/eHPtGZYVk2JCkrYdzb3L
	Zd6jL6/MdGr6v7rvqjVBtktW/+GpaJfV9ZgpwmNmpfhnasgnru8hUhoS2ns+ZQkosRRnJBpq
	MRcVJwIA/9CwXk4DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huajun,

[snip]

> +static int __f2fs_convert_inline_data(struct inode *inode, struct page *page)
> +{
> +	int err;
> +	struct page *ipage;
> +	struct dnode_of_data dn;
> +	void *src_addr, *dst_addr;
> +	block_t old_blk_addr, new_blk_addr;
> +	struct f2fs_sb_info *sbi = F2FS_SB(inode->i_sb);
> +
> +	f2fs_lock_op(sbi);
> +	ipage = get_node_page(sbi, inode->i_ino);
> +	if (IS_ERR(ipage))
> +		return PTR_ERR(ipage);
> +
> +	/*
> +	 * i_addr[0] is not used for inline data,
> +	 * so reserving new block will not destroy inline data
> +	 */
> +	set_new_dnode(&dn, inode, ipage, ipage, 0);
> +	err = f2fs_reserve_block(&dn, 0);
> +	if (err) {
> +		f2fs_put_page(ipage, 1);
> +		f2fs_unlock_op(sbi);
> +		return err;
> +	}
> +
> +	src_addr = inline_data_addr(ipage);
> +	dst_addr = page_address(page);
> +	zero_user_segment(page, 0, PAGE_CACHE_SIZE);
> +
> +	/* Copy the whole inline data block */
> +	memcpy(dst_addr, src_addr, MAX_INLINE_DATA);
> +
> +	/* write data page to try to make data consistent */
> +	old_blk_addr = dn.data_blkaddr;
> +	set_page_writeback(page);
> +	write_data_page(inode, page, &dn,
> +			old_blk_addr, &new_blk_addr);
> +	update_extent_cache(new_blk_addr, &dn);
> +	f2fs_wait_on_page_writeback(page, DATA, true);
> +
> +	/* clear inline data and flag after data writeback */
> +	zero_user_segment(ipage, INLINE_DATA_OFFSET,
> +				 INLINE_DATA_OFFSET + MAX_INLINE_DATA);
> +	clear_inode_flag(F2FS_I(inode), FI_INLINE_DATA);
> +
> +	sync_inode_page(&dn);
> +	f2fs_put_page(ipage, 1);

Again, it seems that you missed what I mentioned.
If we write the inlined data block only, we cannot recover the data
block after SPO.
In order to avoid that, we should write its dnode block too by
triggering sync_node_pages(ino) at this point as similar as fsync
routine.

Thanks,

-- 
Jaegeuk Kim
Samsung

