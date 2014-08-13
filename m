Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744AbaHMIVC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:21:02 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:56457 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaHMIU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:20:59 -0400
X-Original-SENDERIP: 10.177.222.172
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Wed, 13 Aug 2014 17:20:57 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/8] mm/page_alloc: correct to clear guard attribute
 in DEBUG_PAGEALLOC
Message-ID: <20140813082057.GD30451@js1304-P5Q-DELUXE>
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1407309517-3270-5-git-send-email-iamjoonsoo.kim@lge.com>
 <20140812014523.GB23418@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812014523.GB23418@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 01:45:23AM +0000, Minchan Kim wrote:
> On Wed, Aug 06, 2014 at 04:18:30PM +0900, Joonsoo Kim wrote:
> > In __free_one_page(), we check the buddy page if it is guard page.
> > And, if so, we should clear guard attribute on the buddy page. But,
> > currently, we clear original page's order rather than buddy one's.
> > This doesn't have any problem, because resetting buddy's order
> > is useless and the original page's order is re-assigned soon.
> > But, it is better to correct code.
> > 
> > Additionally, I change (set/clear)_page_guard_flag() to
> > (set/clear)_page_guard() and makes these functions do all works
> > needed for guard page. This may make code more understandable.
> > 
> > One more thing, I did in this patch, is that fixing freepage accounting.
> > If we clear guard page and link it onto isolate buddy list, we should
> > not increase freepage count.
> 
> You are saying just "shouldn't do that" but don't say "why" and "result"
> I know the reason but as you know, I'm one of the person who is rather
> familiar with this part but I guess others should spend some time to get.
> Kind detail description is never to look down on person. :)

Hmm. In fact, the reason is already mentioned in cover letter, but,
it is better to write it here.

Will do.

> > 
> 
> Nice catch, Joonsoo! But what make me worry is is this patch makes 3 thing
> all at once.
> 
> 1. fix - no candidate for stable
> 2. clean up
> 3. fix - candidate for stable.
> 
> Could you separate 3 and (1,2) in next spin?
> 

Okay!

Thanks.
