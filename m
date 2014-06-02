Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898AbaFBGOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:14:32 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45237 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbaFBGOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:14:31 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Mon, 2 Jun 2014 15:17:51 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Gioh Kim <gioh.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Laura Abbott <lauraa@codeaurora.org>,
        Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma
 reserved memory when not used
Message-ID: <20140602061751.GA7713@js1304-P5Q-DELUXE>
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com>
 <5386E0CA.5040201@lge.com>
 <20140529074847.GA7554@js1304-P5Q-DELUXE>
 <5386EB3E.5090007@lge.com>
 <20140530004514.GB8906@js1304-P5Q-DELUXE>
 <xa1tha46hl1w.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xa1tha46hl1w.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 09:02:51AM +0900, Michal Nazarewicz wrote:
> > On Thu, May 29, 2014 at 05:09:34PM +0900, Gioh Kim wrote:
> >> Is IS_ENABLED(CONFIG_CMA) necessary?
> >> What about if (migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages) ?
> 
> On Fri, May 30 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > Yes, field, managed_cma_pages exists only if CONFIG_CMA is enabled, so
> > removing IS_ENABLE(CONFIG_CMA) would break the build.
> 
> That statement makes no sense.  If zone->managed_cma_pages not being
> defined is the problem, what you need is:
> 
> +#ifdef CONFIG_CMA
> +	if (migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages)
> +		page = __rmqueue_cma(zone, order);
> +#endif
> 
> If you use IS_ENABLED, zone-managed_cma_pages has to be defined
> regardless of result of state of CONFIG_CMA.


Hello,

Oops. I totally misunderstand how IS_ENABLED works.
Thanks for spotting this.

Thanks.
