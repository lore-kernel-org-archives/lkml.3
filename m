Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbaJINsK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:48:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:40183 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaJINsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:48:03 -0400
Date: Thu, 9 Oct 2014 15:47:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>, lizefan@huawei.com,
        anton@samba.org, svaidy@linux.vnet.ibm.com, rjw@rjwysocki.net,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cpusets: Make cpus_allowed and mems_allowed masks
 hotplug invariant
Message-ID: <20141009134758.GU10832@worktop.programming.kicks-ass.net>
References: <20141008070739.1170.33313.stgit@preeti.in.ibm.com>
 <20141008080706.GC10832@worktop.programming.kicks-ass.net>
 <543505EF.7070804@linux.vnet.ibm.com>
 <20141008101828.GG10832@worktop.programming.kicks-ass.net>
 <54364564.3090305@linux.vnet.ibm.com>
 <20141009130611.GA14387@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009130611.GA14387@htj.dyndns.org>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 09:06:11AM -0400, Tejun Heo wrote:
> On Thu, Oct 09, 2014 at 01:50:52PM +0530, Preeti U Murthy wrote:
> > However what remains to be answered is that the V2 of cgroup design -
> > the default hierarchy, tracks hotplug operations for children cgroups as
> > well. Tejun, Li, will not the concerns that Peter raised above hold for
> > the default hierarchy as well?
> 
> I don't think the legacy one is a good design.  Kernel shouldn't lose
> configurations in an irreversible way and the legacy one is also
> making random cpuset flips by migrating tasks upwards anyway. 

You do know we disagree on this :-)

The thing is, if you restrict a process to one cpu and then take that
cpu away you have a fail, pretending its 'OK' because you'll place it
back once the cpu appears again doesn't make it right.

And while legacy will indeed move tasks upwards, it does so under
protest, its a clear error and the user needs to go figure out wtf to do
about it.

And while you all can try and pretend hotplug is a 'normal' and 'sane'
operation with cpusets, the same failure more very much still exists
with the regular affinity controls. So you can pretend all you want, but
its a clear and utter fail.

You cannot give the kernel contradictory instructions and then pretend
all is well and dandy.
