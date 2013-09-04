Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762334Ab3IDXua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 19:50:30 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27355 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756966Ab3IDXu0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 19:50:26 -0400
X-AuditID: cbfee68e-b7f756d000004512-5e-5227c73904c3
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <1378338609.2354.86.camel@kjgkr>
Subject: Re: [PATCH] f2fs: optimize gc for better performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Jin Xu <jinuxstyle@gmail.com>
Cc: linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 05 Sep 2013 08:50:09 +0900
In-reply-to: <522732EB.4020103@gmail.com>
References: <1377737323-11803-1-git-send-email-jinuxstyle@gmail.com>
 <1377777368.2354.46.camel@kjgkr> <52201A4F.9020808@gmail.com>
 <1378169118.2354.56.camel@kjgkr> <522677ED.8090203@gmail.com>
 <1378287635.2354.84.camel@kjgkr> <522732EB.4020103@gmail.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zQ13L4+pBBt8WslrsfHKa2eLSIneL
	PXtPslhc3jWHzYHFY+esu+weuxd8ZvL4vEkugDmKyyYlNSezLLVI3y6BK2P6p8KCfQoVLZ/X
	sDYwPpPoYuTkkBAwkTjcf4YJwhaTuHBvPVsXIxeHkMAyRokLs5azwRQ961rDBJFYxChxcdJB
	sA5eAUGJH5PvsYDYzALqEpPmLWKGsEUkJr5sY4OwtSWWLXzNDNH8mlHi4NT1UM06EotXb2IF
	sYUFbCX+n5oPZHNwsAE1bN5vABIWElCUeLv/LlhYBMj+tE8aYmSmxL2mGWCrWARUJZ7vWskI
	YnMKaEqc7F7LDNHawiTRezEVxOYXEJU4vHA7M8QvShK72zvZQc6RENjHLvGpsZERYpCAxLfJ
	h1hAdkkIyEpsOgBVLylxcMUNlgmMkrOQfDwLycezkHw8C8nHCxhZVjGKphYkFxQnpRcZ6RUn
	5haX5qXrJefnbmKExGffDsabB6wPMSYDrZ/ILCWanA+M77ySeENjMyMLUxNTYyNzSzPShJXE
	edVarAOFBNITS1KzU1MLUovii0pzUosPMTJxcEo1ME4Ju6cuEjdH0vVV5O2IlQJpr+xK3Hg6
	5zaE2nvPPSl880jSi7jTy4yynaVsphxnU5ebfUxs+4++jJZPKtfqElU4FXL+qSYFZZqc/zbh
	mFuNT1PBugu12z+vOJUenHrycayRvuqHiMN8b375cvFbvOO+mLDFdOflJyl8gtuehetduuNs
	3bPwkhJLcUaioRZzUXEiANBfmPXlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKKsWRmVeSWpSXmKPExsVy+t9jAV3L4+pBBjd8LHY+Oc1scWmRu8We
	vSdZLC7vmsPmwOKxc9Zddo/dCz4zeXzeJBfAHNXAaJORmpiSWqSQmpecn5KZl26r5B0c7xxv
	amZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtExJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9I
	EFyPkQEaSFjHmPFv9VPWggUKFU+/bmFpYDwh0cXIySEhYCLxrGsNE4QtJnHh3nq2LkYuDiGB
	RYwSFycdBEvwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh6l8zShycuh6qXkdi8epN
	rCC2sICtxP9T81lBetkEtCU27zcACQsJKEq83X8XLCwCZH/aJw0xMlPiXtMMZhCbRUBV4vmu
	lYwgNqeApsTJ7rXMEK0tTBK9F1NBbH4BUYnDC7czQ5yvJLG7vZN9AqPQLCRHz0I4ehaSoxcw
	Mq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI7kZ9I7GFc1WBxiFOBgVOLhbTBWDxJiTSwr
	rsw9xCjBwawkwmuxEijEm5JYWZValB9fVJqTWnyIMRno8InMUqLJ+cAkk1cSb2hsYmZkaWRm
	YWRibk6asJI478FW60AhgfTEktTs1NSC1CKYLUwcnFINjMuPzPvxQynYKsFH68RpK52/Grp8
	6+NmRBs/rXv89K3eBHGt/8yRfG/MuoQOJE27uu+8e3XCrgufXwcf89i65f+/bUdOfd+5W3KK
	k3n+re88gTwVn3Tjdu8y/2Re9GJvyIyff85cjo5y4tpUl/8m9YeIOKf7mh6eRLWoMNX+M578
	Zo3tgo1NSkosxRmJhlrMRcWJACLrWr4oAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jin,

2013-09-04 (수), 21:17 +0800, Jin Xu:
> Hi Jaegeuk,
> 
> On 04/09/2013 17:40, Jaegeuk Kim wrote:
> > Hi Jin,
> >
> > 2013-09-04 (수), 07:59 +0800, Jin Xu:
> >> Hi Jaegeuk,
> >>
> >> On 03/09/2013 08:45, Jaegeuk Kim wrote:
> >>> Hi Jin,
> >>>
> >>>> [...]
> >>>>>
> >>>>> It seems that we can obtain the performance gain just by setting the
> >>>>> MAX_VICTIM_SEARCH to 4096, for example.
> >>>>> So, how about just adding an ending criteria like below?
> >>>>>
> >>>>
> >>>> I agree that we could get the performance improvement by simply
> >>>> enlarging the MAX_VICTIM_SEARCH to 4096, but I am concerning the
> >>>> scalability a little bit. Because it might always searching the whole
> >>>> bitmap in some cases, for example, when dirty segments is 4000 and
> >>>> total segments is 409600.
> >>>>> [snip]
> >>>> [...]
> >>>>>
> >>>>> 	if (p->max_search > MAX_VICTIM_SEARCH)
> >>>>> 		p->max_search = MAX_VICTIM_SEARCH;
> >>>>>
> >>>>
> >>>> The optimization does not apply to SSR mode. There has a reason.
> >>>> As noticed in the test, when SSR selected the segments that have most
> >>>> garbage blocks, then when gc is needed, all the dirty segments might
> >>>> have very less garbage blocks, thus the gc overhead is high. This might
> >>>> lead to performance degradation. So the patch does not change the
> >>>> victim selection policy for SSR.
> >>>
> >>> I think it doesn't care.
> >>> GC is only triggered during the direct node block allocation.
> >>> What it means that we need to consider the number of GC triggers where
> >>> the GC triggers more frequently during the normal data allocation than
> >>> the node block allocation.
> >>> So, I think it would not degrade performance significatly.
> >>>
> >>> BTW, could you show some numbers for this?
> >>> Or could you test what I suggested?
> >>>
> >>> Thanks,
> >>>
> >>
> >> I re-ran the test and got the following result:
> >>
> >> ---------------------------------------
> >> 2GB SDHC
> >> create 52023 files of size 32768 bytes
> >> random re-write 100000 records of 4KB
> >> ---------------------------------------
> >>
> >> | file creation (s) | rewrite time (s) | gc count | gc garbage blocks |
> >>
> >> no patch       341         4227             1174          174840
> >> patched        296         2995             634           109314
> >> patched (KIM)  324         2958             645           106682
> >>
> >> In this test, it does not show the minor performance degradation caused
> >> by applying the patch to SSR mode. Instead, the performance is a little
> >> better with what you suggested.
> >>
> >> I agree that the performance degradation would not be significant even
> >> it does degrade. I ever saw the minor degradation in some workloads, but
> >> I didn't save the data.
> >>
> >> So, I agree that we can apply the patch to SSR mode as well.
> >>
> >> And do you still have concerns about the formula for calculating the #
> >> of search?
> >
> > Thank you for the test. :)
> > What I've concerned is that, if it is really important to get a victim
> > more accurately for the performance as you described, it doesn't need to
> > calculate the number of searches IMO. Just let's select nr_dirty. Why
> > not?
> > Only the thing that we should consider is to handle the case where the
> > nr_dirty is too large.
> > For this, we can just limit the # of searches to avoid performance
> > degradation.
> >
> > Still actually, I'm not convincing the effectiveness of your formula.
> > If possible, could you show it with numbers?
> 
> It's not easy to prove the effectiveness of the formula. It's just for
> eliminating my concern on the scalability of searching. Since it does
> not matter much for the performance improvement, we can put it aside
> and choose the simpler method as you suggested.
> 
> So, should I revise the patch based on what you suggested or will
> you take care of it?

Could you make a patch with your performance description and sumbit it
again?
Thanks a lot,

-- 
Jaegeuk Kim
Samsung

