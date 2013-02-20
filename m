Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934269Ab3BTJh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 04:37:58 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:56238 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932714Ab3BTJh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 04:37:56 -0500
Date: Wed, 20 Feb 2013 10:37:51 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Subject: Re: [patch v5 04/15] sched: add sched balance policies in kernel
Message-ID: <20130220093751.GA2444@gmail.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
 <1361164062-20111-5-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1361164062-20111-5-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> Current scheduler behavior is just consider for larger 
> performance of system. So it try to spread tasks on more cpu 
> sockets and cpu cores
> 
> To adding the consideration of power awareness, the patchset 
> adds 2 kinds of scheduler policy: powersaving and balance. 
> They will use runnable load util in scheduler balancing. The 
> current scheduling is taken as performance policy.
> 
> performance: the current scheduling behaviour, try to spread tasks
>                 on more CPU sockets or cores. performance oriented.
> powersaving: will pack tasks into few sched group until all LCPU in the
>                 group is full, power oriented.
> balance    : will pack tasks into few sched group until group_capacity
>                 numbers CPU is full, balance between performance and
> 		powersaving.

Hm, so in a previous review I suggested keeping two main 
policies: power-saving and performance, plus a third, default 
policy, which automatically switches between these two if/when 
the kernel has information about whether a system is on battery 
or on AC - and picking 'performance' when it has no information.

Such an automatic policy would obviously be useful to users - 
and that is what makes such a feature really interesting and a 
step forward.

I think Peter expressed similar views: we don't want many knobs 
and states, we want two major goals plus an (optional but 
default enabled) automatism.

Is your 'balance' policy implementing that suggestion?
If not, why not?

Thanks,

	Ingo
