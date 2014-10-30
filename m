Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbaJ3Mno (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:43:44 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:35812 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760018AbaJ3Mnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:43:39 -0400
Date: Thu, 30 Oct 2014 08:43:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        "Auld, Will" <will.auld@intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: Cache Allocation Technology Design
Message-ID: <20141030124333.GA29540@htj.dyndns.org>
References: <20141024105306.GI12706@worktop.programming.kicks-ass.net>
 <20141028232215.GO12020@console-pimps.org>
 <20141029081640.GT3337@twins.programming.kicks-ass.net>
 <20141029124834.GQ12020@console-pimps.org>
 <20141029134526.GC3337@twins.programming.kicks-ass.net>
 <96EC5A4F3149B74492D2D9B9B1602C27349EEB88@ORSMSX105.amr.corp.intel.com>
 <20141029172845.GP12706@worktop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1410291036070.26215@vshiva-Udesk>
 <20141029182234.GA13393@mtj.dyndns.org>
 <20141030070725.GG3337@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141030070725.GG3337@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Peter.

On Thu, Oct 30, 2014 at 08:07:25AM +0100, Peter Zijlstra wrote:
> If this means echo $tid > tasks, then sorry we can't do. There is a
> limited number of hardware resources backing this thing. At some point
> they're consumed and something must give.

And that something shouldn't be disallowing task migration across
cgroups.  This simply doesn't work with co-mounting or unified
hierarchy.  cpuset automatically takes on the nearest ancestor's
configuration which has enough execution resources.  Maybe that can be
an option for this too?

One of the problems is that we generally assume that a task can run
some point in time in a lot of places in the kernel and can't just not
run a task indefinitely because it's in a cgroup configured certain
way.

> So either we fail mkdir, but that means allocating CLOS IDs for possibly
> empty cgroups, or we allocate on demand which means failing task
> assignment.

Can't fail mkdir or css enabling either.  Again, co-mounting and
unified hierarchy.  Also, the behavior is just horrible to use from
userland.

> The same -- albeit for a different reason -- is true of the RT sched
> groups, we simply cannot instantiate them such that tasks can join,
> sysads _have_ to configure them before we can add tasks to them.

Yeah, RT is one of the main items which is problematic, more so
because it's currently coupled with the normal sched controller and
the default config doesn't have any RT slice.  Do we completely block
RT task w/o slice?  Is that okay?

Thanks.

-- 
tejun
