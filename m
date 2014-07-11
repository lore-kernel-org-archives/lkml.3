Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbaGKS2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 14:28:19 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:48936 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbaGKS2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 14:28:18 -0400
Date: Fri, 11 Jul 2014 14:28:14 -0400
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
Message-ID: <20140711182814.GE30865@htj.dyndns.org>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com>
 <20140711144205.GA27706@htj.dyndns.org>
 <alpine.DEB.2.11.1407111012210.25527@gentwo.org>
 <20140711152156.GB29137@htj.dyndns.org>
 <alpine.DEB.2.11.1407111056060.27349@gentwo.org>
 <20140711160152.GC30865@htj.dyndns.org>
 <alpine.DEB.2.11.1407111117560.27592@gentwo.org>
 <20140711162451.GD30865@htj.dyndns.org>
 <alpine.DEB.2.11.1407111220410.4511@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407111220410.4511@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jul 11, 2014 at 12:29:30PM -0500, Christoph Lameter wrote:
> GFP_THISNODE is mostly used by allocators that need memory from specific
> nodes. The use of numa_mem_id() there is useful because one will not
> get any memory at all when attempting to allocate from a memoryless
> node using GFP_THISNODE.

As long as it's in allocator proper, it doesn't matter all that much
but the changes are clearly not contained, are they?

Also, unless this is done where the falling back is actually
happening, numa_mem_id() seems like the wrong interface because you
end up losing information of the originating node.  Given that this
isn't a wide spread use case, maybe we can do with something like
numa_mem_id() as a compromise but if we're doing that let's at least
make it clear that it's something ugly (give it an ugly name, not
something as generic as numa_mem_id()) and not expose it outside
allocators.

Thanks.

-- 
tejun
