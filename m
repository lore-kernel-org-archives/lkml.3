Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbbAHIS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:18:29 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33712 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbAHIS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:18:27 -0500
X-Original-SENDERIP: 10.177.222.153
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 8 Jan 2015 17:18:36 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
Message-ID: <20150108081835.GC25453@js1304-P5Q-DELUXE>
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com>
 <54ABA563.1040103@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54ABA563.1040103@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:05:39AM +0100, Vlastimil Babka wrote:
> On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
> > It'd be useful to know where the both scanner is start. And, it also be
> > useful to know current range where compaction work. It will help to find
> > odd behaviour or problem on compaction.
> 
> Overall it looks good, just two questions:
> 1) Why change the pfn output to hexadecimal with different printf layout and
> change the variable names and? Is it that better to warrant people having to
> potentially modify their scripts parsing the old output?

Deciaml output has really bad readability since we manage all pages by order
of 2 which is well represented by hexadecimal. With hex output, we can
easily notice whether we move out from one pageblock to another one.

> 2) Would it be useful to also print in the mm_compaction_isolate_template based
> tracepoints, pfn of where the particular scanner left off a block prematurely?
> It doesn't always match start_pfn + nr_scanned.

With start_pfn and end_pfn, detailed analysis is possible. We can know pageblock
where we actually scan and isolate and how much pages we try in that
pageblock and can guess why it doesn't become freepage with pageblock
order roughly.

nr_scanned is just different metric. end_pfn don't need to match with
start_pfn + nr_scanned.

Thanks.
