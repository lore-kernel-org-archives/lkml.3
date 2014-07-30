Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436AbaG3PFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 11:05:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40599 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753822AbaG3PFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 11:05:42 -0400
Message-ID: <53D909C2.2010300@suse.cz>
Date: Wed, 30 Jul 2014 17:05:38 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joonsoo Kim <js1304@gmail.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Subject: Re: [PATCH v5 14/14] mm, compaction: try to capture the just-created
 high-order freepage
References: <1406553101-29326-1-git-send-email-vbabka@suse.cz>	<1406553101-29326-15-git-send-email-vbabka@suse.cz>	<20140729073456.GC1610@js1304-P5Q-DELUXE>	<53D7BF0D.5050404@suse.cz>	<20140730083920.GA24427@js1304-P5Q-DELUXE>	<53D8C16B.7070206@suse.cz> <CAAmzW4N28-6W1-K5xHHGOzYEFtFkXOzeP35iC-VdQCP-EOtANA@mail.gmail.com>
In-Reply-To: <CAAmzW4N28-6W1-K5xHHGOzYEFtFkXOzeP35iC-VdQCP-EOtANA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 04:19 PM, Joonsoo Kim wrote:
>>> But, I guess that there is a reason that watermark_ok() is so
>>> conservative. If page allocator aggressively provides high order page,
>>> future atomic high order page request cannot succeed easily. For
>>> preventing this situation, watermark_ok() should be conservative.
>>
>>
>> I don't think it's intentionally conservative, just unreliable. It tests two
>> things together:
>>
>> 1) are there enough free pages for the allocation wrt watermarks?
>> 2) does it look like that there is a free page of the requested order?
>
> I don't think that watermark_ok()'s intention is checking if there is a free
> page of the requested order. If we want to know it, we could use more
> easy way something like below.
>
> X = number of total freepage - number of freepage lower than requested order
> If X is positive, we can conclude that there is at least one freepage
> of requested order and this equation is easy to compute.

I thought that's basically what it does, but...

> But, watermark_ok() doesn't do that. Instead, it uses mark value to determine
> if we can go further. I guess that this means that allocation/reclaim logic want
> to preserve certain level of high order freepages according to system memory
> size, although I don't know what the reason is exactly. So
> the "aggressiveness" on capture logic here could break what
> allocation/reclaim want.

Hm I see your point. So OK, I will check if the order=0 makes the 
difference for page capture or not.

> Thanks.
>

