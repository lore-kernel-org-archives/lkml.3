Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbaHGIX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 04:23:57 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52955 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269AbaHGIXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 04:23:54 -0400
X-Original-SENDERIP: 10.177.223.133
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 7 Aug 2014 17:23:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
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
Subject: Re: [PATCH v2 3/8] mm/page_alloc: fix pcp high, batch management
Message-ID: <20140807082353.GC2427@js1304-P5Q-DELUXE>
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1407309517-3270-7-git-send-email-iamjoonsoo.kim@lge.com>
 <53E2E042.3070803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E2E042.3070803@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2014 at 10:11:14AM +0800, Zhang Yanfei wrote:
> Hi Joonsoo,
> 
> On 08/06/2014 03:18 PM, Joonsoo Kim wrote:
> > per cpu pages structure, aka pcp, has high and batch values to control
> > how many pages we perform caching. This values could be updated
> > asynchronously and updater should ensure that this doesn't make any
> > problem. For this purpose, pageset_update() is implemented and do some
> > memory synchronization. But, it turns out to be wrong when I implemented
> > new feature using this. There is no corresponding smp_rmb() in read-side
> 
> Out of curiosity, what new feature are you implementing?

I mean just zone_pcp_disable() and zone_pcp_enable(). :)

> IIRC, pageset_update() is used to update high and batch which can be changed
> during:
> 
> system boot
> sysfs
> memory hot-plug
> 
> So it seems to me that the latter two would have the problems you described here.

Yes, I think so. But I'm not sure, because I didn't look at it
in detail. :)

Thanks.

