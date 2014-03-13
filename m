Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaCMOiF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:38:05 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:11645 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751260AbaCMOiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:38:04 -0400
X-AuditID: cbfee61a-b7fb26d00000724f-2b-5321c2c8e069
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Yong-Taek Lee <ytk.lee@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH v2] mm/page_alloc: fix freeing of MIGRATE_RESERVE
 migratetype pages
Date: Thu, 13 Mar 2014 15:37:46 +0100
Message-id: <3661570.lSOEkVGv4G@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
In-reply-to: <20140313142540.GQ10663@suse.de>
References: <42197912.c6v2hLDCey@amdc1032> <20140313142540.GQ10663@suse.de>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=iso-8859-15
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd2ThxSDDTr/sVo8/dTHYnF51xw2
	i3tr/rNarD1yl91i8rtnjBaP13M7sHks2FTqsenTJHaPvi2rGD02n672+LxJLoA1issmJTUn
	syy1SN8ugSvj6vseloJ+voonyzawNDCe5e5i5OCQEDCR2L+nrouRE8gUk7hwbz1bFyMXh5DA
	dEaJu/2rWCGcFiaJI5efsYBUsQlYSUxsX8UI0iwioCAx9705SA2zwFpGibOdD9lBaoQF4iSe
	/9nMBmKzCKhK3Px1DizOK6ApcXdTK1hcVMBTYsf2lWA2p4CuxKd/W8BqhAS8JT6tOMQGUS8o
	8WPyPbC9zALyEvv2T2UF2csMVL9gg8cERoFZSKpmIamahVC1gJF5FaNoakFyQXFSeq6hXnFi
	bnFpXrpecn7uJkZwQD+T2sG4ssHiEKMAB6MSD++K5QrBQqyJZcWVuYcYJTiYlUR4rTcpBgvx
	piRWVqUW5ccXleakFh9ilOZgURLnPdBqHSgkkJ5YkpqdmlqQWgSTZeLglGpg3OdrXiZpyXju
	4Z6o9CqlM9YHnjWde931ccOxqSvO97p/4py2f8mH1R9Neuy49J+lBZ1R4zB+VK3mtIftQ2TV
	l/Pmun0fvL+1xMYtnF78Y6vbp18sn/h5ftqVZR80vJPO12d5oeuR9YzFAfcnZatOO3lyc8ar
	p8eNJGwkb9ivYf3nlj93zT21b0osxRmJhlrMRcWJAAU59XtkAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 13, 2014 02:25:40 PM Mel Gorman wrote:
> On Fri, Feb 14, 2014 at 07:34:17PM +0100, Bartlomiej Zolnierkiewicz wrote:
> > Pages allocated from MIGRATE_RESERVE migratetype pageblocks
> > are not freed back to MIGRATE_RESERVE migratetype free
> > lists in free_pcppages_bulk()->__free_one_page() if we got
> > to free_pcppages_bulk() through drain_[zone_]pages().
> > The freeing through free_hot_cold_page() is okay because
> > freepage migratetype is set to pageblock migratetype before
> > calling free_pcppages_bulk().  If pages of MIGRATE_RESERVE
> > migratetype end up on the free lists of other migratetype
> > whole Reserved pageblock may be later changed to the other
> > migratetype in __rmqueue_fallback() and it will be never
> > changed back to be a Reserved pageblock.  Fix the issue by
> > preserving freepage migratetype as a pageblock migratetype
> > (instead of overriding it to the requested migratetype)
> > for MIGRATE_RESERVE migratetype pages in rmqueue_bulk().
> > 
> > The problem was introduced in v2.6.31 by commit ed0ae21
> > ("page allocator: do not call get_pageblock_migratetype()
> > more than necessary").
> > 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Reported-by: Yong-Taek Lee <ytk.lee@samsung.com>
> > Cc: Marek Szyprowski <m.szyprowski@samsung.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Hugh Dickins <hughd@google.com>
> 
> It's a pity about the unconditional pageblock lookup in that path but I
> didn't see a better way around it so
> 
> Acked-by: Mel Gorman <mgorman@suse.de>

Thanks but does that mean that v3 should be abandoned:

	https://lkml.org/lkml/2014/3/6/365

?

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

