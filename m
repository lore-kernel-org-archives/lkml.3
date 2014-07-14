Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaGNGXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:23:09 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64044 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaGNGW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:22:57 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 14 Jul 2014 15:28:52 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
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
Subject: Re: [PATCH 05/10] mm/page_alloc: optimize and unify pageblock
 migratetype check in free path
Message-ID: <20140714062852.GC11317@js1304-P5Q-DELUXE>
References: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1404460675-24456-6-git-send-email-iamjoonsoo.kim@lge.com>
 <53BAC1B1.4090002@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BAC1B1.4090002@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 05:50:09PM +0200, Vlastimil Babka wrote:
> On 07/04/2014 09:57 AM, Joonsoo Kim wrote:
> >Currently, when we free the page from pcp list to buddy, we check
> >pageblock of the page in order to isolate the page on isolated
> >pageblock. Although this could rarely happen and to check migratetype of
> >pageblock is somewhat expensive, we check it on free fast path. I think
> >that this is undesirable. To prevent this situation, I introduce new
> >variable, nr_isolate_pageblock on struct zone and use it to determine
> >if we should check pageblock migratetype. Isolation on pageblock rarely
> >happens so we can mostly avoid this pageblock migratetype check.
> 
> Better, but still there's a zone flag check and maintenance. So if
> it could be avoided, it would be better.
> 
> >Additionally, unify freepage counting code, because it can be done in
> >common part, __free_one_page(). This unifying provides extra guarantee
> >that the page on isolate pageblock don't go into non-isolate buddy list.
> >This is similar situation describing in previous patch so refer it
> >if you need more explanation.
> 
> You should make it clearer that you are solving misplacement of the
> type "page should be placed on isolated freelist but it's not"
> through free_one_page(), which was solved only for
> free_pcppages_bulk() in patch 03/10. Mentioning patch 04/10 here,
> which solves the opposite problem "page shouldn't be placed on
> isolated freelist, but it is", only confuses the situation. Also
> this patch undoes everything of 04/10 and moves it elsewhere, so
> that would make it harder to git blame etc. I would reorder 04 and
> 05.

Okay. I will clarify what I am solving in commit description and
reorder patches appropriately.

Thanks.

