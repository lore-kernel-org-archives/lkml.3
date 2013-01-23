Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752580Ab3AWXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 18:06:21 -0500
Received: from mail-qa0-f45.google.com ([209.85.216.45]:53157 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3AWXGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 18:06:14 -0500
Date: Wed, 23 Jan 2013 15:06:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Colin Cross <ccross@google.com>
Cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Message-ID: <20130123230608.GJ2373@mtj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
 <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
 <50FD3123.6090003@parallels.com>
 <20130123010226.GF5359@htj.dyndns.org>
 <CAMbhsRSDbKUz7OT3Y0bGfYqgp3yMgwk8oHx0rpsX+XDFWTMqkw@mail.gmail.com>
 <20130123165657.GC2373@mtj.dyndns.org>
 <CAMbhsRRj9svWubn01wb+f=jSwVWC5u7DqJ5c8P23vAp0E2L8Rg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMbhsRRj9svWubn01wb+f=jSwVWC5u7DqJ5c8P23vAp0E2L8Rg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Collin.

On Wed, Jan 23, 2013 at 02:41:46PM -0800, Colin Cross wrote:
> I think some of it is just historic, we previously did not group
> application threads in the scheduler, so it would cause a change in
> behavior if we started grouping them.  I will investigate switching to
> a co-mounted hierarchy so hopefully you can deprecate cpuacct in the
> future.

Yeah, it's gonna be many years, if ever, before we can actually
deprecate cpuacct and multiple hierarchies but it would be really nice
to move at least popular uses away from them sooner than later.

Also, maybe I'm misunderstanding what you were saying but isn't it the
case that only single application is "foreground" in at least vanilla
android?  Maybe multi-window support is scheduled for future releases
but it wouldn't count as behavior change in that case, right?

At any rate, IMHO, it's simply the better and correct to not depend on
the number of threads in use as a measure of CPU resource
distribution.

> We can't factor the number of threads into the policy decision,
> because it depends on how many threads are runnable at any time in any
> particular application, and we have no way to track that.  It would
> have to be a cgroup scheduler feature.

My understanding of android is very limited but the number of threads
in dalvik apps are controlled by the base system rather than
application itself, no?  If so, factoring that into scheduling params
shouldn't be difficult.  For native processes, if the number of
threads just *have* to be factored in some way, we can resort to
sampling.  That said, as native apps can easily thread-bomb out of
fairness, there are way more reasons to avoid basing the resource
policy decision on the number of threads in use.

Thanks.

-- 
tejun
