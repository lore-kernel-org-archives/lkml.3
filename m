Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbaHHGWN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:22:13 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:39507 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaHHGWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:22:09 -0400
X-Original-SENDERIP: 10.177.223.133
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 8 Aug 2014 15:22:07 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
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
Subject: Re: [PATCH v2 2/8] mm/isolation: remove unstable check for isolated
 page
Message-ID: <20140808062206.GA6150@js1304-P5Q-DELUXE>
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1407309517-3270-4-git-send-email-iamjoonsoo.kim@lge.com>
 <53E383DD.6090500@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E383DD.6090500@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 03:49:17PM +0200, Vlastimil Babka wrote:
> On 08/06/2014 09:18 AM, Joonsoo Kim wrote:
> >The check '!PageBuddy(page) && page_count(page) == 0 &&
> >migratetype == MIGRATE_ISOLATE' would mean the page on free processing.
> 
> What is "the page on free processing"? I thought this test means the
> page is on some CPU's pcplist?

Yes, you are right.

> 
> >Although it could go into buddy allocator within a short time,
> >futher operation such as isolate_freepages_range() in CMA, called after
> >test_page_isolated_in_pageblock(), could be failed due to this unstability
> 
> By "unstability" you mean the page can be allocated again from the
> pcplist instead of being freed to buddy list?

Yes.

> >since it requires that the page is on buddy. I think that removing
> >this unstability is good thing.
> >
> >And, following patch makes isolated freepage has new status matched with
> >this condition and this check is the obstacle to that change. So remove
> >it.
> 
> You could also say that pages from isolated pageblocks can no longer
> appear on pcplists after the later patches.

Okay. I will do it.

Thanks.
