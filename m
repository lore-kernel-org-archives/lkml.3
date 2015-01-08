Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbbAHIrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 03:47:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33849 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753344AbbAHIre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 03:47:34 -0500
Message-ID: <54AE4424.3070406@suse.cz>
Date: Thu, 08 Jan 2015 09:47:32 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/compaction: add more trace to understand compaction
 start/finish condition
References: <1417593127-6819-1-git-send-email-iamjoonsoo.kim@lge.com> <1417593127-6819-2-git-send-email-iamjoonsoo.kim@lge.com> <54ABC13C.4030403@suse.cz> <20150108082114.GD25453@js1304-P5Q-DELUXE>
In-Reply-To: <20150108082114.GD25453@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2015 09:21 AM, Joonsoo Kim wrote:
> 
> Okay. How about adding one more like below?
> 
> #define COMPACT_NO_SUITABLE_PAGE
> #define COMPACT_NOT_SUITABLE_ZONE

Yeah that would be less confusing.

> It will distiguish return value properly.
> 
>> >  	return COMPACT_CONTINUE;
>> >  }
>> >  
>> > +unsigned long compaction_suitable(struct zone *zone, int order,
>> > +					int alloc_flags, int classzone_idx)
>> > +{
>> > +	unsigned long ret;
>> > +
>> > +	ret = __compaction_suitable(zone, order, alloc_flags, classzone_idx);
>> > +	trace_mm_compaction_suitable(zone, order, alloc_flags,
>> > +						classzone_idx, ret);
>> > +	if (ret == COMPACT_NOT_SUITABLE)
>> > +		ret = COMPACT_SKIPPED;
>> 
>> I don't like this wrapping just for tracepints, but I don't know of a better way :/
> 
> Yes, I don't like it, too. :/
> 
> Thanks.
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

