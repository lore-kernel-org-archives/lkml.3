Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbbAIBEd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 20:04:33 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35681 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbbAIBEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 20:04:32 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 9 Jan 2015 10:04:42 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
Message-ID: <20150109010441.GA27760@js1304-P5Q-DELUXE>
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
 <54ABA563.1040103@suse.cz>
 <20150108081835.GC25453@js1304-P5Q-DELUXE>
 <54AE43E3.60209@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AE43E3.60209@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 09:46:27AM +0100, Vlastimil Babka wrote:
> On 01/08/2015 09:18 AM, Joonsoo Kim wrote:
> > On Tue, Jan 06, 2015 at 10:05:39AM +0100, Vlastimil Babka wrote:
> >> On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
> >> > It'd be useful to know where the both scanner is start. And, it also be
> >> > useful to know current range where compaction work. It will help to find
> >> > odd behaviour or problem on compaction.
> >> 
> >> Overall it looks good, just two questions:
> >> 1) Why change the pfn output to hexadecimal with different printf layout and
> >> change the variable names and? Is it that better to warrant people having to
> >> potentially modify their scripts parsing the old output?
> > 
> > Deciaml output has really bad readability since we manage all pages by order
> > of 2 which is well represented by hexadecimal. With hex output, we can
> > easily notice whether we move out from one pageblock to another one.
> 
> OK. I don't have any strong objection, maybe Mel should comment on this as the
> author of most of the tracepoints? But if it happens, I think converting the old
> tracepoints to new hexadecimal format should be a separate patch from adding the
> new ones.

Okay.

> 
> >> 2) Would it be useful to also print in the mm_compaction_isolate_template based
> >> tracepoints, pfn of where the particular scanner left off a block prematurely?
> >> It doesn't always match start_pfn + nr_scanned.
> > 
> > With start_pfn and end_pfn, detailed analysis is possible. We can know pageblock
> > where we actually scan and isolate and how much pages we try in that
> > pageblock and can guess why it doesn't become freepage with pageblock
> > order roughly.
> > 
> > nr_scanned is just different metric. end_pfn don't need to match with
> > start_pfn + nr_scanned.
> 
> Well that's part of my point. end_pfn is the end of the pageblock. nr_scanned
> might be lower than end_pfn - start_pfn, because we terminate in the middle of
> the pageblock. But it might be also lower, because we e.g. skip higher-order
> free pages. So we don't recognize where we terminated early.

Ah... now I see your point and found my mistake. My intention is also to
print terminated pfn rather than end_pfn of pageblock. :/
I will change it to print pfn where we terminate scanning.

Thanks.
