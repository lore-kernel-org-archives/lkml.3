Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564AbaDYBrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:47:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46998 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaDYBrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:47:49 -0400
X-AuditID: cbfee68f-b7eff6d000002b70-37-5359bec2265a
Message-id: <1398390340.4283.36.camel@kjgkr>
Subject: [BUG] kmemleak on __radix_tree_preload
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: "Linux Kernel, Mailing List" <linux-kernel@vger.kernel.org>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>
Date: Fri, 25 Apr 2014 10:45:40 +0900
Organization: Samsung
Content-type: text/plain; charset=UTF-8
X-Mailer: Evolution 3.2.3-0ubuntu6
Content-transfer-encoding: 7bit
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t8zI91D+yKDDb43yFtc3jWHzeLemv+s
	Dkwemz5NYvf4vEkugCmKyyYlNSezLLVI3y6BK+Pxz1tMBVt5K/Y2bGBpYNzI3cXIySEhYCJx
	690yZghbTOLCvfVsXYxcHEICyxglplw4wAJT1L7xMCNEYjqjxLLjd6CcV4wSSx9dZASp4hXQ
	kdj2bh6YLSygL/Ft536gbg4ONgFtic37DUDCQgKKEm/332UFCYsI2EtcbDMCMZkFdCUeLrIA
	qWARUJU4/LSXFcTmFxCVOLxwO9htzALqEpPmLYK6U0lid3snO0RcXmLzmrfMEAcISvyYfI8F
	5DIJgcnsEk9+7maCGCog8W3yIbBrJARkJTYdgJojKXFwxQ2WCYxis5CsmIVk7CwkYxcwMq9i
	FE0tSC4oTkovMtYrTswtLs1L10vOz93ECImR/h2Mdw9YH2JMBlo5kVlKNDkfGGN5JfGGxmZG
	FqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoHRxsfxzdJtNQcu
	q8s8TthzTqe3e4vSoZ9TZNOLP9SGqt72a7djYHlYPyFMQopvou3Tthfx7cmHrWPn8m2as09Q
	gfncm9BjhxKjH1zYMzvNx+6W85qzlnYR/xvsxdrS20oi9r9+sX5y0aTZ7n/+XmRwErTkZCm0
	8jU8HbQ3KSPfdaPhiXk/JrIosRRnJBpqMRcVJwIAcHLUU6cCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrIIsWRmVeSWpSXmKPExsVy+t9jQd1D+yKDDc7slLa4vGsOm8W9Nf9Z
	HZg8Nn2axO7xeZNcAFNUA6NNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJu
	qq2Si0+ArltmDtB8JYWyxJxSoFBAYnGxkr4dpgmhIW66FjCNEbq+IUFwPUYGaCBhHWPG45+3
	mAq28lbsbdjA0sC4kbuLkZNDQsBEon3jYUYIW0ziwr31bF2MXBxCAtMZJZYdv8MI4bxilFj6
	6CJYFa+AjsS2d/PAbGEBfYlvO/ezdDFycLAJaEts3m8AEhYSUJR4u/8uK0hYRMBe4mKbEYjJ
	LKAr8XCRBUgFi4CqxOGnvawgNr+AqMThhduZQWxmAXWJSfMWMUOcoySxu72THSIuL7F5zVtm
	iAMEJX5MvscygVFgFpKWWUjKZiEpW8DIvIpRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOAKf
	Se9gXNVgcYhRgINRiYd3gmxksBBrYllxZe4hRgkOZiURXuVVQCHelMTKqtSi/Pii0pzU4kOM
	yUBfTGSWEk3OByaHvJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLg
	lGpg3DBFuSu/2sRT98p2ti3lDX1h63Zfb+o2fN9Van1jde6uI9rmsjmXsoXmF0ufdfhv82N9
	l+Tr6Y/9Jay/X0nLNjnwZIL3pGd7179Jv+Zl3nFQ0m/ilNhtvQdcfoaGKF/+bby2UW+qzIWr
	bGYiDn77brc63qsy5eqz7K+68PDTxp8BHgXmF+ZaKrEUZyQaajEXFScCAPutYjcEAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi mm folks,

When I was testing recent linus tree, I got several kmemleaks as below.
Could any of you guys guide how to fix this?
Thanks,

0. Test
 - fsstress on f2fs

1. Kernel version
commit 4d0fa8a0f01272d4de33704f20303dcecdb55df1
Merge: 39bfe90 b5539fa
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Apr 22 09:28:02 2014 -0700

    Merge tag 'gpio-v3.15-2' of
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
    
    Pull gpio fixes from Linus Walleij:

2. Bug
 This is one of the results, but all the results indicate
__radix_tree_preload.

unreferenced object 0xffff88002ae2a238 (size 576):
comm "fsstress", pid 25019, jiffies 4295651360 (age 2276.104s)
hex dump (first 32 bytes):
01 00 00 00 81 ff ff ff 00 00 00 00 00 00 00 00  ................
40 7d 37 81 ff ff ff ff 50 a2 e2 2a 00 88 ff ff  @}7.....P..*....
backtrace:
 [<ffffffff8170e546>] kmemleak_alloc+0x26/0x50
 [<ffffffff8119feac>] kmem_cache_alloc+0xdc/0x190
 [<ffffffff81378709>] __radix_tree_preload+0x49/0xc0
 [<ffffffff813787a1>] radix_tree_maybe_preload+0x21/0x30
 [<ffffffff8114bbbc>] add_to_page_cache_lru+0x3c/0xc0
 [<ffffffff8114c778>] grab_cache_page_write_begin+0x98/0xf0
 [<ffffffffa02d3151>] f2fs_write_begin+0xa1/0x370 [f2fs]
 [<ffffffff8114af47>] generic_perform_write+0xc7/0x1e0
 [<ffffffff8114d230>] __generic_file_aio_write+0x1d0/0x400
 [<ffffffff8114d4c0>] generic_file_aio_write+0x60/0xe0
 [<ffffffff811b281a>] do_sync_write+0x5a/0x90
 [<ffffffff811b3575>] vfs_write+0xc5/0x1f0
 [<ffffffff811b3a92>] SyS_write+0x52/0xb0
 [<ffffffff81730912>] system_call_fastpath+0x16/0x1b
 [<ffffffffffffffff>] 0xffffffffffffffff


-- 
Jaegeuk Kim
Samsung

