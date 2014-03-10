Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753059AbaCJEr0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 00:47:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:29141 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbaCJErY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 00:47:24 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-da-531d43dabc61
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1394426742.3870.89.camel@kjgkr>
Subject: Re: [PATCH 4/5] f2fs: optimize restore_node_summary slightly
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: f2fs <linux-f2fs-devel@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 10 Mar 2014 13:45:42 +0900
In-reply-to: <5319A2D8.70409@cn.fujitsu.com>
References: <5319A2D8.70409@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zI91bzrLBBmd3Klg8bz/AbHFpkbvF
	5V1z2ByYPf4fnMTssXvBZyaPz5vkApijuGxSUnMyy1KL9O0SuDJmzF7DVLBSrmLfiiVMDYyv
	xboYOTkkBEwkWv91skPYYhIX7q1n62Lk4hASWMYosepmFxNMUd/rjewQiUWMEpNWn2IESfAK
	CEr8mHyPBcRmFlCXmDRvETOELSJx8tA8KFtbYtnC18wQza8YJa7vXcYE0awj0fT+EpgtLOAq
	0d55G2goBwcbUMPm/QYgYSEBRYm3+++ygtgiAmoSz95BlDMLJEg8PN8PFmcRUJXonNrCAtLK
	CTTy62R1iFZtiYM7l7CB2PwCohKHF25nhvhFSWJ3eyfYLxICu9glTh1axgwxR0Di2+RDYHMk
	BGQlNh2AqpeUOLjiBssERslZSD6eheTjWUg+noXk4wWMLKsYRVMLkguKk9KLDPWKE3OLS/PS
	9ZLzczcxQuKydwfj7QPWhxiTgdZPZJYSTc4HxnVeSbyhsZmRhamJqbGRuaUZacJK4rxJD5OC
	hATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDuZ7b6ky1/3eSESqild///oLSEBtGF0519mqdK
	nHy6Q/e0qOHtF90esju1UnaJzEnzYA/8F7LKfDv7T4c94jeO8jAF2MdNcuQMDelIm3k/0rZm
	1s/aw1tSZ0w2FVvxunn3jMK5QgkbythnvC35tmTZVr+rLWLttjbCzvP0Undl984/6Hil75IS
	S3FGoqEWc1FxIgBL8BbG4QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t9jAd1bzrLBBuuOylg8bz/AbHFpkbvF
	5V1z2ByYPf4fnMTssXvBZyaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1
	DS0tzJUU8hJzU22VXHwCdN0yc4AWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEy
	QAMJ6xgz3i54x1zQKFcxe+Eh5gbGw2JdjJwcEgImEn2vN7JD2GISF+6tZ+ti5OIQEljEKDFp
	9SlGkASvgKDEj8n3WLoYOTiYBeQljlzKBgkzC6hLTJq3iBmi/hWjxPW9y5gg6nUkmt5fArOF
	BVwl2jtvM4L0sgloS2zebwASFhJQlHi7/y4riC0ioCbx7B1EObNAgsTD8/1gcRYBVYnOqS1g
	azmBRn6drA7Rqi1xcOcSNhCbX0BU4vDC7cwQ5ytJ7G7vZJ/AKDQLydGzEI6eheToBYzMqxhF
	UwuSC4qT0nON9IoTc4tL89L1kvNzNzGCI/iZ9A7GVQ0WhxgFOBiVeHgPvJUJFmJNLCuuzD3E
	KMHBrCTCy2UoGyzEm5JYWZValB9fVJqTWnyIMRno7onMUqLJ+cDkklcSb2hsYmZkaWRmYWRi
	bk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjE7Zl2Qd5ggyrdrl8v1IwYre0LMLF6Q6
	L/l8hlXm6kxfpp0vXX0XL3bi819SYq+y+puhiWVG6QLNi3zaTz6xNU3/vkssn8U/gcc3eM2R
	iqwAv8PPJJcsqEjxc61tv6dxmvtIG0PK25nr60se3Lm6ce5zy5U1W74L1Xx3ds6LMnS+FuOS
	JHX/txJLcUaioRZzUXEiAL55J7kkAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gu,

2014-03-07 (금), 18:43 +0800, Gu Zheng:
> Previously, we ra_sum_pages to pre-read contiguous pages as more
> as possible, and if we fail to alloc more pages, an ENOMEM error
> will be reported upstream, even though we have alloced some pages
> yet. In fact, we can use the available pages to do the job partly,
> and continue the rest in the following circle. Only reporting ENOMEM
> upstream if we really can not alloc any available page.
> 
> And another fix is ignoring dealing with the following pages if an
> EIO occurs when reading page from page_list.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> ---
>  fs/f2fs/node.c    |   44 ++++++++++++++++++++------------------------
>  fs/f2fs/segment.c |    7 +++++--
>  2 files changed, 25 insertions(+), 26 deletions(-)
> 
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 8787469..4b7861d 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1588,15 +1588,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
>  	for (; page_idx < start + nrpages; page_idx++) {
>  		/* alloc temporal page for read node summary info*/
>  		page = alloc_page(GFP_F2FS_ZERO);
> -		if (!page) {
> -			struct page *tmp;
> -			list_for_each_entry_safe(page, tmp, pages, lru) {
> -				list_del(&page->lru);
> -				unlock_page(page);
> -				__free_pages(page, 0);
> -			}
> -			return -ENOMEM;
> -		}
> +		if (!page)
> +			break;
>  
>  		lock_page(page);
>  		page->index = page_idx;
> @@ -1607,7 +1600,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head *pages,
>  		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
>  
>  	f2fs_submit_merged_bio(sbi, META, READ);
> -	return 0;
> +
> +	return page_idx - start;
>  }
>  
>  int restore_node_summary(struct f2fs_sb_info *sbi,
> @@ -1630,28 +1624,30 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
>  		nrpages = min(last_offset - i, bio_blocks);
>  
>  		/* read ahead node pages */
> -		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> -		if (err)
> -			return err;
> +		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> +		if (!nrpages)
> +			return -ENOMEM;
>  
>  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> -

Here we can just add:
			if (err)
				goto skip;
			lock_page();
			...
			unlock_page();
		skip:
			list_del();
			__free_pages();

IMO, it's more neat, so if you have any objection, let me know.
Otherwise, I'll handle this by myself. :)
Thanks,

> -			lock_page(page);
> -			if (unlikely(!PageUptodate(page))) {
> -				err = -EIO;
> -			} else {
> -				rn = F2FS_NODE(page);
> -				sum_entry->nid = rn->footer.nid;
> -				sum_entry->version = 0;
> -				sum_entry->ofs_in_node = 0;
> -				sum_entry++;
> +			if (!err) {
> +				lock_page(page);
> +				if (unlikely(!PageUptodate(page))) {
> +					err = -EIO;
> +				} else {
> +					rn = F2FS_NODE(page);
> +					sum_entry->nid = rn->footer.nid;
> +					sum_entry->version = 0;
> +					sum_entry->ofs_in_node = 0;
> +					sum_entry++;
> +				}
> +				unlock_page(page);
>  			}
>  
>  			list_del(&page->lru);
> -			unlock_page(page);
>  			__free_pages(page, 0);
>  		}
>  	}
> +
>  	return err;
>  }
>  
> diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> index 199c964..b3f8431 100644
> --- a/fs/f2fs/segment.c
> +++ b/fs/f2fs/segment.c
> @@ -1160,9 +1160,12 @@ static int read_normal_summaries(struct f2fs_sb_info *sbi, int type)
>  				ns->ofs_in_node = 0;
>  			}
>  		} else {
> -			if (restore_node_summary(sbi, segno, sum)) {
> +			int err;
> +
> +			err = restore_node_summary(sbi, segno, sum);
> +			if (err) {
>  				f2fs_put_page(new, 1);
> -				return -EINVAL;
> +				return err;
>  			}
>  		}
>  	}

-- 
Jaegeuk Kim
Samsung

