Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbaDUCr2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 22:47:28 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25070 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbaDUCrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 22:47:25 -0400
X-AuditID: cbfee61b-b7f766d00000646c-a8-535486b879e0
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Seth Jennings'" <sjennings@variantweb.net>,
        "'Minchan Kim'" <minchan@kernel.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Bob Liu'" <bob.liu@oracle.com>, "'Hugh Dickins'" <hughd@google.com>,
        "'Mel Gorman'" <mgorman@suse.de>, "'Rik van Riel'" <riel@redhat.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Linux-MM'" <linux-mm@kvack.org>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>
References: <1397922764-1512-1-git-send-email-ddstreet@ieee.org>
In-reply-to: <1397922764-1512-1-git-send-email-ddstreet@ieee.org>
Subject: RE: [PATCH 0/4] mm: zpool: add common api for zswap to use
 zbud/zsmalloc
Date: Mon, 21 Apr 2014 10:47:16 +0800
Message-id: <000001cf5d0c$03f348e0$0bd9daa0$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=gb2312
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9cCGiDWe1WhoShT7uUlnZYBrxB9ABABRmg
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jAd0dbSHBBi2H1S3mrF/DZtF1aiqL
	xYW23SwWqzf5Wjz91MdicXnXHDaLe2v+s1pMfveM0WLZ1/fsFhtaZrFb/L2ynsVi7efH7Baf
	jj5ic+D1OPzmPbPHzll32T0WbCr1eDrhIJPHplWdbB6bPk1i9zgx4zeLx8ent1g83u+7yuax
	+XS1x/VvRR47P21m9fi8SS6AN4rLJiU1J7MstUjfLoEro2XbLeaCXUIVC3/NYmpgfMPbxcjJ
	ISFgIjGj+zkzhC0mceHeerYuRi4OIYFFjBLrL86Fcv4wStw50sgOUsUmoC1xt38jK0hCRGAe
	o8SsU5fYQRxmgddMElvnLATKcAC1OEhc2mkK0sAp4CixrusJE4gtLBAssXFVB9g6FgFVid9T
	j7CB2LwCdhK7X19mhLAFJX5MvscCYjMLaEj0L9rABmHLS2xe85YZZLyEgLrEo7+6IKaIgJHE
	3vXBEBXiEhuP3GKZwCg0C8mgWUgGzUIyaBaSlgWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLz
	czcxgiP2mfQOxlUNFocYBTgYlXh4X+SHBAuxJpYVV+YeYpTgYFYS4RVvBArxpiRWVqUW5ccX
	leakFh9ilOZgURLnPdhqHSgkkJ5YkpqdmlqQWgSTZeLglGpgtHPOnqf++d3q6CcF11eKenxK
	2lJ02UXk/fPm2ul1b3nD1iUpangciz1uFqpfuaxMrSB06Z93bd7mWleXeKhPlKxfEF/LnNAv
	OOlppWd34Y+G3PKkycKp7l93Mx1ZFr1x5kIVk5PnmMP7j13cULr1+TnfaRpr9GTY2F7y2U+T
	/nKkJ1nHLXK3EktxRqKhFnNRcSIAwOK7wdQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, Apr 19, 2014 at 11:52 PM, Dan Streetman <ddstreet@ieee.org> wrote:
> In order to allow zswap users to choose between zbud and zsmalloc for
> the compressed storage pool, this patch set adds a new api "zpool" that
> provides an interface to both zbud and zsmalloc.  Only a minor change
> to zbud's interface was needed, as detailed in the first patch;
> zsmalloc required shrinking to be added and a minor interface change,
> as detailed in the second patch.
> 
> I believe Seth originally was using zsmalloc for swap, but there were
> concerns about how significant the impact of shrinking zsmalloc would
> be when zswap had to start reclaiming pages.  That still may be an
> issue, but this at least allows users to choose themselves whether
> they want a lower-density or higher-density compressed storage medium.
> At least for situations where zswap reclaim is never or rarely reached,
> it probably makes sense to use the higher density of zsmalloc.
> 
> Note this patch series does not change zram to use zpool, although that
> change should be possible as well.

I think this idea is acceptable, because for embedded devices reclaiming is
risky due to its write lifetime. By using zsmalloc, zswap user can not only take
the benefit of higher-density compressed storage but aslo supporting the
GFP_HIGHMEM in 32bit system.

I will pay attention to this patch set and give my opinion after my review.

Thanks for your work

> 
> Dan Streetman (4):
>   mm: zpool: zbud_alloc() minor param change
>   mm: zpool: implement zsmalloc shrinking
>   mm: zpool: implement common zpool api to zbud/zsmalloc
>   mm: zpool: update zswap to use zpool
> 
>  drivers/block/zram/zram_drv.c |   2 +-
>  include/linux/zbud.h          |   3 +-
>  include/linux/zpool.h         | 166 ++++++++++++++++++
>  include/linux/zsmalloc.h      |   7 +-
>  mm/Kconfig                    |  43 +++--
>  mm/Makefile                   |   1 +
>  mm/zbud.c                     |  28 ++--
>  mm/zpool.c                    | 380 ++++++++++++++++++++++++++++++++++++++++++
>  mm/zsmalloc.c                 | 168 +++++++++++++++++--
>  mm/zswap.c                    |  70 ++++----
>  10 files changed, 787 insertions(+), 81 deletions(-)
>  create mode 100644 include/linux/zpool.h
>  create mode 100644 mm/zpool.c
> 
> --
> 1.8.3.1

