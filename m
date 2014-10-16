Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbaJPPL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 11:11:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50347 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaJPPL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 11:11:26 -0400
Message-ID: <543FE01A.5020205@suse.cz>
Date: Thu, 16 Oct 2014 17:11:22 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/5] mm, compaction: simplify deferred compaction
References: <1412696019-21761-1-git-send-email-vbabka@suse.cz>	<1412696019-21761-3-git-send-email-vbabka@suse.cz> <20141015153212.7b9029c8bb8e9c1b8736181d@linux-foundation.org>
In-Reply-To: <20141015153212.7b9029c8bb8e9c1b8736181d@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 12:32 AM, Andrew Morton wrote:
> On Tue,  7 Oct 2014 17:33:36 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>> @@ -105,8 +104,7 @@ static inline bool compaction_restarting(struct zone *zone, int order)
>>  static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
>>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>>  			enum migrate_mode mode, int *contended,
>> -			int alloc_flags, int classzone_idx,
>> -			struct zone **candidate_zone)
>> +			int alloc_flags, int classzone_idx);
>>  {
>>  	return COMPACT_CONTINUE;
>>  }
> 
> --- a/include/linux/compaction.h~mm-compaction-simplify-deferred-compaction-fix
> +++ a/include/linux/compaction.h
> @@ -104,7 +104,7 @@ static inline bool compaction_restarting
>  static inline unsigned long try_to_compact_pages(struct zonelist *zonelist,
>  			int order, gfp_t gfp_mask, nodemask_t *nodemask,
>  			enum migrate_mode mode, int *contended,
> -			int alloc_flags, int classzone_idx);
> +			int alloc_flags, int classzone_idx)
>  {
>  	return COMPACT_CONTINUE;
>  }
> 
> It clearly wasn't tested with this config.  Please do so and let us
> know the result?

Sorry, forgot. Hopefully will get better next time, since I learned
about the undertaker/vampyr tool [1] today.

You patch does fix the compilation, thanks. Boot+stress-highalloc tests
are now running through the series but I don't expect any surprises -
the series is basically a no-op with CONFIG_COMPACTION disabled.

[1] http://lwn.net/Articles/616098/
