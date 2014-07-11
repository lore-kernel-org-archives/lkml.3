Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbaGKPdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:33:10 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:51282 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbaGKPdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:33:06 -0400
Date: Fri, 11 Jul 2014 11:33:02 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jianyu Zhan <nasa4836@gmail.com>, malc <av1474@comtv.ru>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Fabian Frederick <fabf@skynet.be>, Tony Luck <tony.luck@intel.com>,
        linux-mm@kvack.org, linux-hotplug@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC Patch V1 07/30] mm: Use cpu_to_mem()/numa_mem_id() to
 support memoryless node
Message-ID: <20140711153302.GA30865@htj.dyndns.org>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com>
 <20140711144205.GA27706@htj.dyndns.org>
 <alpine.DEB.2.11.1407111012210.25527@gentwo.org>
 <20140711152156.GB29137@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711152156.GB29137@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:21:56AM -0400, Tejun Heo wrote:
> Even if that's the case, there's no reason to burden everyone with
> this distinction.  Most users just wanna say "I'm on this node.
> Please allocate considering that".  There's nothing wrong with using
> numa_node_id() for that.

Also, this is minor but don't we also lose fallback information by
doing this from the caller?  Please consider the following topology
where each hop is the same distance.

   A - B - X - C - D

Where X is the memless node.  num_mem_id() on X would return either B
or C, right?  If B or C can't satisfy the allocation, the allocator
would fallback to A from B and D for C, both of which aren't optimal.
It should first fall back to C or B respectively, which the allocator
can't do anymoe because the information is lost when the caller side
performs numa_mem_id().

Seems pretty misguided to me.

Thanks.

-- 
tejun
