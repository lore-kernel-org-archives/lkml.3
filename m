Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422721AbaJ3XTe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 19:19:34 -0400
Received: from mga01.intel.com ([192.55.52.88]:1229 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161351AbaJ3XTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 19:19:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="408780342"
Date: Thu, 30 Oct 2014 16:18:33 -0700 (PDT)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Tejun Heo <tj@kernel.org>
cc: Peter Zijlstra <peterz@infradead.org>,
        Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>, h.peter.anvin@intel.com
Subject: Re: Cache Allocation Technology Design
In-Reply-To: <20141030124333.GA29540@htj.dyndns.org>
Message-ID: <alpine.DEB.2.10.1410301610000.27874@vshiva-Udesk>
References: <20141024105306.GI12706@worktop.programming.kicks-ass.net> <20141028232215.GO12020@console-pimps.org> <20141029081640.GT3337@twins.programming.kicks-ass.net> <20141029124834.GQ12020@console-pimps.org> <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com> <20141029172845.GP12706@worktop.programming.kicks-ass.net> <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk> <20141029182234.GA13393@mtj.dyndns.org> <20141030070725.GG3337@twins.programming.kicks-ass.net>
 <20141030124333.GA29540@htj.dyndns.org>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Thu, 30 Oct 2014, Tejun Heo wrote:

> Hello, Peter.
>
> On Thu, Oct 30, 2014 at 08:07:25AM +0100, Peter Zijlstra wrote:
>> If this means echo $tid > tasks, then sorry we can't do. There is a
>> limited number of hardware resources backing this thing. At some point
>> they're consumed and something must give.
>
> And that something shouldn't be disallowing task migration across
> cgroups.  This simply doesn't work with co-mounting or unified
> hierarchy.  cpuset automatically takes on the nearest ancestor's
> configuration which has enough execution resources.  Maybe that can be
> an option for this too?


One way to it is to merge the CAT cgroups into the cpuset . In essense 
there is no CAT cgroup seperately and we just have a new file 'cbm' in the 
cpuset. This would be visible only when system has Cache allocation 
support and the user can manipulate the cache bit mask here.
The  user can use the already existing cpu_exclusive file in the cpuset 
to mark the cgroups to use exclusive CPUs.
That way we simplify and reuse cpuset code/hierarchy .. ?

Thanks,
Vikas



>
> One of the problems is that we generally assume that a task can run
> some point in time in a lot of places in the kernel and can't just not
> run a task indefinitely because it's in a cgroup configured certain
> way.
>
>> So either we fail mkdir, but that means allocating CLOS IDs for possibly
>> empty cgroups, or we allocate on demand which means failing task
>> assignment.
>
> Can't fail mkdir or css enabling either.  Again, co-mounting and
> unified hierarchy.  Also, the behavior is just horrible to use from
> userland.
>
>> The same -- albeit for a different reason -- is true of the RT sched
>> groups, we simply cannot instantiate them such that tasks can join,
>> sysads _have_ to configure them before we can add tasks to them.
>
> Yeah, RT is one of the main items which is problematic, more so
> because it's currently coupled with the normal sched controller and
> the default config doesn't have any RT slice.  Do we completely block
> RT task w/o slice?  Is that okay?
>
> Thanks.
>
> -- 
> tejun
>
