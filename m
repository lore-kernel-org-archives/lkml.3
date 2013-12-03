Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab3LCJhV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:37:21 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:32852 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502Ab3LCJhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:37:15 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68d-b7f5c6d000004aff-5e-529da6489ca8
Content-transfer-encoding: 8BIT
Message-id: <1386063374.2417.139.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Tue, 03 Dec 2013 18:36:14 +0900
In-reply-to: <000301ceef3c$ecee00a0$c6ca01e0$@samsung.com>
References: <1385776085-21163-1-git-send-email-jaegeuk.kim@samsung.com>
 <000201ceef25$e145cec0$a3d16c40$@samsung.com>
 <1385972094.2417.104.camel@kjgkr> <000301ceef3c$ecee00a0$c6ca01e0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zA12PZXODDNYeYrP43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxuu321kK
	5khWtC1bxNbA+Fu4i5GTQ0LAROJ101kmCFtM4sK99WxdjFwcQgLLGCUOP+pghyk6/KabHSKx
	iFGiddU0RpAEr4CgxI/J91i6GDk4mAXkJY5cygYJMwuoS0yat4gZov4Vo8SlR69YIep1JXb9
	7gazhQW8JBpOvWMH6WUT0JbYvN8AJCwkoCjxdv9dsBIRASWJX/MXsYLMYRZYzijxfPI5FpAE
	i4CqxLu+J2A2p4CVxL2mO1BXn2SUuLtlKViCX0BU4vDC7cwQHyhJ7G7vBPtAQuASu8TrvgfM
	EJMEJL5NPgT2gYSArMSmA1D1khIHV9xgmcAoMQvJn7MQ/pyF5M8FjMyrGEVTC5ILipPSiwz1
	ihNzi0vz0vWS83M3MUKir3cH4+0D1ocYk4E2TmSWEk3OB0ZvXkm8obGZkYWpiamxkbmlGWnC
	SuK8SQ+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwzt16IEz5wS9Zhr8vvWOYXxuXXF6c
	4Nl4nEGA9aPF1PAvjy8Xi83pSNoVsuGajL6AQuGehLLDnnuXiYXIrVBwipebcXP7lmiXiZYL
	V3vIfWkSeHppWeuEGeWtHNnHr/f7PxV9s3SrfN+iGaX/tv+57ZQn2xsXpMpVOH+i2vzXb4ze
	ppyt0b6wXYmlOCPRUIu5qDgRAE3gYTPUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAV2PZXODDO5PYrL43/SRzeLSIneL
	PXtPslhc3jWHzaJ14XlmB1aP3Qs+M3n0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8brt9tZCuZIVrQtW8TWwPhbuIuRk0NCwETi8JtudghbTOLCvfVs
	XYxcHEICixglWldNYwRJ8AoISvyYfI+li5GDg1lAXuLIpWyQMLOAusSkeYuYIepfMUpcevSK
	FaJeV2LX724wW1jAS6Lh1Dt2kF42AW2JzfsNQMJCAooSb/ffBSsREVCS+DV/ESvIHGaB5YwS
	zyefYwFJsAioSrzrewJmcwpYSdxrugN13ElGibtbloIl+AVEJQ4v3M4M8YGSxO72TvYJjEKz
	kNw9C+HuWUjuXsDIvIpRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOLafSe1gXNlgcYhRgINR
	iYf3wfY5QUKsiWXFlbmHGCU4mJVEeOenzw0S4k1JrKxKLcqPLyrNSS0+xJgMdPlEZinR5Hxg
	2skriTc0NjEzsjQyszAyMTcnTVhJnPdAq3WgkEB6YklqdmpqQWoRzBYmDk6pBkaVn7JXs7bt
	Nfx1qXxmQ/0pdg1Rs56Nz9oEq7LWzH4z7xNbyWbvi26zd/1wUZnevkjj9ZezzVe+rtz/Vvfg
	Rrk+1+diHXy3qqvnfrvf4ci0Uy3tiEzBS+Xrn1jPGgb56Fp3f6g5lNV12WbaPJs7qZf+RvVF
	2RxR/f7y3dSTfFy54ln5L6yXiVoqsRRnJBpqMRcVJwIA9Ce2KjEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It causes NULL pointer error without f2fs_bug_on(), so I don't think we
need to add this.
Thanks,

2013-12-02 (월), 16:59 +0800, Chao Yu:
> Hi Kim,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Monday, December 02, 2013 4:15 PM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > Subject: RE: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
> > 
> > 2013-12-02 (월), 14:14 +0800, Chao Yu:
> > > Hi Kim,
> > >
> > > > -----Original Message-----
> > > > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > > > Sent: Saturday, November 30, 2013 9:48 AM
> > > > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net
> > > > Subject: [f2fs-dev] [PATCH] f2fs: remove the own bi_private allocation
> > > >
> > > > Previously f2fs allocates its own bi_private data structure all the time even
> > > > though we don't use it. But, can we remove this bi_private allocation?
> > > >
> > > > This patch removes such the additional bi_private allocation.
> > > >
> > > > 1. Retrieve f2fs_sb_info from its page->mapping->host->i_sb.
> > > >  - This removes the usecases of bi_private in end_io.
> > > >
> > > > 2. Use bi_private only when we really need it.
> > > >  - The bi_private is used only when the checkpoint procedure is conducted.
> > > >  - When conducting the checkpoint, f2fs submits a META_FLUSH bio to wait its bio
> > > > completion.
> > > >  - Since we have no dependancies to remove bi_private now, let's just use
> > > >  bi_private pointer as the completion pointer.
> > > >
> > > > Signed-off-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> > > > ---
> > > >  fs/f2fs/segment.c | 43 ++++++++++++++++---------------------------
> > > >  fs/f2fs/segment.h |  7 -------
> > > >  2 files changed, 16 insertions(+), 34 deletions(-)
> > > >
> > > > diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
> > > > index 0387863..0db4027 100644
> > > > --- a/fs/f2fs/segment.c
> > > > +++ b/fs/f2fs/segment.c
> > > > @@ -791,7 +791,7 @@ static void f2fs_end_io_write(struct bio *bio, int err)
> > > >  {
> > > >  	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
> > > >  	struct bio_vec *bvec = bio->bi_io_vec + bio->bi_vcnt - 1;
> > > > -	struct bio_private *p = bio->bi_private;
> 
> 		f2fs_bug_on(unlikely(!bvec->bv_page->mapping));
> 
> > > > +	struct f2fs_sb_info *sbi = F2FS_SB(bvec->bv_page->mapping->host->i_sb);
> > >
> > > I'm not sure whether bvec->bv_page->mapping will be set to NULL in the flow
> > > where may not check WRITEBACK flag of page. Is it possible?
> > 
> > The mapping should be not NULL cause it is a writebacking page.
> > Otherwise, it's a bug.
> 
> If so, should we add additional code as above?
> 
> Regards,
> Yu
> 
> > Thanks,
> > 
> > --
> > Jaegeuk Kim
> > Samsung
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Jaegeuk Kim
Samsung

