Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaLJNio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:38:44 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:53335 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755867AbaLJNin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:38:43 -0500
MIME-Version: 1.0
In-Reply-To: <20141209095922.GB21903@suse.de>
References: <000001d01383$8e0f1120$aa2d3360$%yang@samsung.com>
	<20141209095922.GB21903@suse.de>
Date: Wed, 10 Dec 2014 21:38:42 +0800
Message-ID: <CAL1ERfOxEJGJjZk9O_NKV82mOT+udto0tL2eCagicLig6CaJ=g@mail.gmail.com>
Subject: Re: [PATCH] mm: page_alloc: place zone id check before VM_BUG_ON_PAGE check
From: Weijie Yang <weijie.yang.kh@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Weijie Yang <weijie.yang@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>,
        Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 5:59 PM, Mel Gorman <mgorman@suse.de> wrote:
> On Tue, Dec 09, 2014 at 03:40:35PM +0800, Weijie Yang wrote:
>> If the free page and its buddy has different zone id, the current
>> zone->lock cann't prevent buddy page getting allocated, this could
>> trigger VM_BUG_ON_PAGE in a very tiny chance:
>>
>
> Under what circumstances can a buddy page be allocated without the
> zone->lock? Any parallel allocation from that zone that takes place will
> be from the per-cpu allocator and should not be affected by this. Have
> you actually hit this race?

My description maybe not clear, if the free page and its buddy is not
at the same zone, the holding zone->lock cann't prevent buddy page
getting allocated.
zone_1->lock prevents the freeing page getting allocated
zone_2->lock prevents the buddy page getting allocated
they are not the same zone->lock.

I found it when review the code, not a running test.
However, if we cann't remove the zone_id check statement, I think
we should handle this rare race.

If I miss something or make a mistake, please let me know.

Thanks

> --
> Mel Gorman
> SUSE Labs
