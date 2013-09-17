Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3IQG7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 02:59:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:46531 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3IQG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 02:59:47 -0400
Message-ID: <5237FDCC.5010109@oracle.com>
Date: Tue, 17 Sep 2013 14:59:24 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dave Hansen <dave.hansen@intel.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v2 0/5] mm: migrate zbud pages
References: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1378889944-23192-1-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On 09/11/2013 04:58 PM, Krzysztof Kozlowski wrote:
> Hi,
> 
> Currently zbud pages are not movable and they cannot be allocated from CMA
> (Contiguous Memory Allocator) region. These patches add migration of zbud pages.
> 

I agree that the migration of zbud pages is important so that system
will not enter order-0 page fragmentation and can be helpful for page
compaction/huge pages etc..

But after I looked at the [patch 4/5], I found it will make zbud very
complicated.
I'd prefer to add this migration feature later until current version
zswap/zbud becomes better enough and more stable.

Mel mentioned several problems about zswap/zbud in thread "[PATCH v6
0/5] zram/zsmalloc promotion".

Like "it's clunky as hell and the layering between zswap and zbud is
twisty" and "I think I brought up its stalling behaviour during review
when it was being merged. It would have been preferable if writeback
could be initiated in batches and then waited on at the very least..
 It's worse that it uses _swap_writepage directly instead of going
through a writepage ops.  It would have been better if zbud pages
existed on the LRU and written back with an address space ops and
properly handled asynchonous writeback."

So I think it would be better if we can address those issues at first
and it would be easier to address these issues before adding more new
features. Welcome any ideas.

-- 
Regards,
-Bob
