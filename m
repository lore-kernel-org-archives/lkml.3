Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933220AbaGURQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 13:16:11 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:33930 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932930AbaGURQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 13:16:08 -0400
Date: Mon, 21 Jul 2014 10:15:27 -0700
From: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jan Kara <jack@suse.cz>,
        Ingo Molnar <mingo@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Roman Gushchin <klamm@yandex-team.ru>, Xie XiuQi <xiexiuqi@huawei.com>,
        Tony Luck <tony.luck@intel.com>, linux-mm@kvack.org,
        linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 01/30] mm, kernel: Use cpu_to_mem()/numa_mem_id()
 to support memoryless node
Message-ID: <20140721171527.GA4156@linux.vnet.ibm.com>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-2-git-send-email-jiang.liu@linux.intel.com>
 <20140711151405.GK16041@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711151405.GK16041@linux.vnet.ibm.com>
X-Operating-System: Linux 3.13.0-32-generic (x86_64)
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072117-0320-0000-0000-0000000A700F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 11.07.2014 [08:14:05 -0700], Paul E. McKenney wrote:
> On Fri, Jul 11, 2014 at 03:37:18PM +0800, Jiang Liu wrote:
> > When CONFIG_HAVE_MEMORYLESS_NODES is enabled, cpu_to_node()/numa_node_id()
> > may return a node without memory, and later cause system failure/panic
> > when calling kmalloc_node() and friends with returned node id.
> > So use cpu_to_mem()/numa_mem_id() instead to get the nearest node with
> > memory for the/current cpu.
> > 
> > If CONFIG_HAVE_MEMORYLESS_NODES is disabled, cpu_to_mem()/numa_mem_id()
> > is the same as cpu_to_node()/numa_node_id().
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> 
> For the rcutorture piece:
> 
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Or if you separate the kernel/rcu/rcutorture.c portion into a separate
> patch, I will queue it separately.

Just FYI, based upon a separate discussion with Tejun and others, it
seems to be preferred to avoid the proliferation of cpu_to_mem
throughout the kernel blindly. For kthread_create_on_node(), I'm going
to try and fix the underlying issue and so you, as the caller, should
still specify the NUMA node you are running the kthread on
(cpu_to_node), not where you expect the memory to come from
(cpu_to_mem).

Thanks,
Nish

