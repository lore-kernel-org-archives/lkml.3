Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab3HPW2K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:28:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43419 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab3HPW2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:28:08 -0400
Message-ID: <520E9898.7040107@wwwdotorg.org>
Date: Fri, 16 Aug 2013 15:24:40 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Kevin Hilman <khilman@linaro.org>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@surriel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Zlatko Calusic <zcalusic@bitsync.net>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "sfr@canb.auug.org.au linux-arm-kernel" 
	<linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [patch v2 3/3] mm: page_alloc: fair zone allocator policy
References: <1375457846-21521-1-git-send-email-hannes@cmpxchg.org> <1375457846-21521-4-git-send-email-hannes@cmpxchg.org> <20130807145828.GQ2296@suse.de> <20130807153743.GH715@cmpxchg.org> <20130808041623.GL1845@cmpxchg.org> <87haepblo2.fsf@kernel.org> <20130816201814.GA26409@cmpxchg.org>
In-Reply-To: <20130816201814.GA26409@cmpxchg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/16/2013 02:18 PM, Johannes Weiner wrote:
> Hi Kevin,
> 
> On Fri, Aug 16, 2013 at 10:17:01AM -0700, Kevin Hilman wrote:
>> Johannes Weiner <hannes@cmpxchg.org> writes:
>>> On Wed, Aug 07, 2013 at 11:37:43AM -0400, Johannes Weiner wrote:
>>> Subject: [patch] mm: page_alloc: use vmstats for fair zone allocation batching
>>>
>>> Avoid dirtying the same cache line with every single page allocation
>>> by making the fair per-zone allocation batch a vmstat item, which will
>>> turn it into batched percpu counters on SMP.
>>>
>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>
>> I bisected several boot failures on various ARM platform in
>> next-20130816 down to this patch (commit 67131f9837 in linux-next.)
>>
>> Simply reverting it got things booting again on top of -next.  Example
>> boot crash below.
> 
> Thanks for the bisect and report!
> 
> I deref the percpu pointers before initializing them properly.  It
> didn't trigger on x86 because the percpu offset added to the pointer
> is big enough so that it does not fall into PFN 0, but it probably
> ended up corrupting something...
> 
> Could you try this patch on top of linux-next instead of the revert?

That patch,
Tested-by: Stephen Warren <swarren@nvidia.com>
