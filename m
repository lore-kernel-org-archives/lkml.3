Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582Ab3AWQ5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 11:57:08 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:32995 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864Ab3AWQ5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 11:57:06 -0500
Date: Wed, 23 Jan 2013 08:56:57 -0800
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@google.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Message-ID: <20130123165657.GC2373@mtj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
 <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
 <50FD3123.6090003@parallels.com>
 <20130123010226.GF5359@htj.dyndns.org>
 <CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Collin.

On Tue, Jan 22, 2013 at 05:53:59PM -0800, Colin Cross wrote:
> I understand why it makes sense from a code perspective to combine cpu
> and cpuacct, but by combining them you are enforcing a strange
> requirement that to measure the cpu usage of a group of processes you

Well, "strange" is in the eyes of the beholder.  The thing is that
cgroup, as its name suggests, is a facility to control and enforce
resources to groups of tasks.  As accounting is often a part of
resource control, it happens as part of it too, but at least I think
cpuacct becoming a separate controller wasn't a technically sound
choice and intend to stop growth of usages outside resource control.

An over-arching theme of the problems in cgroup is having too much
unorganized flexibility to the extent where it impededs the original
intended goals.  The braindead hierarchy implementations make the
whole hierarchy completely meaningless.  Multiple hierarchies make it
impossible to tag and control resources in any sane way when a
resource exists across different resource and thus controller
boundaries.

So, well, that's the direction cgroup is headed.  Narrower focus on
actual resource control and actively shutting out misuses of cgroup as
generic task grouping mechanism.

> force them to be treated as a single scheduling entity by their parent
> group, effectively splitting their time as if they were a single task.
>  That doesn't make any sense to me.


> > We are not gonna break multiple hierarchies but won't go extra miles
> > to optimize or enable new features on it, so it would be best to move
> > away from it.
> 
> I don't see how I can move away from it with the current design.

What I don't get is why you don't put each applications into their
cgroups and tune their config variables, which is the intended usage
anyway.  You say that that would make the scheduler not give more cpu
time to applications with more threads, but isn't that the right thing
to do?  Why does the number of threads an application uses have any
bearing on how much CPU time it gets?  One is an implementation detail
while the other is a policy decision.  Also, if you wanna factor in
the number of threads into the policy decision for whatever reason,
you can easily do so by factoring in that number into the decision,
right?  That way, at least the decision would be explicit.

Thanks.

-- 
tejun
