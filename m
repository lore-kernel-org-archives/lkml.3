Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958AbaGKQY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:24:59 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:34088 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859AbaGKQYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:24:55 -0400
Date: Fri, 11 Jul 2014 12:24:51 -0400
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
Message-ID: <20140711162451.GD30865@htj.dyndns.org>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com>
 <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com>
 <20140711144205.GA27706@htj.dyndns.org>
 <alpine.DEB.2.11.1407111012210.25527@gentwo.org>
 <20140711152156.GB29137@htj.dyndns.org>
 <alpine.DEB.2.11.1407111056060.27349@gentwo.org>
 <20140711160152.GC30865@htj.dyndns.org>
 <alpine.DEB.2.11.1407111117560.27592@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1407111117560.27592@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 11:19:14AM -0500, Christoph Lameter wrote:
> Yes that works. But if we want a consistent node to allocate from (and
> avoid the fallbacks) then we need this patch. I think this is up to those
> needing memoryless nodes to figure out what semantics they need.

I'm not following what you're saying.  Are you saying that we need to
spread numa_mem_id() all over the place for GFP_THISNODE users on
memless nodes?  There aren't that many users of GFP_THISNODE.
Wouldn't it make far more sense to just change them?  Or just
introduce a new GFP flag GFP_CLOSE_OR_BUST which allows falling back
to the nearest local node for memless nodes.  There's no reason to
leak this information outside allocator proper.

Thanks.

-- 
tejun
