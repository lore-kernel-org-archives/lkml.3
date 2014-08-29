Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaH2IMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:12:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbaH2IMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:12:16 -0400
Date: Fri, 29 Aug 2014 09:12:11 +0100
From: Mel Gorman <mgorman@suse.de>
To: Weijie Yang <weijie.yang@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Rik van Riel'" <riel@redhat.com>,
        "'Johannes Weiner'" <hannes@cmpxchg.org>, rientjes@google.com,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: page_alloc: avoid wakeup kswapd on the unintended
 node
Message-ID: <20140829081211.GF12424@suse.de>
References: <000001cfc357$74db64a0$5e922de0$%yang@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <000001cfc357$74db64a0$5e922de0$%yang@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 03:03:19PM +0800, Weijie Yang wrote:
> When enter page_alloc slowpath, we wakeup kswapd on every pgdat
> according to the zonelist and high_zoneidx. However, this doesn't
> take nodemask into account, and could prematurely wakeup kswapd on
> some unintended nodes.
> 
> This patch uses for_each_zone_zonelist_nodemask() instead of
> for_each_zone_zonelist() in wake_all_kswapds() to avoid the above situation.
> 
> Signed-off-by: Weijie Yang <weijie.yang@samsung.com>

Just out of curiousity, did you measure a problem due to this or is
the patch due to code inspection? It was known that we examined useless
nodes but assumed to not be a problem because the watermark check should
prevent spurious wakeups.  However, we do a cpuset check and this patch
is consistent with that so regardless of why you wrote the patch

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
