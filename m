Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaLJJzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 04:55:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36794 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbaLJJzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 04:55:04 -0500
Message-ID: <54881876.70309@suse.cz>
Date: Wed, 10 Dec 2014 10:55:02 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] mm/page_alloc: expands broken freepage to proper
 buddy list when steal
References: <1418022980-4584-1-git-send-email-iamjoonsoo.kim@lge.com> <1418022980-4584-3-git-send-email-iamjoonsoo.kim@lge.com> <54856F88.8090300@suse.cz> <20141210063840.GC13371@js1304-P5Q-DELUXE>
In-Reply-To: <20141210063840.GC13371@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2014 07:38 AM, Joonsoo Kim wrote:
> On Mon, Dec 08, 2014 at 10:29:44AM +0100, Vlastimil Babka wrote:
>> On 12/08/2014 08:16 AM, Joonsoo Kim wrote:
>>> There is odd behaviour when we steal freepages from other migratetype
>>> buddy list. In try_to_steal_freepages(), we move all freepages in
>>> the pageblock that founded freepage is belong to to the request
>>> migratetype in order to mitigate fragmentation. If the number of moved
>>> pages are enough to change pageblock migratetype, there is no problem. If
>>> not enough, we don't change pageblock migratetype and add broken freepages
>>> to the original migratetype buddy list rather than request migratetype
>>> one. For me, this is odd, because we already moved all freepages in this
>>> pageblock to the request migratetype. This patch fixes this situation to
>>> add broken freepages to the request migratetype buddy list in this case.
>>
>> I'd rather split the fix from the refactoring. And maybe my
>> description is longer, but easier to understand? (I guess somebody
>> else should judge this)
>
> Your patch is much better to understand than mine. :)
> No need to judge from somebody else.
> After your patch is merged, I will resubmit these on top of it.

Thanks. I'm doing another evaluation focusing on number of unmovable 
pageblocks as Mel suggested and then resubmit with tracepoint fixed.

Vlastimil
