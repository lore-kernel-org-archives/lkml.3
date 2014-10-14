Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaJNGrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 02:47:40 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43295 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaJNGrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 02:47:39 -0400
Date: Tue, 14 Oct 2014 08:47:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, mgorman@suse.de, chegu_vinod@hp.com,
        mingo@kernel.org, efault@gmx.de, vincent.guittot@linaro.org
Subject: Re: [PATCH RFC 1/5] sched,numa: build table of node hop distance
Message-ID: <20141014064720.GA11483@worktop>
References: <1412797050-8903-1-git-send-email-riel@redhat.com>
 <1412797050-8903-2-git-send-email-riel@redhat.com>
 <20141012131714.GE3015@worktop>
 <543A81E4.4090504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543A81E4.4090504@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 09:28:04AM -0400, Rik van Riel wrote:
> On 10/12/2014 09:17 AM, Peter Zijlstra wrote:
> >On Wed, Oct 08, 2014 at 03:37:26PM -0400, riel@redhat.com wrote:
> >>+	sched_domains_numa_hops = kzalloc(sizeof(int) * nr_node_ids * nr_node_ids, GFP_KERNEL);
> >>+	if (!sched_domains_numa_hops)
> >>+		return;
> >
> >That's potentially a _BIG_ table (1M for a 512 node system).
> >The node_distance has magic allocations and is of u8 size, is there any
> >way we can re-use node_distance and avoid a second O(n^2) allocation?
> 
> You are right, this should be a u8 at the least.
> 
> Beyond that, I am not convinced that merging things into
> the same array is worthwhile, since (IIRC) nr_node_ids
> should be set to the actual number of nodes on the system
> by then.

The thing is, it looks like all you do is compare hop distance, and the
order of the hop distances is the exact same order as the regular numa
distance. I could not find a place where you use the actual hop value.

So if all you're interested in is the relative ordering, that should be
the same for both.
