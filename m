Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753248AbaCJFjk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 01:39:40 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:19984 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaCJFji convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 01:39:38 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-25-531d50194974
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1394429876.3870.97.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary slightly
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: "'Gu Zheng'" <guz.fnst@cn.fujitsu.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
Date: Mon, 10 Mar 2014 14:37:56 +0900
In-reply-to: <000901cf3c1f$9611b7b0$c2352710$@samsung.com>
References: <5319A2D8.70409@cn.fujitsu.com> <1394426742.3870.89.camel@kjgkr>
 <000901cf3c1f$9611b7b0$c2352710$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOIsWRmVeSWpSXmKPExsVy+t8zY13JANlggwk97Bb/mz6yWTxvP8Bs
	cWmRu8XlXXPYHFg8/h+cxOyxe8FnJo++LasYPT5vkgtgieKySUnNySxLLdK3S+DKmDX3H1PB
	bd2KtT/SGhj/KHYxcnJICJhIXLuwlQnCFpO4cG89WxcjF4eQwDJGidcfpzDDFM2fe5gFIrGI
	UWJe9012kASvgKDEj8n3WEBsZgF1iUnzFjFD2CISF9Z9ZIOwtSWWLXzNDNH8ilHi9rEnUM06
	EiceXGYFsYUFAiT+rO0GKuLgYANq2LzfACQsJKAo8Xb/XbASEQEliV/zF7FCzOxhlFjelwdi
	swioSuye/gWslVPASqL/PiNEa43Eqp3TwE7jFxCVOLxwO9QvShK72zvZQc6REDjFLnFi/xkm
	iDkCEt8mH2IBmSMhICux6QBUvaTEwRU3WCYwSs5C8vEsJB/PQvLxLCQfL2BkWcUomlqQXFCc
	lF5kqFecmFtcmpeul5yfu4kREqm9OxhvH7A+xJgMtH4is5Rocj4w0vNK4g2NzYwsTE1MjY3M
	Lc1IE1YS5016mBQkJJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgVEoMDiitM3lSezc5dLXxMw0
	e/4etexI6HhRtOt/2+8nOgtTT03Y1R8WY3np9hSfyFvMghPmRLhccnY6FXV+YbBOj5nL1Vab
	E3vVmVm0WNa+U9Y8bG/Fwxvb9uPz+yd+kgLKu77Hqv7Tl5qslijuO01Ms612tel3yW2bc4u4
	/4vd2775btK+NiWW4oxEQy3mouJEANdNoiLqAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFKsWRmVeSWpSXmKPExsVy+t9jAV3JANlgg517mSz+N31ks3jefoDZ
	4tIid4vLu+awObB4/D84idlj94LPTB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmNEyOaVgpW5F483VzA2MpxS7GDk5JARMJObPPcwCYYtJXLi3nq2L
	kYtDSGARo8S87pvsIAleAUGJH5PvARVxcDALyEscuZQNEmYWUJeYNG8RM0T9K0aJ28eeQNXr
	SJx4cJkVxBYWCJD4s7abGaSXTUBbYvN+A5CwkICixNv9d8FKRASUJH7NX8QKMbOHUWJ5Xx6I
	zSKgKrF7+hewVk4BK4n++4wQrTUSq3ZOAzuZX0BU4vDC7cwQ5ytJ7G7vZJ/AKDQLydGzEI6e
	heToBYzMqxhFUwuSC4qT0nON9IoTc4tL89L1kvNzNzGCY/qZ9A7GVQ0WhxgFOBiVeHgPvJUJ
	FmJNLCuuzD3EKMHBrCTCy2UoGyzEm5JYWZValB9fVJqTWnyIMRno7onMUqLJ+cB0k1cSb2hs
	YmZkaWRmYWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjNMfvt6w4ObEz8svuk2/
	1X3q3CfNi0qLz++3n6GaeLtzNe+Ud493KO0MPDeXXfiubeGtpumG/KZWpu6mXD7hd4o/iebe
	i08oPR1wflFxprjp2pczdA8daeHZb6K7tlCp2HLX5J+2LFMm6eivzNn9Suns/prZCRu03HZL
	JfMvnBnU++HDlfTOOf+VWIozEg21mIuKEwFSfteALQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-10 (월), 13:13 +0800, Chao Yu:
> Hi Gu, Kim:
> 
> One more comment.
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Monday, March 10, 2014 12:46 PM
> > To: Gu Zheng
> > Cc: linux-kernel; f2fs
> > Subject: Re: [f2fs-dev] [PATCH 4/5] f2fs: optimize restore_node_summary slightly
> > 
> > Hi Gu,
> > 
> > 2014-03-07 (금), 18:43 +0800, Gu Zheng:
> > > Previously, we ra_sum_pages to pre-read contiguous pages as more
> > > as possible, and if we fail to alloc more pages, an ENOMEM error
> > > will be reported upstream, even though we have alloced some pages
> > > yet. In fact, we can use the available pages to do the job partly,
> > > and continue the rest in the following circle. Only reporting ENOMEM
> > > upstream if we really can not alloc any available page.
> > >
> > > And another fix is ignoring dealing with the following pages if an
> > > EIO occurs when reading page from page_list.
> > >
> > > Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> 
> Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> 
> > > ---
> > >  fs/f2fs/node.c    |   44 ++++++++++++++++++++------------------------
> > >  fs/f2fs/segment.c |    7 +++++--
> > >  2 files changed, 25 insertions(+), 26 deletions(-)
> > >
> > > diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> > > index 8787469..4b7861d 100644
> > > --- a/fs/f2fs/node.c
> > > +++ b/fs/f2fs/node.c
> > > @@ -1588,15 +1588,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> > *pages,
> > >  	for (; page_idx < start + nrpages; page_idx++) {
> > >  		/* alloc temporal page for read node summary info*/
> > >  		page = alloc_page(GFP_F2FS_ZERO);
> > > -		if (!page) {
> > > -			struct page *tmp;
> > > -			list_for_each_entry_safe(page, tmp, pages, lru) {
> > > -				list_del(&page->lru);
> > > -				unlock_page(page);
> > > -				__free_pages(page, 0);
> > > -			}
> > > -			return -ENOMEM;
> > > -		}
> > > +		if (!page)
> > > +			break;
> > >
> > >  		lock_page(page);
> > >  		page->index = page_idx;
> > > @@ -1607,7 +1600,8 @@ static int ra_sum_pages(struct f2fs_sb_info *sbi, struct list_head
> > *pages,
> > >  		f2fs_submit_page_mbio(sbi, page, page->index, &fio);
> > >
> > >  	f2fs_submit_merged_bio(sbi, META, READ);
> > > -	return 0;
> > > +
> > > +	return page_idx - start;
> > >  }
> > >
> > >  int restore_node_summary(struct f2fs_sb_info *sbi,
> > > @@ -1630,28 +1624,30 @@ int restore_node_summary(struct f2fs_sb_info *sbi,
> > >  		nrpages = min(last_offset - i, bio_blocks);
> > >
> > >  		/* read ahead node pages */
> > > -		err = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > -		if (err)
> > > -			return err;
> > > +		nrpages = ra_sum_pages(sbi, &page_list, addr, nrpages);
> > > +		if (!nrpages)
> > > +			return -ENOMEM;
> > >
> > >  		list_for_each_entry_safe(page, tmp, &page_list, lru) {
> > > -
> > 
> > Here we can just add:
> > 			if (err)
> > 				goto skip;
> > 			lock_page();
> > 			...
> > 			unlock_page();
> > 		skip:
> > 			list_del();
> > 			__free_pages();
> > 
> > IMO, it's more neat, so if you have any objection, let me know.
> > Otherwise, I'll handle this by myself. :)
> > Thanks,
> > 
> > > -			lock_page(page);
> > > -			if (unlikely(!PageUptodate(page))) {
> > > -				err = -EIO;
> > > -			} else {
> > > -				rn = F2FS_NODE(page);
> > > -				sum_entry->nid = rn->footer.nid;
> > > -				sum_entry->version = 0;
> > > -				sum_entry->ofs_in_node = 0;
> > > -				sum_entry++;
> > > +			if (!err) {
> 
> If we skip here, next round we will fill these summary page entries with
> wrong info because we skip the code 'sum_entry++;'.

There is no next round. Once err = -EIO, there's no route to make err =
0.

> 
> > > +				lock_page(page);
> > > +				if (unlikely(!PageUptodate(page))) {
> > > +					err = -EIO;
> > > +				} else {
> > > +					rn = F2FS_NODE(page);
> > > +					sum_entry->nid = rn->footer.nid;
> > > +					sum_entry->version = 0;
> > > +					sum_entry->ofs_in_node = 0;
> > > +					sum_entry++;
> > > +				}
> > > +				unlock_page(page);
> > >  			}
> > >
> > >  			list_del(&page->lru);
> > > -			unlock_page(page);
> > >  			__free_pages(page, 0);
> > >  		}
> 
> Maybe we should add code here.
> 			if (err)
> 				return err;

This can reduce unnecessary loop executions.
I'll add this.
Thanks,

> 
> > >  	}
> > > +
> > >  	return err;
> > >  }
> > >
> > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > index 199c964..b3f8431 100644
> > > --- a/fs/f2fs/segment.c
> > > +++ b/fs/f2fs/segment.c
> > > @@ -1160,9 +1160,12 @@ static int read_normal_summaries(struct f2fs_sb_info *sbi, int type)
> > >  				ns->ofs_in_node = 0;
> > >  			}
> > >  		} else {
> > > -			if (restore_node_summary(sbi, segno, sum)) {
> > > +			int err;
> > > +
> > > +			err = restore_node_summary(sbi, segno, sum);
> > > +			if (err) {
> > >  				f2fs_put_page(new, 1);
> > > -				return -EINVAL;
> > > +				return err;
> > >  			}
> > >  		}
> > >  	}
> > 
> > --
> > Jaegeuk Kim
> > Samsung
> > 
> > 
> > ------------------------------------------------------------------------------
> > Learn Graph Databases - Download FREE O'Reilly Book
> > "Graph Databases" is the definitive new guide to graph databases and their
> > applications. Written by three acclaimed leaders in the field,
> > this first edition is now available. Download your free book today!
> > http://p.sf.net/sfu/13534_NeoTech
> > _______________________________________________
> > Linux-f2fs-devel mailing list
> > Linux-f2fs-devel@lists.sourceforge.net
> > https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> 

-- 
Jaegeuk Kim
Samsung

