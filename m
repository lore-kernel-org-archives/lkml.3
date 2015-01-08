Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808AbbAHIqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:46:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33830 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579AbbAHIqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:46:30 -0500
Message-ID: <54AE43E3.60209@suse.cz>
Date: Thu, 08 Jan 2015 09:46:27 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/compaction: enhance trace output to know more
 about compaction internals
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com> <54ABA563.1040103@suse.cz> <20150108081835.GC25453@js1304-P5Q-DELUXE>
In-Reply-To: <20150108081835.GC25453@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 09:18 AM, Joonsoo Kim wrote:
> On Tue, Jan 06, 2015 at 10:05:39AM +0100, Vlastimil Babka wrote:
>> On 12/03/2014 08:52 AM, Joonsoo Kim wrote:
>> > It'd be useful to know where the both scanner is start. And, it also be
>> > useful to know current range where compaction work. It will help to find
>> > odd behaviour or problem on compaction.
>> 
>> Overall it looks good, just two questions:
>> 1) Why change the pfn output to hexadecimal with different printf layout and
>> change the variable names and? Is it that better to warrant people having to
>> potentially modify their scripts parsing the old output?
> 
> Deciaml output has really bad readability since we manage all pages by order
> of 2 which is well represented by hexadecimal. With hex output, we can
> easily notice whether we move out from one pageblock to another one.

OK. I don't have any strong objection, maybe Mel should comment on this as the
author of most of the tracepoints? But if it happens, I think converting the old
tracepoints to new hexadecimal format should be a separate patch from adding the
new ones.

>> 2) Would it be useful to also print in the mm_compaction_isolate_template based
>> tracepoints, pfn of where the particular scanner left off a block prematurely?
>> It doesn't always match start_pfn + nr_scanned.
> 
> With start_pfn and end_pfn, detailed analysis is possible. We can know pageblock
> where we actually scan and isolate and how much pages we try in that
> pageblock and can guess why it doesn't become freepage with pageblock
> order roughly.
> 
> nr_scanned is just different metric. end_pfn don't need to match with
> start_pfn + nr_scanned.

Well that's part of my point. end_pfn is the end of the pageblock. nr_scanned
might be lower than end_pfn - start_pfn, because we terminate in the middle of
the pageblock. But it might be also lower, because we e.g. skip higher-order
free pages. So we don't recognize where we terminated early.

> Thanks.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

