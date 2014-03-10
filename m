Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaCJELf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:11:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:22315 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaCJELe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:11:34 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7fcd6d00000315b-6e-531d3b71faf5
Content-transfer-encoding: 8BIT
Message-id: <1394424588.5043.1.camel@lcm>
Subject: Re: [f2fs-dev] [PATCH 5/5] f2fs: add a wait queue to avoid
 unnecessary, build_free_nid
From: Changman Lee <cm224.lee@samsung.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Kim <jaegeuk.kim@samsung.com>, linux-kernel <linux-kernel@vger.kernel.org>,
        f2fs <linux-f2fs-devel@lists.sourceforge.net>
Date: Mon, 10 Mar 2014 13:09:48 +0900
In-reply-to: <5319A2DB.8040705@cn.fujitsu.com>
References: <5319A2DB.8040705@cn.fujitsu.com>
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGIsWRmVeSWpSXmKPExsVy+t8zQ91Ca9lgg+ZmVovn7QeYLa7v+stk
	cWmRu8XlXXPYHFg8/h+cxOyxe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3S+DK2H6qi61g
	kUTFwgkfWBsYTwp3MXJySAiYSPzqfscKYYtJXLi3nq2LkYtDSGAZo0TnzQVMMEXLXz1jgUgs
	YpTobvjBDJLgFRCU+DH5HlCCg4NZQF7iyKVskDCzgLrEpHmLmCHqXzFK3P+4gwWiXlNi5bKz
	YLawQKLE26tzwBawCWhJtJ9eCxYXEVCTePbuEhPEoHqJg5032EBsFgFViQl7DoPZnAJ6Er/P
	PWMH2SskoCux5IwtxJ1KErvbO9kh7E3sEt9nWkG0Ckh8m3wI7EwJAVmJTQeYIUokJQ6uuMEy
	gVFsFpJnZiE8MwvJMwsYmVcxiqYWJBcUJ6UXGeoVJ+YWl+al6yXn525ihMRR7w7G2wesDzEm
	A22cyCwlmpwPjMO8knhDYzMjC1MTU2Mjc0sz0oSVxHmTHiYFCQmkJ5akZqemFqQWxReV5qQW
	H2Jk4uCUamBk0+4znn3i01GzOadfq5TNrWFLUduyvCLrhowI6+470Yv5smYfttofVKBn++hY
	74FjO59POVHBbmIzvdlrodq89X+rF4btD7EN3hpX9Mbkit/5ZcIHKoRXrFSZmfMz6VebkytD
	8Le3cq9bdjxuYGVMOjEpk/F4loD3X/1egcvc7GdDFvKsn2CvxFKckWioxVxUnAgAiICENbkC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmleLIzCtJLcpLzFFi42I5/e+xgG6htWywwZYai+ftB5gtru/6y2Rx
	aZG7xeVdc9gcWDz+H5zE7LF7wWcmj74tqxg9Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPM2H6qi61gkUTFwgkfWBsYTwp3MXJySAiYSCx/9YwFwhaTuHBvPVsX
	IxeHkMAiRonuhh/MIAleAUGJH5PvARVxcDALyEscuZQNEmYWUJeYNG8RM0T9K0aJ+x93sEDU
	a0qsXHYWzBYWSJR4e3UOE4jNJqAl0X56LVhcREBN4tm7S0wQg+olDnbeYAOxWQRUJSbsOQxm
	cwroSfw+94wdZK+QgK7EkjO2EHcqSexu72SfwCgwC8l1sxCum4XkugWMzKsYRVMLkguKk9Jz
	DfWKE3OLS/PS9ZLzczcxgqP0mdQOxpUNFocYBTgYlXh4M17LBAuxJpYVV+YeYpTgYFYS4eUy
	lA0W4k1JrKxKLcqPLyrNSS0+xJgMdOtEZinR5HxgAskriTc0NjEzsjQyszAyMTcnTVhJnPdA
	q3WgkEB6YklqdmpqQWoRzBYmDk6pBsbCZZna9+YrtL3d05Suel6q9jXzopUX1K/O/3E2fofr
	rk+3UvbXLs986fOI8dTRc0zqJTnROdt192S+M9sW0f5JzfVXxe8jk+MPcy1L5QrhXiFzt87d
	jbuG+4qRu471v6oyBUZjx6u82TqJK8V6ry5x4Hlh5F/ud+riOivLsohP+y5NXZPhGa/EUpyR
	aKjFXFScCACCttIWFgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 금, 2014-03-07 at 18:43 +0800, Gu Zheng wrote:
> Previously, when we try to alloc free nid while the build free nid
> is going, the allocer will be run into the flow that waiting for
> "nm_i->build_lock", see following:
> 	/* We should not use stale free nids created by build_free_nids */
> ---->	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
> 		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
> 		list_for_each(this, &nm_i->free_nid_list) {
> 			i = list_entry(this, struct free_nid, list);
> 			if (i->state == NID_NEW)
> 				break;
> 		}
> 
> 		f2fs_bug_on(i->state != NID_NEW);
> 		*nid = i->nid;
> 		i->state = NID_ALLOC;
> 		nm_i->fcnt--;
> 		spin_unlock(&nm_i->free_nid_list_lock);
> 		return true;
> 	}
> 	spin_unlock(&nm_i->free_nid_list_lock);
> 
> 	/* Let's scan nat pages and its caches to get free nids */
> ---->	mutex_lock(&nm_i->build_lock);
> 	build_free_nids(sbi);
> 	mutex_unlock(&nm_i->build_lock);
> and this will cause another unnecessary building free nid if the current
> building free nid job is done.
> So here we introduce a wait_queue to avoid this issue.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/f2fs.h |    1 +
>  fs/f2fs/node.c |   10 +++++++++-
>  2 files changed, 10 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index f845e92..7ae193e 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -256,6 +256,7 @@ struct f2fs_nm_info {
>  	spinlock_t free_nid_list_lock;	/* protect free nid list */
>  	unsigned int fcnt;		/* the number of free node id */
>  	struct mutex build_lock;	/* lock for build free nids */
> +	wait_queue_head_t build_wq;	/* wait queue for build free nids */
>  
>  	/* for checkpoint */
>  	char *nat_bitmap;		/* NAT bitmap pointer */
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 4b7861d..ab44711 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1422,7 +1422,13 @@ retry:
>  	spin_lock(&nm_i->free_nid_list_lock);
>  
>  	/* We should not use stale free nids created by build_free_nids */
> -	if (nm_i->fcnt && !on_build_free_nids(nm_i)) {
> +	if (on_build_free_nids(nm_i)) {
> +		spin_unlock(&nm_i->free_nid_list_lock);
> +		wait_event(nm_i->build_wq, !on_build_free_nids(nm_i));
> +		goto retry;
> +	}
> +

It would be better moving spin_lock(free_nid_list_lock) here after
removing above spin_unlock().

> +	if (nm_i->fcnt) {
>  		f2fs_bug_on(list_empty(&nm_i->free_nid_list));
>  		list_for_each(this, &nm_i->free_nid_list) {
>  			i = list_entry(this, struct free_nid, list);
> @@ -1443,6 +1449,7 @@ retry:
>  	mutex_lock(&nm_i->build_lock);
>  	build_free_nids(sbi);
>  	mutex_unlock(&nm_i->build_lock);
> +	wake_up_all(&nm_i->build_wq);
>  	goto retry;
>  }
>  
> @@ -1813,6 +1820,7 @@ static int init_node_manager(struct f2fs_sb_info *sbi)
>  	INIT_LIST_HEAD(&nm_i->dirty_nat_entries);
>  
>  	mutex_init(&nm_i->build_lock);
> +	init_waitqueue_head(&nm_i->build_wq);
>  	spin_lock_init(&nm_i->free_nid_list_lock);
>  	rwlock_init(&nm_i->nat_tree_lock);
>  


