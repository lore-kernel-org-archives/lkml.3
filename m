Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbbALOYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:24:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49241 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbbALOYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:24:00 -0500
Message-ID: <54B3D8E4.8030009@suse.cz>
Date: Mon, 12 Jan 2015 15:23:32 +0100
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] mm/compaction: change tracepoint format from decimal
 to hexadecimal
References: <1421050875-26332-1-git-send-email-iamjoonsoo.kim@lge.com>
In-Reply-To: <1421050875-26332-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2015 09:21 AM, Joonsoo Kim wrote:
> To check the range that compaction is working, tracepoint print
> start/end pfn of zone and start pfn of both scanner with decimal format.
> Since we manage all pages in order of 2 and it is well represented by
> hexadecimal, this patch change the tracepoint format from decimal to
> hexadecimal. This would improve readability. For example, it makes us
> easily notice whether current scanner try to compact previously
> attempted pageblock or not.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  include/trace/events/compaction.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/trace/events/compaction.h b/include/trace/events/compaction.h
> index c6814b9..1337d9e 100644
> --- a/include/trace/events/compaction.h
> +++ b/include/trace/events/compaction.h
> @@ -104,7 +104,7 @@ TRACE_EVENT(mm_compaction_begin,
>  		__entry->zone_end = zone_end;
>  	),
>  
> -	TP_printk("zone_start=%lu migrate_start=%lu free_start=%lu zone_end=%lu",
> +	TP_printk("zone_start=0x%lx migrate_start=0x%lx free_start=0x%lx zone_end=0x%lx",
>  		__entry->zone_start,
>  		__entry->migrate_start,
>  		__entry->free_start,
> 

