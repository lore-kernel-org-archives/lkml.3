Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751374Ab3G3MaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:30:21 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:27243 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab3G3MaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:30:19 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f6f6d00000740c-9b-51f7b1d96704
Content-transfer-encoding: 8BIT
Message-id: <1375187398.26443.69.camel@kjgkr>
Subject: Re: [PATCH] f2fs: add a wait step when submit bio with
 {READ,WRITE}_SYNC
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 21:29:58 +0900
In-reply-to: <51F7901E.3010204@cn.fujitsu.com>
References: <51F7901E.3010204@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t8zfd2bG78HGqyfIGLxvP0As8WlRe4W
	e/aeZLG4vGsOmwOLx/+Dk5g9di/4zOTxeZNcAHMUl01Kak5mWWqRvl0CV8aMqRUFbcoVU3+t
	Zmtg/CvVxcjBISFgIrH0V2IXIyeQKSZx4d56ti5GLg4hgWWMEvOvbWaHSJhIvOhZwgSRWMQo
	se7pIWaQBK+AoMSPyfdYQAYxC8hLHLmUDRJmFlCXmDRvEViJkMBrRonP9+shynUlvr55yQRi
	CwsES1yd9JMdpJVNQFti834DiHJFibf777KC2CICahLP3l0CW8ss0M0ocXb9K7B7WARUJea9
	XgZmcwroSfT+bWOHaNaVODbrE9h8fgFRicMLtzND3K8ksbu9kx1kkITAKXaJdx2XWSAGCUh8
	m3yIBRIQshKbDkDVS0ocXHGDZQKjxCwkX85C+HIWki8XMDKvYhRNLUguKE5KLzLRK07MLS7N
	S9dLzs/dxAiJtQk7GO8dsD7EmAy0cSKzlGhyPjBW80riDY3NjCxMTUyNjcwtzUgTVhLnVW+x
	DhQSSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAuCBkx8QlkvNUuB5XrvbO2L90pkIMe4IB/9EM
	i76DchMn86R0XM7I7ksLYt0uEROZu2AN1684Tq0AlRtlzQFxey1XPN7VoD31hpRYy48Ar44N
	5t7cmeofry7nmKN9ybuuXl6Ej7uK+8P7kPNPNt4/cFaqWeOMwF/blXyuO441nrxmv/BIStcH
	JZbijERDLeai4kQA3ztH0MsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAd2bG78HGpw+w2/xvP0As8WlRe4W
	e/aeZLG4vGsOmwOLx/+Dk5g9di/4zOTxeZNcAHNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxz
	vKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtA2JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+
	IUFwPUYGaCBhHWPGjKkVBW3KFVN/rWZrYPwr1cXIySEhYCLxomcJE4QtJnHh3nq2LkYuDiGB
	RYwS654eYgZJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYvASoQEXjNKfL5fD1GuK/H1
	zUuwmcICwRJXJ/1kB2llE9CW2LzfAKJcUeLt/rusILaIgJrEs3eXmEDWMgt0M0qcXf+KHSTB
	IqAqMe/1MjCbU0BPovdvGztEs67EsVmfwObzC4hKHF64nRnifiWJ3e2d7BMYhWYhuXoWwtWz
	kFy9gJF5FaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwLD+T3sG4qsHiEKMAB6MSD++Ggm+B
	QqyJZcWVuYcYJTiYlUR4z0/8HijEm5JYWZValB9fVJqTWnyIMRno8InMUqLJ+cA0k1cSb2hs
	YmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjKbl0zerSH2Qcnxz9PFu
	5zVFj53+C2cxbqlie3fuy1PdE7O/+XUsrjMyyEq3VuzhSDUs2zkv+MbLT1vcf1hfOacbmnPR
	9+EFodmWpzbIbzDavFLuydTnP3597prGr7f8Xb/qW+/9Gq4SnwRuc+59u65RM/DV/ejue/5X
	40t+bqvxW3lCZi5HyVslluKMREMt5qLiRACXB5+tKQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

The original read flow was to avoid redandunt lock/unlock_page() calls.
And we should not wait for WRITE_SYNC, since it is just for write
priority, not for synchronization of the file system.
Thanks,

2013-07-30 (화), 18:06 +0800, Gu Zheng:
> When we submit bio with READ_SYNC or WRITE_SYNC, we need to wait a
> moment for the io completion, current codes only find_data_page() follows the
> rule, other places missing this step, so add it.
> 
> Further more, moving the PageUptodate check into f2fs_readpage() to clean up
> the codes.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/checkpoint.c |    1 -
>  fs/f2fs/data.c       |   39 +++++++++++++++++----------------------
>  fs/f2fs/node.c       |    1 -
>  fs/f2fs/recovery.c   |    2 --
>  fs/f2fs/segment.c    |    2 +-
>  5 files changed, 18 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
> index fe91773..e376a42 100644
> --- a/fs/f2fs/checkpoint.c
> +++ b/fs/f2fs/checkpoint.c
> @@ -64,7 +64,6 @@ repeat:
>  	if (f2fs_readpage(sbi, page, index, READ_SYNC))
>  		goto repeat;
>  
> -	lock_page(page);
>  	if (page->mapping != mapping) {
>  		f2fs_put_page(page, 1);
>  		goto repeat;
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 19cd7c6..b048936 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -216,13 +216,11 @@ struct page *find_data_page(struct inode *inode, pgoff_t index, bool sync)
>  
>  	err = f2fs_readpage(sbi, page, dn.data_blkaddr,
>  					sync ? READ_SYNC : READA);
> -	if (sync) {
> -		wait_on_page_locked(page);
> -		if (!PageUptodate(page)) {
> -			f2fs_put_page(page, 0);
> -			return ERR_PTR(-EIO);
> -		}
> -	}
> +	if (err)
> +		return ERR_PTR(err);
> +
> +	if (sync)
> +		unlock_page(page);
>  	return page;
>  }
>  
> @@ -267,11 +265,6 @@ repeat:
>  	if (err)
>  		return ERR_PTR(err);
>  
> -	lock_page(page);
> -	if (!PageUptodate(page)) {
> -		f2fs_put_page(page, 1);
> -		return ERR_PTR(-EIO);
> -	}
>  	if (page->mapping != mapping) {
>  		f2fs_put_page(page, 1);
>  		goto repeat;
> @@ -325,11 +318,7 @@ repeat:
>  		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>  		if (err)
>  			return ERR_PTR(err);
> -		lock_page(page);
> -		if (!PageUptodate(page)) {
> -			f2fs_put_page(page, 1);
> -			return ERR_PTR(-EIO);
> -		}
> +
>  		if (page->mapping != mapping) {
>  			f2fs_put_page(page, 1);
>  			goto repeat;
> @@ -399,6 +388,16 @@ int f2fs_readpage(struct f2fs_sb_info *sbi, struct page *page,
>  
>  	submit_bio(type, bio);
>  	up_read(&sbi->bio_sem);
> +
> +	if (type == READ_SYNC) {
> +		wait_on_page_locked(page);
> +		lock_page(page);
> +		if (!PageUptodate(page)) {
> +			f2fs_put_page(page, 1);
> +			return -EIO;
> +		}
> +	}
> +
>  	return 0;
>  }
>  
> @@ -679,11 +678,7 @@ repeat:
>  		err = f2fs_readpage(sbi, page, dn.data_blkaddr, READ_SYNC);
>  		if (err)
>  			return err;
> -		lock_page(page);
> -		if (!PageUptodate(page)) {
> -			f2fs_put_page(page, 1);
> -			return -EIO;
> -		}
> +
>  		if (page->mapping != mapping) {
>  			f2fs_put_page(page, 1);
>  			goto repeat;
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index f5172e2..f061554 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1534,7 +1534,6 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  		if (f2fs_readpage(sbi, page, addr, READ_SYNC))
>  			goto out;
>  
> -		lock_page(page);
>  		rn = F2FS_NODE(page);
>  		sum_entry->nid = rn->footer.nid;
>  		sum_entry->version = 0;
> diff --git a/fs/f2fs/recovery.c b/fs/f2fs/recovery.c
> index 639eb34..ec68183 100644
> --- a/fs/f2fs/recovery.c
> +++ b/fs/f2fs/recovery.c
> @@ -140,8 +140,6 @@ static int find_fsync_dnodes(struct f2fs_sb_info *sbi, struct list_head *head)
>  		if (err)
>  			goto out;
>  
> -		lock_page(page);
> -
>  		if (cp_ver != cpver_of_node(page))
>  			break;
>  
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 9b74ae2..bcd19db 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -639,7 +639,7 @@ static void do_submit_bio(struct f2fs_sb_info *sbi,
>  
>  		trace_f2fs_do_submit_bio(sbi->sb, btype, sync, sbi->bio[btype]);
>  
> -		if (type == META_FLUSH) {
> +		if ((type == META_FLUSH) || (rw & WRITE_SYNC)) {
>  			DECLARE_COMPLETION_ONSTACK(wait);
>  			p->is_sync = true;
>  			p->wait = &wait;

-- 
Jaegeuk Kim
Samsung

