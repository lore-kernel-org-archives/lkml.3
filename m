Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab3BLKj4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:39:56 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39104 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932696Ab3BLKjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:39:55 -0500
Message-ID: <1360665592.4485.26.camel@laptop>
Subject: Re: [patch v4 11/18] sched: log the cpu utilization at rq
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:39:52 +0100
In-Reply-To: <1358996820-23036-12-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-12-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> 
> The cpu's utilization is to measure how busy is the cpu.
>         util = cpu_rq(cpu)->avg.runnable_avg_sum
>                 / cpu_rq(cpu)->avg.runnable_avg_period;
> 
> Since the util is no more than 1, we use its percentage value in later
> caculations. And set the the FULL_UTIL as 100%.
> 
> In later power aware scheduling, we are sensitive for how busy of the
> cpu, not how much weight of its load. As to power consuming, it is more
> related with cpu busy time, not the load weight.

I think we can make that argument in general; that is irrespective of
the actual policy. We simply never had anything better to go with.

So please clarify why you think this only applies to power aware
scheduling.

