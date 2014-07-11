Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbaGKQTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 12:19:24 -0400
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:54052 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754909AbaGKQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 12:19:19 -0400
Date: Fri, 11 Jul 2014 11:19:14 -0500 (CDT)
From: Christoph Lameter <cl@gentwo.org>
To: Tejun Heo <tj@kernel.org>
cc: Jiang Liu <jiang.liu@linux.intel.com>,
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
In-Reply-To: <20140711160152.GC30865@htj.dyndns.org>
Message-ID: <alpine.DEB.2.11.1407111117560.27592@gentwo.org>
References: <1405064267-11678-1-git-send-email-jiang.liu@linux.intel.com> <1405064267-11678-8-git-send-email-jiang.liu@linux.intel.com> <20140711144205.GA27706@htj.dyndns.org> <alpine.DEB.2.11.1407111012210.25527@gentwo.org> <20140711152156.GB29137@htj.dyndns.org>
 <alpine.DEB.2.11.1407111056060.27349@gentwo.org> <20140711160152.GC30865@htj.dyndns.org>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jul 2014, Tejun Heo wrote:

> On Fri, Jul 11, 2014 at 10:58:52AM -0500, Christoph Lameter wrote:
> > > But, GFP_THISNODE + numa_mem_id() is identical to numa_node_id() +
> > > nearest node with memory fallback.  Is there any case where the user
> > > would actually want to always fail if it's on the memless node?
> >
> > GFP_THISNODE allocatios must fail if there is no memory available on
> > the node. No fallback allowed.
>
> I don't know.  The intention is that the caller wants something on
> this node or the caller will fail or fallback ourselves, right?  For
> most use cases just considering the nearest memory node as "local" for
> memless nodes should work and serve the intentions of the users close
> enough.  Whether that'd be better or we'd be better off with something
> else depends on the details for sure.

Yes that works. But if we want a consistent node to allocate from (and
avoid the fallbacks) then we need this patch. I think this is up to those
needing memoryless nodes to figure out what semantics they need.


