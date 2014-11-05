Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbaKEKvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:51:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43995 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262AbaKEKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:51:08 -0500
Date: Wed, 5 Nov 2014 11:50:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@arm.com>,
        Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] sched/deadline: support dl task migration during
 cpu hotplug
Message-ID: <20141105105058.GQ3337@twins.programming.kicks-ass.net>
References: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415177517-7189-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:51:57PM +0800, Wanpeng Li wrote:
> Note: dl task can be migrated successfully if rq is offline currently, however, 
> I'm still not sure why task_rq(task)->rd->span just include the cpu which the dl 
> task previous running on, so cpu_active_mask is used in the patch. 
> 
> Peterz, Juri?

So the root domain span is for exclusive cpusets
(Documentation/cgroups/cpusets.txt) where we fully separate sets of CPUs
and have no load-balancing between the sets.

For 'normal' setups the rd->span is the entire machine, but using
cpusets you can create more (smaller) domains.

Is this what you were asking?
