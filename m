Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932143Ab3KVWau (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 17:30:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755605Ab3KVWat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 17:30:49 -0500
Date: Fri, 22 Nov 2013 14:30:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dave.hansen@intel.com
Subject: Re: [PATCH] mmzone.h: constify some zone access functions
Message-Id: <20131122143047.51b4fbe7aa227b8e37908106@linux-foundation.org>
In-Reply-To: <20131122120106.4c372847@redhat.com>
References: <20131122120106.4c372847@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Nov 2013 12:01:06 -0500 Luiz Capitulino <lcapitulino@redhat.com> wrote:

> Signed-off-by: Luiz capitulino <lcapitulino@redhat.com>
> ---
>  include/linux/mmzone.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index bd791e4..5e202d6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -560,12 +560,12 @@ static inline bool zone_spans_pfn(const struct zone *zone, unsigned long pfn)
>  	return zone->zone_start_pfn <= pfn && pfn < zone_end_pfn(zone);
>  }
>  
> -static inline bool zone_is_initialized(struct zone *zone)
> +static inline bool zone_is_initialized(const struct zone *zone)
>  {
>  	return !!zone->wait_table;
>  }
>  
> -static inline bool zone_is_empty(struct zone *zone)
> +static inline bool zone_is_empty(const struct zone *zone)
>  {
>  	return zone->spanned_pages == 0;
>  }
> @@ -843,7 +843,7 @@ unsigned long __init node_memmap_size_bytes(int, unsigned long, unsigned long);
>   */
>  #define zone_idx(zone)		((zone) - (zone)->zone_pgdat->node_zones)
>  
> -static inline int populated_zone(struct zone *zone)
> +static inline int populated_zone(const struct zone *zone)
>  {
>  	return (!!zone->present_pages);
>  }

hm, why?  I counted ten similarly constifyable functions in mm.h and
stopped only 1/4 of the way through. What's so special about these three?

