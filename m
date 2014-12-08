Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401AbaLHIcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:32:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753901AbaLHIcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:32:23 -0500
Message-ID: <54856213.9070909@suse.cz>
Date: Mon, 08 Dec 2014 09:32:19 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Minchan Kim <minchan@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>
Subject: Re: [RFC PATCH V2 0/4] Reducing parameters of alloc_pages* family
 of functions
References: <1417809545-4540-1-git-send-email-vbabka@suse.cz> <CA+55aFwvWk6twgBaevPrF5z_0Faetnh0L19ZokWLidiaAaUmQg@mail.gmail.com>
In-Reply-To: <CA+55aFwvWk6twgBaevPrF5z_0Faetnh0L19ZokWLidiaAaUmQg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2014 02:07 AM, Linus Torvalds wrote:
> On Fri, Dec 5, 2014 at 11:59 AM, Vlastimil Babka <vbabka@suse.cz> wrote:
>> Hey all,
>>
>> this is a V2 of attempting something that has been discussed when Minchan
>> proposed to expand the x86 kernel stack [1], namely the reduction of huge
>> number of parameters that the alloc_pages* family and get_page_from_freelist()
>> functions have.
>
> So I generally like this, but looking at that "struct alloc_context",
> one member kind of stands out: the "order" parameter doesn't fit in
> with all the other members.
>
> Most everything else is describing where or what kind of pages to work
> with. The "order" in contrast, really is separate.
>
> So conceptually, my reaction is that it looks like a good cleanup even
> aside from the code/stack size reduction, but that the alloc_context
> definition is a bit odd.
>
> Quite frankly, I think the :"order" really fits much more closely with
> "alloc_flags", not with the alloc_context. Because like alloc_flags,.
> it really describes how we need to allocate things within the context,
> I'd argue.
>
> In fact, I think that the order could actually be packed with the
> alloc_flags in a single register, even on 32-bit (using a single-word
> structure, perhaps). If we really care about number of parameters.
>
> I'd rather go for "makes conceptual sense" over "packs order in
> because it kind of works" and we don't modify it".
>
> Hmm?

Thanks for the suggestions, order indeed stands out. I'll check if it 
makes more sense to have it separately, or pack as you suggest. Packing
could perhaps bring more complexity than the benefit of less parameters. 
But the suggestion made me realize that migratetype could be also packed 
into alloc_flags and it would be more straightforward for that than order.

With order and migratetype out, everything left in alloc_context would 
be about nodes and zones, which is also good I guess. Maybe a different 
name for the structure then?

Vlastimil

>
>                         Linus
>

