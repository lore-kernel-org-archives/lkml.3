Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934539Ab3IDJkq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:40:46 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:32687 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934402Ab3IDJko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:40:44 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f3b6d000007a15-c9-5227001a6f38
Content-transfer-encoding: 8BIT
Message-id: <1378287635.2354.84.camel@kjgkr>
Subject: Re: [PATCH] f2fs: optimize gc for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jin Xu <jinuxstyle@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Sep 2013 18:40:35 +0900
In-reply-to: <522677ED.8090203@gmail.com>
References: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com>
 <1377777368.2354.46.camel@kjgkr> <52201A4F.9020808@gmail.com>
 <1378169118.2354.56.camel@kjgkr> <522677ED.8090203@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFIsWRmVeSWpSXmKPExsVy+t8zY10pBvUgg5cbhC12PjnNbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzFZZOSmpNZllqkb5fAlbHs0kG2ghOmFe9m
	7GZuYHyr0cXIySEhYCJx5MImNghbTOLCvfVANheHkMAyRonOtpesMEUzr69lhUgsYpSY/Osw
	WAevgKDEj8n3WLoYOTiYBeQljlzKBgkzC6hLTJq3iBmi/jWjxLorP5kh6nUk2p/uA7OFBWwl
	/p+azwrSyyagLbF5vwFIWEhAUeLt/rtgYREg+9M+aYiRmRL3mmaAdbIIqEqsWfEM7DROAU2J
	Bx92QZ12hFGi7csuJpAEv4CoxOGF25kh7leS2N3eyQ5SJCFwiF3i1o497BCTBCS+TT4Edr+E
	gKzEpgNQ9ZISB1fcYJnAKDELyZezEL6cheTLBYzMqxhFUwuSC4qT0otM9IoTc4tL89L1kvNz
	NzFC4m3CDsZ7B6wPMSYDbZzILCWanA+M17ySeENjMyMLUxNTYyNzSzPShJXEedVbrAOFBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MAocV/noJFJ597rn1E0MCslsX7kDGmV2vHrhmGOu6dPu
	JRf2LiveY3Ioz7OeWJ1N/8pT9Bh+/JetnNLaUtAvnNRQ+pldmb+tnLHBrqHo5tfvutetJwmf
	FQgr+V3wYI2D1advQU2FyheOcOnXP3EuVddXPPvDVSPuXxz3lXldRpdLVwQUH52gxFKckWio
	xVxUnAgAZBzXxs0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprOKsWRmVeSWpSXmKPExsVy+t9jAV0pBvUggwWz+Cx2PjnNbHFpkbvF
	nr0nWSwu75rD5sDisXPWXXaP3Qs+M3l83iQXwBzVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8c
	b2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA7RNSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5v
	SBBcj5EBGkhYx5ix7NJBtoITphXvZuxmbmB8q9HFyMkhIWAiMfP6WlYIW0ziwr31bF2MXBxC
	AosYJSb/OswGkuAVEJT4MfkeSxcjBwezgLzEkUvZIGFmAXWJSfMWMUPUv2aUWHflJzNEvY5E
	+9N9YLawgK3E/1PzWUF62QS0JTbvNwAJCwkoSrzdfxcsLAJkf9onDTEyU+Je0wywThYBVYk1
	K56BncYpoCnx4MMuVohVRxgl2r7sYgJJ8AuIShxeuJ0Z4n4lid3tnewTGIVmIbl6FsLVs5Bc
	vYCReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcDQ/k97BuKrB4hCjAAejEg/vQXu1ICHW
	xLLiytxDjBIczEoivIc+A4V4UxIrq1KL8uOLSnNSiw8xJgNdPpFZSjQ5H5ho8kriDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBUfuGYGnH77myeS8meNbrpmwK
	4b7c/njTtex/jdPvHthZdbpcMJVP8VvPxA/WZzi9H7dF3brTtl941YLb81qW6OfN5PS+oda1
	SsvzuNXl1RZTD/JNPzfr0+Jpbz172M+xL5F1W3O0VM7W/qxolmiBinTWgyVFcyYsE+DIj2i0
	cvr3r1M0yiTVUImlOCPRUIu5qDgRACsa4pEqAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

2013-09-04 (수), 07:59 +0800, Jin Xu:
> Hi Jaegeuk,
> 
> On 03/09/2013 08:45, Jaegeuk Kim wrote:
> > Hi Jin,
> >
> >> [...]
> >>>
> >>> It seems that we can obtain the performance gain just by setting the
> >>> MAX_VICTIM_SEARCH to 4096, for example.
> >>> So, how about just adding an ending criteria like below?
> >>>
> >>
> >> I agree that we could get the performance improvement by simply
> >> enlarging the MAX_VICTIM_SEARCH to 4096, but I am concerning the
> >> scalability a little bit. Because it might always searching the whole
> >> bitmap in some cases, for example, when dirty segments is 4000 and
> >> total segments is 409600.
> >>> [snip]
> >> [...]
> >>>
> >>> 	if (p->max_search > MAX_VICTIM_SEARCH)
> >>> 		p->max_search = MAX_VICTIM_SEARCH;
> >>>
> >>
> >> The optimization does not apply to SSR mode. There has a reason.
> >> As noticed in the test, when SSR selected the segments that have most
> >> garbage blocks, then when gc is needed, all the dirty segments might
> >> have very less garbage blocks, thus the gc overhead is high. This might
> >> lead to performance degradation. So the patch does not change the
> >> victim selection policy for SSR.
> >
> > I think it doesn't care.
> > GC is only triggered during the direct node block allocation.
> > What it means that we need to consider the number of GC triggers where
> > the GC triggers more frequently during the normal data allocation than
> > the node block allocation.
> > So, I think it would not degrade performance significatly.
> >
> > BTW, could you show some numbers for this?
> > Or could you test what I suggested?
> >
> > Thanks,
> >
> 
> I re-ran the test and got the following result:
> 
> ---------------------------------------
> 2GB SDHC
> create 52023 files of size 32768 bytes
> random re-write 100000 records of 4KB
> ---------------------------------------
> 
> | file creation (s) | rewrite time (s) | gc count | gc garbage blocks |
> 
> no patch       341         4227             1174          174840
> patched        296         2995             634           109314
> patched (KIM)  324         2958             645           106682
> 
> In this test, it does not show the minor performance degradation caused
> by applying the patch to SSR mode. Instead, the performance is a little 
> better with what you suggested.
> 
> I agree that the performance degradation would not be significant even
> it does degrade. I ever saw the minor degradation in some workloads, but
> I didn't save the data.
> 
> So, I agree that we can apply the patch to SSR mode as well.
> 
> And do you still have concerns about the formula for calculating the #
> of search?

Thank you for the test. :)
What I've concerned is that, if it is really important to get a victim
more accurately for the performance as you described, it doesn't need to
calculate the number of searches IMO. Just let's select nr_dirty. Why
not?
Only the thing that we should consider is to handle the case where the
nr_dirty is too large.
For this, we can just limit the # of searches to avoid performance
degradation.

Still actually, I'm not convincing the effectiveness of your formula.
If possible, could you show it with numbers?

Thanks,

> 
> >>
> >> What do you think now?
> >>
> >>> #define MAX_VICTIM_SEARCH 4096 /* covers 8GB */
> >>>
> >>>>    	p->offset = sbi->last_victim[p->gc_mode];
> >>>> @@ -243,6 +245,8 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
> >>>>    	struct victim_sel_policy p;
> >>>>    	unsigned int secno, max_cost;
> >>>>    	int nsearched = 0;
> >>>> +	unsigned int max_search = MAX_VICTIM_SEARCH;
> >>>> +	unsigned int nr_dirty;
> >>>>
> >>>>    	p.alloc_mode = alloc_mode;
> >>>>    	select_policy(sbi, gc_type, type, &p);
> >>>> @@ -258,6 +262,27 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
> >>>>    			goto got_it;
> >>>>    	}
> >>>>
> >>>> +	nr_dirty = dirty_i->nr_dirty[p.dirty_type];
> >>>> +	if (p.gc_mode == GC_GREEDY && p.alloc_mode != SSR) {
> >>>> +		if (TOTAL_SEGS(sbi) <= FULL_VICTIM_SEARCH_THRESH)
> >>>> +			max_search = nr_dirty; /* search all the dirty segs */
> >>>> +		else {
> >>>> +			/*
> >>>> +			 * With more dirty segments, garbage blocks are likely
> >>>> +			 * more scattered, thus search harder for better
> >>>> +			 * victim.
> >>>> +			 */
> >>>> +			max_search = div_u64 ((nr_dirty *
> >>>> +				FULL_VICTIM_SEARCH_THRESH), TOTAL_SEGS(sbi));
> >>>> +			if (max_search < MIN_VICTIM_SEARCH_GREEDY)
> >>>> +				max_search = MIN_VICTIM_SEARCH_GREEDY;
> >>>> +		}
> >>>> +	}
> >>>> +
> >>>> +	/* no more than the total dirty segments */
> >>>> +	if (max_search > nr_dirty)
> >>>> +		max_search = nr_dirty;
> >>>> +
> >>>>    	while (1) {
> >>>>    		unsigned long cost;
> >>>>    		unsigned int segno;
> >>>> @@ -290,7 +315,7 @@ static int get_victim_by_default(struct f2fs_sb_info *sbi,
> >>>>    		if (cost == max_cost)
> >>>>    			continue;
> >>>>
> >>>> -		if (nsearched++ >= MAX_VICTIM_SEARCH) {
> >>>> +		if (nsearched++ >= max_search) {
> >>>
> >>> 		if (nsearched++ >= p.max_search) {
> >>>
> >>>>    			sbi->last_victim[p.gc_mode] = segno;
> >>>>    			break;
> >>>>    		}
> >>>> diff --git a/fs/f2fs/gc.h b/fs/f2fs/gc.h
> >>>> index 2c6a6bd..2f525aa 100644
> >>>> --- a/fs/f2fs/gc.h
> >>>> +++ b/fs/f2fs/gc.h
> >>>> @@ -20,7 +20,9 @@
> >>>>    #define LIMIT_FREE_BLOCK	40 /* percentage over invalid + free space */
> >>>>
> >>>>    /* Search max. number of dirty segments to select a victim segment */
> >>>> -#define MAX_VICTIM_SEARCH	20
> >>>> +#define MAX_VICTIM_SEARCH		20
> >>>> +#define MIN_VICTIM_SEARCH_GREEDY	20
> >>>> +#define FULL_VICTIM_SEARCH_THRESH	4096
> >>>>
> >>>>    struct f2fs_gc_kthread {
> >>>>    	struct task_struct *f2fs_gc_task;
> >>>> diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
> >>>> index 062424a..cd33f96 100644
> >>>> --- a/fs/f2fs/segment.h
> >>>> +++ b/fs/f2fs/segment.h
> >>>> @@ -142,6 +142,7 @@ struct victim_sel_policy {
> >>>>    	int alloc_mode;			/* LFS or SSR */
> >>>>    	int gc_mode;			/* GC_CB or GC_GREEDY */
> >>>>    	unsigned long *dirty_segmap;	/* dirty segment bitmap */
> >>>> +	int dirty_type;
> >>>
> >>> 	int max_search;		/* maximum # of segments to search */
> >>>
> >>>>    	unsigned int offset;		/* last scanned bitmap offset */
> >>>>    	unsigned int ofs_unit;		/* bitmap search unit */
> >>>>    	unsigned int min_cost;		/* minimum cost */
> >>>
> >>
> >
> 
> --
> Thanks,
> Jin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

