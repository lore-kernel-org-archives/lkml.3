Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbaCFVNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 16:13:43 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53080 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753525AbaCFVNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 16:13:41 -0500
Date: Thu, 6 Mar 2014 16:13:37 -0500
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [patch 09/11] mm, page_alloc: allow system oom handlers to use
 memory reserves
Message-ID: <20140306211337.GC17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041956510.8067@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041956510.8067@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:35PM -0800, David Rientjes wrote:
> The root memcg allows unlimited memory charging, so no memory may be
> reserved for userspace oom handlers that are responsible for dealing
> with system oom conditions.
> 
> Instead, this memory must come from per-zone memory reserves.  This
> allows the memory allocation to succeed, and the memcg charge will
> naturally succeed afterwards.
> 
> This patch introduces per-zone oom watermarks that aren't really
> watermarks in the traditional sense.  The oom watermark is the root
> memcg's oom reserve proportional to the size of the zone.  When a page
> allocation is done, the effective watermark is
> 
> 	[min/low/high watermark] - [oom watermark]
> 
> For the [min watermark] case, this is effectively the oom reserve.
> However, it also adjusts the low and high watermark accordingly so
> memory is actually only allocated from min reserves when appropriate.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Until consensus on the whole approach can be reached,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
