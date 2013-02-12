Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab3BLKgG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:36:06 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37915 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932750Ab3BLKgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:36:05 -0500
Message-ID: <1360665361.4485.24.camel@laptop>
Subject: Re: [patch v4 09/18] sched: add sched_policies in kernel
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org
Date: Tue, 12 Feb 2013 11:36:01 +0100
In-Reply-To: <1358996820-23036-10-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
	 <1358996820-23036-10-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 11:06 +0800, Alex Shi wrote:
> Current scheduler behavior is just consider the for larger performance
> of system. So it try to spread tasks on more cpu sockets and cpu cores
> 
> To adding the consideration of power awareness, the patchset adds
> 2 kinds of scheduler policy: powersaving and balance. They will use
> runnable load util in scheduler balancing. The current scheduling is taken
> as performance policy.
> 
> performance: the current scheduling behaviour, try to spread tasks
>                 on more CPU sockets or cores. performance oriented.
> powersaving: will pack tasks into few sched group until all LCPU in the
>                 group is full, power oriented.
> balance    : will pack tasks into few sched group until group_capacity
>                 numbers CPU is full, balance between performance and
> 		powersaving.

_WHY_ do you start out with so much choice?

If your power policy is so abysmally poor on performance that you
already know you need a 3rd policy to keep people happy, maybe you're
doing something wrong?

> +#define SCHED_POLICY_PERFORMANCE	(0x1)
> +#define SCHED_POLICY_POWERSAVING	(0x2)
> +#define SCHED_POLICY_BALANCE		(0x4)
> +
> +extern int __read_mostly sched_policy;

I'd much prefer: sched_balance_policy. Scheduler policy is a concept
already well defined by posix and we don't need it to mean two
completely different things.

