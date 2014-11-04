Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaKDKwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:52:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:48816 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaKDKwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:52:13 -0500
Date: Tue, 4 Nov 2014 11:52:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Rik van Riel <riel@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sched/fair: fix use stale overloaded status to find
 busiest group
Message-ID: <20141104105203.GM3337@twins.programming.kicks-ass.net>
References: <1415079056-8679-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415079056-8679-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 01:30:56PM +0800, Wanpeng Li wrote:
> Commit caeb178c60f4 ("sched/fair: Make update_sd_pick_busiest() return 
> 'true' on a busier sd") makes groups are ranked in the order overloaded > 
> imbalance > other and busiest group is picked according to this order. 
> sgs->group_capacity_factor is used to check if group is overloaded. In 
> the case of the child domain prefers tasks go to siblings first, the 
> sgs->group_capacity_factor will be set lower to one in order to move all 
> the excess tasks away. However, group overloaded status is not updated 
> in the case of sgs->group_capacity_factor be set lower to one which 
> leads to miss find the busiest group. This patch fix it by updating 
> group overloaded status in the case of sg capacity factor is set to 
> one in order to find busiest group accurately.

You noticed this while going over Vincents patches, right?

Also, try and introduce some newlines in the changelog, paragraphs of
3-5 lines are best.
