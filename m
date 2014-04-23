Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbaDWFvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 01:51:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:57843 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbaDWFvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 01:51:12 -0400
Date: Wed, 23 Apr 2014 07:51:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [Bugfix] sched: fix possible invalid memory access caused by CPU
 hot-addition
Message-ID: <20140423055107.GB1429@laptop.programming.kicks-ass.net>
References: <1398144435-26271-1-git-send-email-jiang.liu@linux.intel.com>
 <20140422081515.GF11182@twins.programming.kicks-ass.net>
 <53572939.7020509@linux.intel.com>
 <20140423053213.GV26782@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140423053213.GV26782@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 07:32:13AM +0200, Peter Zijlstra wrote:
> On Wed, Apr 23, 2014 at 10:45:13AM +0800, Jiang Liu wrote:
> > Hi Peter,
> > 	It's not for memoryless node, but to solve a race window
> > in CPU hot-addition. The related CPU hot-addition flow is:
> > 1) Handle CPU hot-addition event
> > 1.a) gather platform specific information
> > 1.b) associate hot-added CPU with a node
> > 1.c) create CPU device
> > 2) User online hot-added CPUs through sysfs:
> > 2.a)	cpu_up()
> > 2.b)		->try_online_node()
> > 2.c)			->hotadd_new_pgdat()
> > 2.d)			->node_set_online()
> > 
> > So between 1.b and 2.c, kmalloc_node(nid) may cause invalid
> > memory access without the node_online(nid) check.
> 
> Any why was all this not in the Changelog?

Also, do explain what kind of hardware you needed to trigger this. This
code has been like this for a good while.
