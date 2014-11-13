Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751273AbaKMGiU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 01:38:20 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:60561 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbaKMGiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 01:38:19 -0500
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 13 Nov 2014 15:40:35 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Dave Hansen <dave@sr71.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>,
        Alexander Nyberg <alexn@dsv.su.se>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jungsoo Son <jungsoo.son@lge.com>, Ingo Molnar <mingo@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/5] mm/page_ext: resurrect struct page extending
 code for debugging
Message-ID: <20141113064035.GB18369@js1304-P5Q-DELUXE>
References: <1415780835-24642-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1415780835-24642-2-git-send-email-iamjoonsoo.kim@lge.com>
 <54638BE4.3080509@sr71.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54638BE4.3080509@sr71.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 08:33:40AM -0800, Dave Hansen wrote:
> On 11/12/2014 12:27 AM, Joonsoo Kim wrote:
> > @@ -1092,6 +1096,14 @@ struct mem_section {
> >  
> >  	/* See declaration of similar field in struct zone */
> >  	unsigned long *pageblock_flags;
> > +#ifdef CONFIG_PAGE_EXTENSION
> > +	/*
> > +	 * If !SPARSEMEM, pgdat doesn't have page_ext pointer. We use
> > +	 * section. (see page_ext.h about this.)
> > +	 */
> > +	struct page_ext *page_ext;
> > +	unsigned long pad;
> > +#endif
> 
> Will the distributions be amenable to enabling this?  If so, I'm all for
> it if it gets us things like page_owner at runtime.

Yes, I hope so.
At least, I can make it default to our product. But, how distributions
will do is beyond my power. :)

Thanks.
