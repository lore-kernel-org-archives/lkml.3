Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbaFBGUZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:20:25 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:56958 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaFBGUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:20:24 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 2 Jun 2014 15:23:45 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma
 reserved memory when not used
Message-ID: <20140602062344.GB7713@js1304-P5Q-DELUXE>
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com>
 <53883902.8020701@lge.com>
 <CAAmzW4Nyic0VC9W16ZbjsZtNGGBet4HBDomQfMi-OvMGMKv9iw@mail.gmail.com>
 <538C1196.9000608@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C1196.9000608@lge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 02:54:30PM +0900, Gioh Kim wrote:
> I found 2 problems at my platform.
> 
> 1st is occured when I set CMA size 528MB and total memory is 960MB.
> I print some values in adjust_managed_cma_page_count(),
> the total value becomes 105439 and cma value 131072.
> Finally movable value becomes negative value.
> 
> The total value 105439 means 411MB.
> Is the zone->managed_pages value pages amount except the CMA?
> I think zone->managed_pages value is including CMA size but it's value is strange.

Hmm...
zone->managed_pages includes nr of CMA pages.
Is there any mistake about your printk?

> 
> 2nd is a kernel panic at __netdev_alloc_skb().
> I'm not sure it is caused by the CMA.
> I'm checking it again and going to send you another report with detail call-stacks.

Okay.

Thanks.

