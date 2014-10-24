Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354AbaJXFfR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:35:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:50928 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaJXFfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:35:15 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 24 Oct 2014 14:36:19 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] fix freepage count problems in memory isolation
Message-ID: <20141024053618.GG15243@js1304-P5Q-DELUXE>
References: <1414051821-12769-1-git-send-email-iamjoonsoo.kim@lge.com>
 <20141024022749.GA32456@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024022749.GA32456@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:27:49AM +0900, Minchan Kim wrote:
> Hi Joonsoo,
> 
> I know you spend much effort for investigate/fix this subtle problem.
> So, you should be hero.
> 
> Thanks for really nice work!

Hello,

Thanks. :)
> > 
> > Joonsoo Kim (4):
> >   mm/page_alloc: fix incorrect isolation behavior by rechecking
> >     migratetype
> >   mm/page_alloc: add freepage on isolate pageblock to correct buddy
> >     list
> >   mm/page_alloc: move migratetype recheck logic to __free_one_page()
> 
> So, [1-3],
> Acked-by: Minchan Kim <minchan@kernel.org>

Thanks, too.

> >   mm/page_alloc: restrict max order of merging on isolated pageblock
> 
> As you noted in description, this patch has a side effect which doesn't
> merge buddies. Most of all, I agree your assumptions but it's not true always.
> 
> Who knows there is a driver which want a higher page above pageblock?
> Who knows there is no allocation/free of the isolated range right before
> highest allocation request?
> Even, your patch introduces new exception rule for page allocator.
> 
>         "Hey, allocator, from now on, you could have unmerged buddies
>          in your list so please advertise it to your customer"
> 
> So, all of users of the allocator should consider that exception so
> it might hit us sometime.
> 
> I want to fix that in isolation undo time.
> Thanks, again!

Okay. I will try it. The reason I implement as current is that it makes
process of isolation/un-isolation asymetric and needs to copy and
paste some code to handle this specialty. That would possibly result
in maintainance overhead. But, yes, exception of buddy property is
also bad situation. I will implement it and send it soon.

Thanks.
