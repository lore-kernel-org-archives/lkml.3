Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbaAXLPW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 06:15:22 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:59403 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbaAXLPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 06:15:20 -0500
Date: Fri, 24 Jan 2014 03:15:11 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>
cc: Li Zefan <lizefan@huawei.com>, Viresh Kumar <viresh.kumar@linaro.org>,
        mingo@kernel.org, peterz@infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cpusets: Allocate heap only when required
In-Reply-To: <20140124105952.GD4101@htj.dyndns.org>
Message-ID: <alpine.DEB.2.02.1401240300570.24372@chino.kir.corp.google.com>
References: <8622e93b9c49c66ffdc9ef0aa8371c322718edd5.1390475530.git.viresh.kumar@linaro.org> <alpine.DEB.2.02.1401231330530.7313@chino.kir.corp.google.com> <52E1C8BD.2010500@huawei.com> <alpine.DEB.2.02.1401240230190.9846@chino.kir.corp.google.com>
 <20140124103631.GB4101@htj.dyndns.org> <alpine.DEB.2.02.1401240243260.24372@chino.kir.corp.google.com> <20140124105952.GD4101@htj.dyndns.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014, Tejun Heo wrote:

> > Nobody is depending on shit, the patch is removing a completely pointless 
> > memory allocation in braindead cpuset code.  What you think is "harmful" 
> > or "more harmful" is irrelevant, but nobody said anything about depending 
> > on that behavior to do anything.
> 
> Weren't you talking something of that effect in memcg?  Or was it
> Michal?

In a completely different thread, I was talking about how we'd like to 
provide a small amount of memory in oom conditions so that you could do 
things like read the cgroup tasks file, but you'd also need the same thing 
to do just about anything, ls, ps, read /proc/pid/status, etc with true 
slab accounting.  Forget about this unnecessary heap allocation, you 
couldn't even do the open() in an oom condition.

That functionality would be provided by the memory reserves set aside for 
userspace oom handlers as part of that feature, cgroups wouldn't be 
different than anything else in that regard, it's a memcg and page 
allocator issue only.

> At any rate, I think you're missing the point why Li replied
> that it's harmless.  He, I think, meant that it doesn't make any
> semantical difference to userland, so your reply saying that it's not
> harmless listing the failure mode under memory pressure seemed
> misleading, so I thought clarification was necessary.

I would consider any memory allocation that is completely unnecessary to 
cause anything to fail unnecessarily to be harmful, nothing specific here 
about update_flag(), cpusets, or cgroups.  Saying something is "harmless" 
makes it sound like there's no downside to doing it, and that's obviously 
not the case.

We agree and I think the only outcome of this discussion is that we both 
wasted time :)
