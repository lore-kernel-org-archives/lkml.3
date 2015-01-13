Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751796AbbAMIfb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 03:35:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60940 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbbAMIf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 03:35:28 -0500
Message-ID: <54B4D8CE.3070503@suse.cz>
Date: Tue, 13 Jan 2015 09:35:26 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] mm/compaction: add tracepoint to observe behaviour
 of compaction defer
References: <1421050875-26332-1-git-send-email-iamjoonsoo.kim@lge.com> <1421050875-26332-5-git-send-email-iamjoonsoo.kim@lge.com> <54B3F7E3.4000803@suse.cz> <20150113071839.GB29898@js1304-P5Q-DELUXE>
In-Reply-To: <20150113071839.GB29898@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 08:18 AM, Joonsoo Kim wrote:
> On Mon, Jan 12, 2015 at 05:35:47PM +0100, Vlastimil Babka wrote:
>> Hm what if we avoided dirtying the cache line in the non-deferred case? Would be
>> simpler, too?
>> 
>> if (zone->compact_considered + 1 >= defer_limit)
>>      return false;
>> 
>> zone->compact_considered++;
>> 
>> trace_mm_compaction_defer_compaction(zone, order);
>> 
>> return true;
> 
> Okay. I will include this minor optimization in next version of this
> patch.

Hm, on second thought, the "+ 1" part would break compaction_restarting() and
it's ugly anyway. Removing "+ 1" would increase the number of
compaction_deferred() attempts until success by one. Which should be negligible,
but maybe not good to hide it in a tracepoint patch. Sorry for the noise.

> Thanks.
> 

