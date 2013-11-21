Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3KUEq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 23:46:28 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36413 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KUEqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 23:46:24 -0500
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7f836d000001b39-b4-528d901ffd66
Content-transfer-encoding: 8BIT
Message-id: <1385009132.26319.71.camel@kjgkr>
Subject: RE: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry
 pages by merging for mount performance
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Chao Yu <chao2.yu@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        =?UTF-8?Q?=27=E8=B0=AD=E5=A7=9D=27?= <shu.tan@samsung.com>
Date: Thu, 21 Nov 2013 13:45:32 +0900
In-reply-to: <000001cee668$872ec6a0$958c53e0$@samsung.com>
References: <001d01cee5bc$779c2fe0$66d48fa0$@samsung.com>
 <1384997517.26319.60.camel@kjgkr> <000001cee668$872ec6a0$958c53e0$@samsung.com>
Organization: Samsung
X-Mailer: Evolution 3.2.3-0ubuntu6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zI135Cb1BBlvmKFn8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr48WinewF
	d4QqenZfYGtg3MbXxcjJISFgIjFpewc7hC0mceHeerYuRi4OIYFljBIXp/cwdzFygBXd+KIK
	EV/EKPH+2B5mkAZeAUGJH5PvsYDUMAvISxy5lA0SZhZQl5g0bxEzRP0rRon93Z+h6nUlFjXP
	ZwSxhQXKJL4sfQY2n01AW2LzfgOQsJCAosTb/XdZQWwRASWJX/MXsYLMYRZYzijxfPI5FpAE
	i4CqxKKmS2BHcwpYSRz+08EE0dzNKHFrlQiIzS8gKnF44XZmiMeUJHa3d7KDDJIQuMQucWjR
	AiaIQQIS3yYfYoF4UlZi0wGoekmJgytusExglJiF5M1ZCG/OQvLmAkbmVYyiqQXJBcVJ6UXG
	esWJucWleel6yfm5mxghkde/g/HuAetDjMlAGycyS4km5wMjN68k3tDYzMjC1MTU2Mjc0ow0
	YSVx3vsPk4KEBNITS1KzU1MLUovii0pzUosPMTJxcEo1MK6s9Z3OtVNhPY/pDnEJnqi6jVG6
	3LLJLzUawh1KmQJNPkyvM/6mvE2hzeJ2+nKxu+9WsDZ6PLHK3+Z94syjVyqZ8uzhnCyzJBX6
	M1+/sHflSyp6mJV0peXrlo5/vROOfPoYG3JAe4nXbw+P79k5RpIuP+vnBDuKCWl9ObG9Nieo
	96JS6LmNSizFGYmGWsxFxYkA/RkIBNICAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDKsWRmVeSWpSXmKPExsVy+t9jAV35Cb1BBn/fylr8b/rIZnFpkbvF
	nr0nWSwu75rDZtG68DyzA6vH7gWfmTz6tqxi9Pi8SS6AOaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMePFop3sBXeEKnp2X2BrYNzG18XIwSEhYCJx44tqFyMnkCkmceHe
	erYuRi4OIYFFjBLvj+1hBknwCghK/Jh8jwWknllAXuLIpWyQMLOAusSkeYuYIepfMUrs7/4M
	Va8rsah5PiOILSxQJvFl6TNmkF42AW2JzfsNQMJCAooSb/ffZQWxRQSUJH7NX8QKModZYDmj
	xPPJ51hAEiwCqhKLmi6xg9icAlYSh/90MEE0dzNK3FolAmLzC4hKHF64nRniASWJ3e2d7BMY
	hWYhOXsWwtmzkJy9gJF5FaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwXD+T2sG4ssHiEKMA
	B6MSD2/H454gIdbEsuLK3EOMEhzMSiK8xyp7g4R4UxIrq1KL8uOLSnNSiw8xJgMdPpFZSjQ5
	H5hy8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBsfrHf9ff
	e1Nyd97d9fPEt8mZXJzrZuaEiribHXv+Q2stY2zpoWdzEzJiSheuLFrR3c6teFxLb6b7oc3f
	oud98zz+k0PiejXf5LDJmaUqGf/W2ayq/nwkn0lH6EQ0g9nxt1eLzF5evzT1R8HPc22F7VJc
	peWRjXk1IXtOabHtlfylmSp/kPuClRJLcUaioRZzUXEiAMthl5YvAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2013-11-21 (목), 11:18 +0800, Chao Yu:
> Hi,
> 
> > -----Original Message-----
> > From: Jaegeuk Kim [mailto:jaegeuk.kim@samsung.com]
> > Sent: Thursday, November 21, 2013 9:32 AM
> > To: Chao Yu
> > Cc: linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; linux-f2fs-devel@lists.sourceforge.net; 谭姝
> > Subject: Re: [f2fs-dev] [PATCH V2 2/2 RESEND] f2fs: read contiguous sit entry pages by merging for mount performance
> > 
> > Hi,
> > 
> > It seems that ra_sit_pages() is too tightly coupled with
> > build_sit_entries().
> 
> This code could be improved.
> 
> > Is there another way not to use *is_order?
> 
> Previously the code is like this:
>  -build_sit_entries()
>  next_setp:
> 	for(start = 0; start < TOTAL_SEGS(sbi); start++)
> 		/*step#1 readahead all sit entries blocks*/
> 			if(start % SIT_ENTRY_PER_BLOCK == 0) {
> 				blk_addr = current_sit_addr(sbi, start);
> 				/* grab and submit_read_page */
> 			}
> 			if(start == TOTAL_SEGS(sbi) - 1)
> 				f2fs_submit_read_bio();
> 			continue;
> 		/*step#2 fill sit entries info*/
> 		/*step#3 cover sit entries with journal*/
> 
> But I think its weakness is that it will cost lots of memory to read 
> ahead all sit entry pages when f2fs mount, and also it's serious waste 
> that we read them again after these pages are released by VM when 
> out of memory.
> 
> > 
> > The ra_sit_pages() tries to read consecutive sit pages as many as
> > possible.
> > So then, what about just checking whether its block address is
> > contiguous or not?
> > 
> > Something like this:
> >  -ra_sit_pages()
> > 	blkno = start;
> > 	while (blkno < sit_i->sit_blocks) {
> > 		blk_addr = current_sit_addr(sbi, blkno);
> > 		if (blkno != start && prev_blk_addr + 1 != blk_addr)
> > 			break;
> > 
> > 		/* grab and submit_read_page */
> > 
> > 		prev_blk_addr = blk_addr;
> > 		blkno++;
> > 	}
> 
> Agreed, this method could remove *order.
> Shouldn't we add nrpages for readahead policy as VM?

Aha, agreed.
We need nrpages to avoid too many reads on sit blocks.

But, still it needs to change the nrpages in its caller.
In your patch, it was sit_i->sit_blocks that is total # of sit blocks.
I think 128 or 256 is quite reasonable number.

Anyway, how about implementing ra_sit_pages() with a blk_plug likewise
ra_node_pages()?

-- 
Jaegeuk Kim
Samsung

