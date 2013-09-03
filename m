Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251Ab3ICAp2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:45:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:63723 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759137Ab3ICAp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:45:26 -0400
X-AuditID: cbfee690-b7f3b6d000007a15-21-522531245a42
Message-id: <1378169118.2354.56.camel@kjgkr>
Subject: Re: [PATCH] f2fs: optimize gc for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jin Xu <jinuxstyle@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 03 Sep 2013 09:45:18 +0900
In-reply-to: <52201A4F.9020808@gmail.com>
References: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com>
 <1377777368.2354.46.camel@kjgkr> <52201A4F.9020808@gmail.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrJIsWRmVeSWpSXmKPExsVy+t8zY10VQ9Ugg7/XTSx2PjnNbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAldF7K7HgrHLFl55v
	7A2Ma6W7GDk5JARMJGbs62SFsMUkLtxbz9bFyMUhJLCMUWLprYlsMEUXtz0Fs4UEFgEl3pZB
	2K8ZJe6cqQKxeQV0JG50P2YEsYUFbCX+n5oPNJSDg01AW2LzfgOIckWJt/vvgoVFgOxP+8BO
	YBbIlLjXNIMZxGYRUJU4f/0w2DmcApoSSzZfgzqnhVFiSUszWIJfQFTi8MLtzBDN6hKT5i1i
	hjhTSWJ3eyc7RFxeYvOat8wQpwlK/Jh8jwVkkITALnaJL6f72SC2CUh8m3yIBeQgCQFZiU0H
	oOZIShxccYNlAqPELCQrZiEZOwvJ2AWMzKsYRVMLkguKk9KLTPSKE3OLS/PS9ZLzczcxQqJt
	wg7GewesDzEmA62cyCwlmpwPjNa8knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NT
	C1KL4otKc1KLDzEycXBKNTCysOxuLrS5d+KB9sL/3ls8zvpMaqh2Z9/kW/a2cC7zk3sHWAU1
	l9Ra5wYtUN9ru54nWiXnYEro/m7WSkaJKyUxqi3HvaYcczmyOXRC8OWNdxicrXTkPss4Rdl6
	+U5cau736fKHhInyiZ4Msbb2QsxLTv9ljej41dz+pTXy36Npm78efuzc26PEUpyRaKjFXFSc
	CADJ0x5dzAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprGKsWRmVeSWpSXmKPExsVy+t9jAV0VQ9Ugg2cdBhY7n5xmtri0yN1i
	z96TLBaXd81hc2Dx2DnrLrvH7gWfmTw+b5ILYI5qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneO
	NzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAdqmpFCWmFMKFApILC5W0rfDNCE0xE3XAqYxQtc3
	JAiux8gADSSsY8zovZVYcFa54kvPN/YGxrXSXYycHBICJhIXtz1lg7DFJC7cWw9mCwksYpRY
	+rYMwn7NKHHnTBWIzSugI3Gj+zEjiC0sYCvx/9R81i5GDg42AW2JzfsNIMoVJd7uvwsWFgGy
	P+0D28QskClxr2kGM4jNIqAqcf76YVYQm1NAU2LJ5mtAW7mAWlsYJZa0NIMl+AVEJQ4v3M4M
	0awuMWneImaIM5Ukdrd3skPE5SU2r3nLDHGaoMSPyfdYJjAKzULSMgtJ2SwkZQsYmVcxiqYW
	JBcUJ6XnGuoVJ+YWl+al6yXn525iBMfyM6kdjCsbLA4xCnAwKvHwcuxVCRJiTSwrrsw9xCjB
	wawkwiv0DSjEm5JYWZValB9fVJqTWnyIMRnovYnMUqLJ+cA0k1cSb2hsYmZkaWRmYWRibk6a
	sJI474FW60AhgfTEktTs1NSC1CKYLUwcnFINjCGCoo90Tu+Xunf3RFfOz4Pi14QcAnX09h04
	cnLrcYWZMyMeL2bumrmr89/pb/ssTjY11l/RO8T6cvbSld0vN7WdWJKXc9d48jsW7ZIX+St/
	FSeHW7DOZZz48PDKWH7b+2xnHs1k5M1ssSkXfy3x3vTX0Q9Mk5g3efhnTwz4u3jvusX6k1aw
	nnqpxFKckWioxVxUnAgA51gaXikDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

> [...]
> >
> > It seems that we can obtain the performance gain just by setting the
> > MAX_VICTIM_SEARCH to 4096, for example.
> > So, how about just adding an ending criteria like below?
> >
> 
> I agree that we could get the performance improvement by simply
> enlarging the MAX_VICTIM_SEARCH to 4096, but I am concerning the
> scalability a little bit. Because it might always searching the whole
> bitmap in some cases, for example, when dirty segments is 4000 and
> total segments is 409600.
> > [snip]
> [...]
> >
> > 	if (p->max_search > MAX_VICTIM_SEARCH)
> > 		p->max_search = MAX_VICTIM_SEARCH;
> >
> 
> The optimization does not apply to SSR mode. There has a reason.
> As noticed in the test, when SSR selected the segments that have most
> garbage blocks, then when gc is needed, all the dirty segments might
> have very less garbage blocks, thus the gc overhead is high. This might
> lead to performance degradation. So the patch does not change the
> victim selection policy for SSR.

I think it doesn't care.
GC is only triggered during the direct node block allocation.
What it means that we need to consider the number of GC triggers where
the GC triggers more frequently during the normal data allocation than
the node block allocation.
So, I think it would not degrade performance significatly.

BTW, could you show some numbers for this?
Or could you test what I suggested?

Thanks,

> 
> What do you think now?
> 
> > #define MAX_VICTIM_SEARCH 4096 /* covers 8GB */
> >
> >>   	p->offset = sbi->last_victim[p->gc_mode];
> >> @@ -243,6 +245,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
> >>   	struct victim_sel_policy p;
> >>   	unsigned int secno, max_cost;
> >>   	int nsearched = 0;
> >> +	unsigned int max_search = MAX_VICTIM_SEARCH;
> >> +	unsigned int nr_dirty;
> >>
> >>   	p.alloc_mode = alloc_mode;
> >>   	select_policy(sbi, gc_type, type, &p);
> >> @@ -258,6 +262,27 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
> >>   			goto got_it;
> >>   	}
> >>
> >> +	nr_dirty = dirty_i->nr_dirty[p.dirty_type];
> >> +	if (p.gc_mode == GC_GREEDY && p.alloc_mode != SSR) {
> >> +		if (TOTAL_SEGS(sbi) <= FULL_VICTIM_SEARCH_THRESH)
> >> +			max_search = nr_dirty; /* search all the dirty segs */
> >> +		else {
> >> +			/*
> >> +			 * With more dirty segments, garbage blocks are likely
> >> +			 * more scattered, thus search harder for better
> >> +			 * victim.
> >> +			 */
> >> +			max_search = div_u64 ((nr_dirty *
> >> +				FULL_VICTIM_SEARCH_THRESH), TOTAL_SEGS(sbi));
> >> +			if (max_search < MIN_VICTIM_SEARCH_GREEDY)
> >> +				max_search = MIN_VICTIM_SEARCH_GREEDY;
> >> +		}
> >> +	}
> >> +
> >> +	/* no more than the total dirty segments */
> >> +	if (max_search > nr_dirty)
> >> +		max_search = nr_dirty;
> >> +
> >>   	while (1) {
> >>   		unsigned long cost;
> >>   		unsigned int segno;
> >> @@ -290,7 +315,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
> >>   		if (cost == max_cost)
> >>   			continue;
> >>
> >> -		if (nsearched++ >= MAX_VICTIM_SEARCH) {
> >> +		if (nsearched++ >= max_search) {
> >
> > 		if (nsearched++ >= p.max_search) {
> >
> >>   			sbi->last_victim[p.gc_mode] = segno;
> >>   			break;
> >>   		}
> >> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
> >> index 2c6a6bd..2f525aa 100644
> >> --- a/fs/f2fs/gc.h
> >> +++ b/fs/f2fs/gc.h
> >> @@ -20,7 +20,9 @@
> >>   #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
> >>
> >>   /* Search max. number of dirty segments to select a victim segment */
> >> -#define MAX_VICTIM_SEARCH	20
> >> +#define MAX_VICTIM_SEARCH		20
> >> +#define MIN_VICTIM_SEARCH_GREEDY	20
> >> +#define FULL_VICTIM_SEARCH_THRESH	4096
> >>
> >>   struct f2fs_gc_kthread {
> >>   	struct task_struct *f2fs_gc_task;
> >> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> >> index 062424a..cd33f96 100644
> >> --- a/fs/f2fs/segment.h
> >> +++ b/fs/f2fs/segment.h
> >> @@ -142,6 +142,7 @@ struct victim_sel_policy {
> >>   	int alloc_mode;			/* LFS or SSR */
> >>   	int gc_mode;			/* GC_CB or GC_GREEDY */
> >>   	unsigned long *dirty_segmap;	/* dirty segment bitmap */
> >> +	int dirty_type;
> >
> > 	int max_search;		/* maximum # of segments to search */
> >
> >>   	unsigned int offset;		/* last scanned bitmap offset */
> >>   	unsigned int ofs_unit;		/* bitmap search unit */
> >>   	unsigned int min_cost;		/* minimum cost */
> >
> 

-- 
Jaegeuk Kim
Samsung

