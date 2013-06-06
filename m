Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3FFX2L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 19:28:11 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:52517 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3FFX2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 19:28:07 -0400
Date: Thu, 6 Jun 2013 16:28:03 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org
Subject: Re: [PATCH v7 06/11] sched: document the cpu cgroup.
Message-ID: <20130606232803.GP5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-7-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-7-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, May 29, 2013 at 03:03:17PM +0400, Glauber Costa wrote:
> The CPU cgroup is so far, undocumented. Although data exists in the
> Documentation directory about its functioning, it is usually spread,
> and/or presented in the context of something else. This file
> consolidates all cgroup-related information about it.
> 
> Signed-off-by: Glauber Costa <glommer@openvz.org>

Reviewed-by: Tejun Heo <tj@kernel.org>

Some minor points below.

> +Files
> +-----
> +
> +The CPU controller exposes the following files to the user:
> +
> + - cpu.shares: The weight of each group living in the same hierarchy, that
> + translates into the amount of CPU it is expected to get. Upon cgroup creation,
> + each group gets assigned a default of 1024. The percentage of CPU assigned to
> + the cgroup is the value of shares divided by the sum of all shares in all
> + cgroups in the same level.
> +
> + - cpu.cfs_period_us: The duration in microseconds of each scheduler period, for
> + bandwidth decisions. This defaults to 100000us or 100ms. Larger periods will
> + improve throughput at the expense of latency, since the scheduler will be able
> + to sustain a cpu-bound workload for longer. The opposite of true for smaller
                                                             ^
                                                             is?
> + periods. Note that this only affects non-RT tasks that are scheduled by the
> + CFS scheduler.
> +
> +- cpu.cfs_quota_us: The maximum time in microseconds during each cfs_period_us
> +  in for the current group will be allowed to run. For instance, if it is set to
    ^^^^^^^
    in for? doesn't parse for me.

> +  half of cpu_period_us, the cgroup will only be able to peak run for 50 % of
                                                          ^^^^^^^^^
							  to run at maximum?

> +  the time. One should note that this represents aggregate time over all CPUs
> +  in the system. Therefore, in order to allow full usage of two CPUs, for
> +  instance, one should set this value to twice the value of cfs_period_us.
> +
> +- cpu.stat: statistics about the bandwidth controls. No data will be presented
> +  if cpu.cfs_quota_us is not set. The file presents three

 Unnecessary line break?

> +  numbers:
> +	nr_periods: how many full periods have been elapsed.
> +	nr_throttled: number of times we exausted the full allowed bandwidth
> +	throttled_time: total time the tasks were not run due to being overquota
> +
> + - cpu.rt_runtime_us and cpu.rt_period_us: Those files are the RT-tasks
                                              ^^^^^
					      these

> +   analogous to the CFS files cfs_quota_us and cfs_period_us. One important
      ^^^^^^^^^^^^
      counterparts of?

> +   difference, though, is that while the cfs quotas are upper bounds that
> +   won't necessarily be met, the rt runtimes form a stricter guarantee.
                                       ^^^^^^^^^^^^^
				       runtimes are strict guarantees?

> +   Therefore, no overlap is allowed. Implications of that are that given a
                    ^^^^^^^
		 maybe overcommit is a better term?

> +   hierarchy with multiple children, the sum of all rt_runtime_us may not exceed
> +   the runtime of the parent. Also, a rt_runtime_us of 0, means that no rt tasks
                                                           ^
							   prolly unnecessary

> +   can ever be run in this cgroup. For more information about rt tasks runtime
> +   assignments, see scheduler/sched-rt-group.txt
      ^^^^^^^^^^^
      configuration?

> +
> + - cpuacct.usage: The aggregate CPU time, in nanoseconds, consumed by all tasks
> +   in this group.
> +
> + - cpuacct.usage_percpu: The CPU time, in nanoseconds, consumed by all tasks in
> +   this group, separated by CPU. The format is an space-separated array of time
> +   values, one for each present CPU.
> +
> + - cpuacct.stat: aggregate user and system time consumed by tasks in this group.
> +   The format is
> +	user: x
> +	system: y

Thanks.

-- 
tejun
