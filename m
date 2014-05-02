Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbaEBWfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 18:35:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25191 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaEBWfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 18:35:07 -0400
Message-ID: <53641D8C.6040601@oracle.com>
Date: Fri, 02 May 2014 18:34:52 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Linux-FSDevel <linux-fsdevel@vger.kernel.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
        Jan Kara <jack@suse.cz>, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/17] mm: page_alloc: Use word-based accesses for get/set
 pageblock bitmaps
References: <1398933888-4940-1-git-send-email-mgorman@suse.de> <1398933888-4940-9-git-send-email-mgorman@suse.de>
In-Reply-To: <1398933888-4940-9-git-send-email-mgorman@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Vlastimil Babka suggested I should try this patch to work around a different
issue I'm seeing, and noticed that it doesn't build because:

On 05/01/2014 04:44 AM, Mel Gorman wrote:
> +void set_pageblock_flags_mask(struct page *page,
> +				unsigned long flags,
> +				unsigned long end_bitidx,
> +				unsigned long nr_flag_bits,
> +				unsigned long mask);

set_pageblock_flags_mask() is declared.


> +static inline void set_pageblock_flags_group(struct page *page,
> +					unsigned long flags,
> +					int start_bitidx, int end_bitidx)
> +{
> +	unsigned long nr_flag_bits = end_bitidx - start_bitidx + 1;
> +	unsigned long mask = (1 << nr_flag_bits) - 1;
> +
> +	set_pageblock_flags_mask(page, flags, end_bitidx, nr_flag_bits, mask);
> +}

And used here, but never actually defined.


Thanks,
Sasha
