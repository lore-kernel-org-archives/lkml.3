Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998Ab3KUJgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 04:36:52 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37119 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab3KUJgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 04:36:48 -0500
X-AuditID: cbfee690-b7f3d6d000001c4a-23-528dd420ad4e
Message-id: <1385026541.26319.79.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry
 pages by merging for mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Thu, 21 Nov 2013 18:35:41 +0900
In-reply-to: <000201cee684$550e11a0$ff2a34e0$@samsung.com>
References: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
 <1384997517.26319.60.camel@kjgkr>
 <000001cee668$872ec6a0$958c53e0$@samsung.com>
 <1385009132.26319.71.camel@kjgkr> <000201cee684$550e11a0$ff2a34e0$@samsung.com>
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zQ12FK71BBks/mln8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr48GqzYwF
	kwUqZu7exN7AOIuni5GTQ0LAROLxjz5WCFtM4sK99WxdjFwcQgLLGCUaNp9ggyk63/ycESIx
	nVHi6/0WVgjnFaPEg3lTWECqeAV0JS4v380OYgsLlEl8WfqMuYuRg4NNQFti834DkLCQgKLE
	2/13wbaJCChJ/Jq/CGwOs8ByRonnk8+BzWERUJWY/f8LWBGngJXElAO7oDbfZ5Q4/uUOWIJf
	QFTi8MLtzCA2s4C6xKR5i5ghTlWS2N3eyQ4Rl5fYvOYtM8RxghI/Jt9jARkkIXCJXeJrzz8m
	iG0CEt8mH2IBuVRCQFZi0wGoOZISB1fcYJnAKDELyYpZSMbOQjJ2ASPzKkbR1ILkguKk9CIT
	veLE3OLSvHS95PzcTYyQCJywg/HeAetDjMlAKycyS4km5wMjOK8k3tDYzMjC1MTU2Mjc0ow0
	YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGLmWC7TGleneuMJ4NiV61+HGE+sS
	jsnq8ig1LLsbzyLuX3wkZOLWzG9XrLyveDK4bL8aNWfpSluvr9dOZcYG5pvM3Hz1fIqUF9sD
	711X9szavutkXmvHDCOVp828a490FXPPPn3DYOYx1UdnTZ+msEmfWbk8M1soLlnpuPnmR3tZ
	1LtkPt9vi1JiKc5INNRiLipOBAAmnqmi1gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAKsWRmVeSWpSXmKPExsVy+t9jQV2FK71BBi+2GVn8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePBqs2MBZMFKmbu3sTewDiLp4uRk0NCwETifPNzRghbTOLCvfVs
	XYxcHEIC0xklvt5vYYVwXjFKPJg3hQWkildAV+Ly8t3sILawQJnEl6XPmLsYOTjYBLQlNu83
	AAkLCShKvN1/lxXEFhFQkvg1fxHYHGaB5YwSzyefA5vDIqAqMfv/F7AiTgEriSkHdjFCLLvP
	KHH8yx2wBL+AqMThhduZQWxmAXWJSfMWMUOcqiSxu72THSIuL7F5zVtmiOMEJX5MvscygVFo
	FpKWWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOL6fSe9gXNVgcYhRgINR
	iYf3wdOeICHWxLLiytxDjBIczEoivMXze4OEeFMSK6tSi/Lji0pzUosPMSYDvTeRWUo0OR+Y
	evJK4g2NTcyMLI3MLIxMzM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbFsq8cjwSun
	f237zXYncGbuuWdVjT5XmO/OfSVTO7F32kH7zc4nQ4/3V2sLb83uP+O3iic5uZj9efYio8Vb
	gpfK/TGeLq1YKKiefa9jjdALRxdz5sPXrx3of3x/n8mWrCSvpeEVX8XiY/+XLn2UuE7Dicve
	/C2/w9I7x/WNVux8fFq/zuFA2S8lluKMREMt5qLiRAAMwUmaMwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > >
> > > >
> > > > The ra_sit_pages() tries to read consecutive sit pages as many as
> > > > possible.
> > > > So then, what about just checking whether its block address is
> > > > contiguous or not?
> > > >
> > > > Something like this:
> > > >  -ra_sit_pages()
> > > > 	blkno = start;
> > > > 	while (blkno < sit_i->sit_blocks) {
> > > > 		blk_addr = current_sit_addr(sbi, blkno);
> > > > 		if (blkno != start && prev_blk_addr + 1 != blk_addr)
> > > > 			break;
> > > >
> > > > 		/* grab and submit_read_page */
> > > >
> > > > 		prev_blk_addr = blk_addr;
> > > > 		blkno++;
> > > > 	}
> > >
> > > Agreed, this method could remove *order.
> > > Shouldn't we add nrpages for readahead policy as VM?
> > 
> > Aha, agreed.
> > We need nrpages to avoid too many reads on sit blocks.
> > 
> > But, still it needs to change the nrpages in its caller.
> > In your patch, it was sit_i->sit_blocks that is total # of sit blocks.
> > I think 128 or 256 is quite reasonable number.
> 
> Hmm, Originally in [PATCH V1] it was be set to 
> MAX_BIO_BLOCKS(max_hw_blocks(sbi)).
> 
> So it could be "#define SIT_ENTRIES_RA_NUM	128"?
> BTW, maybe we should send dynamical nrpages which depend on 
> memory state of system as I mention in previous thread.
> How do you think?

I think it'd be better to use MAX_BIO_BLOCKS().

> 
> > 
> > Anyway, how about implementing ra_sit_pages() with a blk_plug likewise
> > ra_node_pages()?

My mistake.
This was the ra_nat_pages().

> 
> So we use this structure to plug multi bios submitting in ra_sit_pages(), right?
> -build_sit_entries()
> 	blk_start_plug(&plug);
> 	ra_sit_pages();
> 	blk_finish_plug(&plug);

Ah. What I meant was:
 blk_start_plug(&plug);
 for()
 	read_sit_page();
 blk_finish_plug(&plug);

But, it is not a big deal.
It doesn't matter to use your approach.
Please ignore this.

BTW, I found that we can use submit_read_page() at ra_nat_pages() and
remove block plugging.
I'll send a patch for this. :)
Thanks,

-- 
Jaegeuk Kim
Samsung

