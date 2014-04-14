Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588AbaDNUuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 16:50:54 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:58836 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbaDNUuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 16:50:52 -0400
Date: Mon, 14 Apr 2014 16:50:34 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Glyn Normington <gnormington@gopivotal.com>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: Kernel scanning/freeing to relieve cgroup memory pressure
Message-ID: <20140414205034.GA6443@cmpxchg.org>
References: <533C0BB4.4070009@gopivotal.com>
 <20140402180019.GL16631@htj.dyndns.org>
 <534B982D.8060106@gopivotal.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534B982D.8060106@gopivotal.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 09:11:25AM +0100, Glyn Normington wrote:
> Johannes/Michal
> 
> What are your thoughts on this matter? Do you see this as a valid
> requirement?

As Tejun said, memory cgroups *do* respond to internal pressure and
enter targetted reclaim before invoking the OOM killer.  So I'm not
exactly sure what you are asking.

> On 02/04/2014 19:00, Tejun Heo wrote:
> >(cc'ing memcg maintainers and cgroup ML)
> >
> >On Wed, Apr 02, 2014 at 02:08:04PM +0100, Glyn Normington wrote:
> >>Currently, a memory cgroup can hit its oom limit when pages could, in
> >>principle, be reclaimed by the kernel except that the kernel does not
> >>respond directly to cgroup-local memory pressure.
> >So, ummm, it does.
> >
> >>A use case where this is important is running a moderately large Java
> >>application in a memory cgroup in a PaaS environment where cost to the
> >>user depends on the memory limit ([1]). Users need to tune the memory
> >>limit to reduce their costs. During application initialisation large
> >>numbers of JAR files are opened (read-only) and read while loading the
> >>application code and its dependencies. This is reflected in a peak of
> >>file cache usage which can push the memory cgroup memory usage
> >>significantly higher than the value actually needed to run the application.
> >>
> >>Possible approaches include (1) automatic response to cgroup-local
> >>memory pressure in the kernel, and (2) a kernel API for reclaiming
> >>memory from a cgroup which could be driven under oom notification (with
> >>the oom killer disabled for the cgroup - it would be enabled if the
> >>cgroup was still oom after calling the kernel to reclaim memory).
> >>
> >>Clearly (1) is the preferred approach. The closest facility in the
> >>kernel to (2) is to ask the kernel to free pagecache using `echo 1 >
> >>/proc/sys/vms/drop_caches`, but that is too wide-ranging, especially in
> >>a PaaS environment hosting multiple applications. A similar facility
> >>could be provided for a cgroup via a cgroup pseudo-file
> >>`memory.drop_caches`.
> >>
> >>Other approaches include a mempressure cgroup ([2]) which would not be
> >>suitable for PaaS applications. See [3] for Andrew Morton's response. A
> >>related workaround ([4]) was included in the 3.6 kernel.
> >>
> >>Related discussions:
> >>[1] https://groups.google.com/a/cloudfoundry.org/d/topic/vcap-dev/6M8BDV_tq7w/discussion
> >>[2]https://lwn.net/Articles/531077/ <https://lwn.net/Articles/531077/>
> >>[3]https://lwn.net/Articles/531138/ <https://lwn.net/Articles/531138/>
> >>[4]https://lkml.org/lkml/2013/6/6/462 <https://lkml.org/lkml/2013/6/6/462>&
> >>https://github.com/torvalds/linux/commit/e62e384e
> >><https://github.com/torvalds/linux/commit/e62e384e>.
> 
