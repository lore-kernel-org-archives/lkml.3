Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754774AbaJIIdI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 04:33:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:38327 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaJIIdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 04:33:04 -0400
Date: Thu, 9 Oct 2014 10:32:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: lizefan@huawei.com, anton@samba.org, tj@kernel.org,
        svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Message-ID: <20141009083259.GQ10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54364564.3090305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> >> SMT 8 on Power8 can help/hinder workloads. Hence we dynamically switch
> >> the modes at runtime.
> > 
> > That's just a horrible piece of crap hack and you deserve any and all
> > pain you get from doing it.
> > 
> > Randomly removing/adding cpus like that is horrible and makes a mockery
> > of all the affinity interfaces we have.
> 
> We observed this on ubuntu kernel, in which systemd explicitly mounts
> cgroup controllers under a child cgroup identified by the user pid.
> Since we had not observed this additional cgroup being added under the
> hood, it came as a surprise to us that cgroup/cpuset handling in the
> kernel should indeed kick in.
> 
> At best we expect hotplug to be handled well if the users have not
> explicitly configured cpusets, hence implicitly specifying that task
> affinity is for all online cpus. This is indeed the case today, so that
> is good.
> 
> However what remains to be answered is that the V2 of cgroup design -
> the default hierarchy, tracks hotplug operations for children cgroups as
> well. Tejun, Li, will not the concerns that Peter raised above hold for
> the default hierarchy as well?

None of this addresses the piece of crap thing you did with power8. You
cannot just make CPUs go away at random.
