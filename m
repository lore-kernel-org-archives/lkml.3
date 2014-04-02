Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912AbaDBSAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:00:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:50827 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932653AbaDBSAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:00:23 -0400
Date: Wed, 2 Apr 2014 14:00:19 -0400
From: Tejun Heo <tj@kernel.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org
Subject: Re: Kernel scanning/freeing to relieve cgroup memory pressure
Message-ID: <20140402180019.GL16631@htj.dyndns.org>
References: <533C0BB4.4070009@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533C0BB4.4070009@gopivotal.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing memcg maintainers and cgroup ML)

On Wed, Apr 02, 2014 at 02:08:04PM +0100, Glyn Normington wrote:
> Currently, a memory cgroup can hit its oom limit when pages could, in
> principle, be reclaimed by the kernel except that the kernel does not
> respond directly to cgroup-local memory pressure.

So, ummm, it does.

> A use case where this is important is running a moderately large Java
> application in a memory cgroup in a PaaS environment where cost to the
> user depends on the memory limit ([1]). Users need to tune the memory
> limit to reduce their costs. During application initialisation large
> numbers of JAR files are opened (read-only) and read while loading the
> application code and its dependencies. This is reflected in a peak of
> file cache usage which can push the memory cgroup memory usage
> significantly higher than the value actually needed to run the application.
> 
> Possible approaches include (1) automatic response to cgroup-local
> memory pressure in the kernel, and (2) a kernel API for reclaiming
> memory from a cgroup which could be driven under oom notification (with
> the oom killer disabled for the cgroup - it would be enabled if the
> cgroup was still oom after calling the kernel to reclaim memory).
> 
> Clearly (1) is the preferred approach. The closest facility in the
> kernel to (2) is to ask the kernel to free pagecache using `echo 1 >
> /proc/sys/vms/drop_caches`, but that is too wide-ranging, especially in
> a PaaS environment hosting multiple applications. A similar facility
> could be provided for a cgroup via a cgroup pseudo-file
> `memory.drop_caches`.
> 
> Other approaches include a mempressure cgroup ([2]) which would not be
> suitable for PaaS applications. See [3] for Andrew Morton's response. A
> related workaround ([4]) was included in the 3.6 kernel.
> 
> Related discussions:
> [1] https://groups.google.com/a/cloudfoundry.org/d/topic/vcap-dev/6M8BDV_tq7w/discussion
> [2]https://lwn.net/Articles/531077/ <https://lwn.net/Articles/531077/>
> [3]https://lwn.net/Articles/531138/ <https://lwn.net/Articles/531138/>
> [4]https://lkml.org/lkml/2013/6/6/462 <https://lkml.org/lkml/2013/6/6/462>&
> https://github.com/torvalds/linux/commit/e62e384e
> <https://github.com/torvalds/linux/commit/e62e384e>.

-- 
tejun
