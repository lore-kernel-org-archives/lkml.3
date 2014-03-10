Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753074AbaCJC1z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 22:27:55 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58325 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaCJC1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 22:27:54 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee690-b7f266d00000287c-ca-531d23273a53
Content-transfer-encoding: 8BIT
Message-id: <1394418371.3870.87.camel@kjgkr>
Subject: Re: [f2fs-dev] [PATCH 1/5] f2fs: update start nid only once each circle
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: Chao Yu <chao2.yu@samsung.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'f2fs'" <linux-f2fs-devel@lists.sourceforge.net>
Date: Mon, 10 Mar 2014 11:26:11 +0900
In-reply-to: <531D161C.8080001@cn.fujitsu.com>
References: <5319A2CC.3090206@cn.fujitsu.com>
 <001301cf3ac4$3220b8c0$96622a40$@samsung.com> <531D161C.8080001@cn.fujitsu.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zY111ZdlggynXLCz+N31ks3jefoDZ
	4tIid4vLu+awObB4/D84idlj94LPTB59W1YxenzeJBfAEsVlk5Kak1mWWqRvl8CVsXL3NZaC
	jSIVfxf8ZGlgnCTQxcjJISFgInHuxEpGCFtM4sK99WxdjFwcQgLLGCVOX9zGBFN0Y/tcFojE
	dEaJ7813WUASvAKCEj8m3wOyOTiYBeQljlzKBgkzC6hLTJq3iBnEFhJ4xShxfkMRRLmOxKK5
	b8HiwgIBEktvtYK1sgloS2zebwBRrijxdv9dVhBbREBN4tm7S0wga5kF2hgl1l1dA3Yoi4Cq
	xJx9D9hBbE4BPYnN7QdYIZrrJa5dawabzy8gKnF44XZmiPuVJHa3d7KDDJIQOMUusfTaFSaI
	QQIS3yYfAjtCQkBWYtMBqHpJiYMrbrBMYJSYheTLWQhfzkLy5QJG5lWMoqkFyQXFSelFJnrF
	ibnFpXnpesn5uZsYIZE3YQfjvQPWhxiTgTZOZJYSTc4HRm5eSbyhsZmRhamJqbGRuaUZacJK
	4rxqj5KChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTAuyNPL3+AUKR94O84tLVB/cs2lqIkF
	LVJ+p5PWv9h+aeNVDz+7juClzgwh9qs5ZSorVql+Evq0J4HV4kGZ1vuEzCmOM5MXiTnzHNqU
	PO2y2Z03fglm6yQmr3Nm+1z07tYylcMb/x14P9lt1q/UupbFXQmH17/4vrsssf5RXXPn7fLI
	1fd8PysrsRRnJBpqMRcVJwIA0maaBNICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jQV11Zdlggy//TSz+N31ks3jefoDZ
	4tIid4vLu+awObB4/D84idlj94LPTB59W1YxenzeJBfAEtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtFJJoSwxpxQoFJBYXKykb4dpQmiIm64F
	TGOErm9IEFyPkQEaSFjHmLFy9zWWgo0iFX8X/GRpYJwk0MXIySEhYCJxY/tcFghbTOLCvfVs
	XYxcHEIC0xklvjffBUvwCghK/Jh8D8jm4GAWkJc4cikbJMwsoC4xad4iZhBbSOAVo8T5DUUQ
	5ToSi+a+BYsLCwRILL3VCtbKJqAtsXm/AUS5osTb/XdZQWwRATWJZ+8uMYGsZRZoY5RYd3UN
	I0iCRUBVYs6+B+wgNqeAnsTm9gOsEM31EteuNYPN5xcQlTi8cDszxP1KErvbO9knMArNQnL1
	LISrZyG5egEj8ypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Lh+Jr2DcVWDxSFGAQ5GJR7e
	A29lgoVYE8uKK3MPMUpwMCuJ8MaeAwrxpiRWVqUW5ccXleakFh9iTAY6fCKzlGhyPjDl5JXE
	GxqbmBlZGplZGJmYm5MmrCTOe7DVOlBIID2xJDU7NbUgtQhmCxMHp1QDo1JZyqMJH3MPz/w8
	ewHbpTD2U0YmiQfff3mkkrrBa3n3qnXX2HRq7L+YXn75Tn/h3FiDqxzev9guqFateitZ7eCq
	nxI2bcu9GaVT4vZUnLJ5+GbJK7GP6S48nBWavJ3XS5+5XFq7yG5XvE9CT/2Dq5qF11Xt9I3T
	ti/x3HAgILZVq8VA1tXprxJLcUaioRZzUXEiAMemU28vAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'll handle them all by myself.
Thank you for the contribution. :)

2014-03-10 (월), 09:32 +0800, Gu Zheng:
> On 03/08/2014 07:46 PM, Chao Yu wrote:
> 
> > Hi Gu,
> > 
> >> -----Original Message-----
> >> From: Gu Zheng [mailto:guz.fnst@cn.fujitsu.com]
> >> Sent: Friday, March 07, 2014 6:43 PM
> >> To: Kim
> >> Cc: linux-kernel; f2fs
> >> Subject: [f2fs-dev] [PATCH 1/5] f2fs: update start nid only once each circle
> >>
> >>
> >> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
> > 
> > Reviewed-by: Chao Yu <chao2.yu@samsung.com>
> > 
> >> ---
> >>  fs/f2fs/node.c |    6 +++++-
> >>  1 files changed, 5 insertions(+), 1 deletions(-)
> >>
> >> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> >> index 8c14110..9653096 100644
> >> --- a/fs/f2fs/node.c
> >> +++ b/fs/f2fs/node.c
> >> @@ -1875,11 +1875,15 @@ void destroy_node_manager(struct f2fs_sb_info *sbi)
> >>  	while ((found = __gang_lookup_nat_cache(nm_i,
> >>  					nid, NATVEC_SIZE, natvec))) {
> >>  		unsigned idx;
> >> +
> >> +		nid = nat_get_nid(natvec[found - 1]) + 1;
> >> +
> >>  		for (idx = 0; idx < found; idx++) {
> >>  			struct nat_entry *e = natvec[idx];
> > 
> > Could we replace argument 'e' with 'natvec[idx]'? then we could remove 'e' and
> > brace here.
> 
> Agree. More neat with this cleanup.
> 
> Regards,
> Gu
> 
> > 
> > Thanks.
> > 
> >> -			nid = nat_get_nid(e) + 1;
> >> +
> >>  			__del_from_nat_cache(nm_i, e);
> >>  		}
> >> +
> >>  	}
> >>  	f2fs_bug_on(nm_i->nat_cnt);
> >>  	write_unlock(&nm_i->nat_tree_lock);
> >> --
> >> 1.7.7
> >>
> >>
> >> ------------------------------------------------------------------------------
> >> Subversion Kills Productivity. Get off Subversion & Make the Move to Perforce.
> >> With Perforce, you get hassle-free workflows. Merge that actually works.
> >> Faster operations. Version large binaries.  Built-in WAN optimization and the
> >> freedom to use Git, Perforce or both. Make the move to Perforce.
> >> http://pubads.g.doubleclick.net/gampad/clk?id=122218951&iu=/4140/ostg.clktrk
> >> _______________________________________________
> >> Linux-f2fs-devel mailing list
> >> Linux-f2fs-devel@lists.sourceforge.net
> >> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
> > 
> > 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

