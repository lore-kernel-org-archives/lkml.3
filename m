Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaD1HKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 03:10:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46305 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaD1HKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 03:10:05 -0400
Date: Mon, 28 Apr 2014 09:09:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix v2] sched: fix possible invalid memory access caused by
 CPU hot-addition
Message-ID: <20140428070954.GM11096@twins.programming.kicks-ass.net>
References: <1398653293-12483-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398653293-12483-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 10:48:13AM +0800, Jiang Liu wrote:
> Intel platforms with Nehalem/Westmere/IvyBridge CPUs may support socket
> hotplug/online at runtime. The CPU hot-addition flow is:
> 1) handle CPU hot-addition event
> 	1.a) gather platform specific information
> 	1.b) associate hot-added CPU with NUMA node
> 	1.c) create CPU device
> 2) online hot-added CPU through sysfs:
> 	2.a)	cpu_up()
> 	2.b)		->try_online_node()
> 	2.c)			->hotadd_new_pgdat()
> 	2.d)			->node_set_online()
> 
> Between 1.b and 2.c, hot-added CPUs are associated with NUMA nodes
> but those NUMA nodes may still be in offlined state. So we should
> check node_online(nid) before calling kmalloc_node(nid) and friends,
> otherwise it may cause invalid memory access as below.

So complete and full NAK on this. This is a workaround for a fucked in
the head BIOS. If you're going to do a work around for that they should
live in arch/ space, not in core code.

The code in question is nearly 7 years old (2.6.24), which leads me to
believe it works just fine for (regular) memory less nodes as I've not
had complaints about it before.
