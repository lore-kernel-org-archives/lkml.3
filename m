Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab3CWGor (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 02:44:47 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36056 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767Ab3CWGop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 02:44:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130322150519.GJ25978@kernel.dk>
References: <cover.1363617402.git.viresh.kumar@linaro.org>
	<9aa157216e60de7d245128d42fb896918184ae8c.1363617402.git.viresh.kumar@linaro.org>
	<20130322150519.GJ25978@kernel.dk>
Date: Sat, 23 Mar 2013 12:14:44 +0530
Message-ID: <CAKohpon7SD666o=7sH9QpOt2dbiU2Jy1OE8E__y3+=Q-o33Xnw@mail.gmail.com>
Subject: Re: [PATCH V3 6/7] block: queue work on any cpu
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: pjt@google.com, paul.mckenney@linaro.org, tglx@linutronix.de,
        tj@kernel.org, Ingo Molnar <mingo@redhat.com>, peterz@infradead.org,
        rostedt@goodmis.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind.Chauhan@arm.com,
        linux-rt-users@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 March 2013 20:35, Jens Axboe <axboe@kernel.dk> wrote:

Hi Jens,

First of all, please have a look at:

1. https://lkml.org/lkml/2013/3/18/364

This is cover-letter of my mail where i have shown power savings achieved
with this patchset.

2. https://lkml.org/lkml/2013/3/21/172

This is the link for discussion i had with Tejun which answers some of these
questions.

> What are the performance implications of this? From that perspective,
> scheduling on a local core is the better choice. Hopefully it's already
> running on the local socket of the device, keeping it on that node would
> be preferable.

If the local cpu is busy or all cpus are idle then we don't migrate, and so
for performance shouldn't be affected with it.

> For the delayed functions, the timer is typically added on the current
> CPU.

This is the code that executes here:

	if (unlikely(cpu != WORK_CPU_UNBOUND))
		add_timer_on(timer, cpu);
	else
		add_timer(timer);

Clearly for queue_delayed_work() call we don't use local cpu but we use
the same sched_select_non_idle_cpu() routine to give us the right cpu.

> It's hard to know what the state of idleness of CPUs would be when
> the delay has expired. How are you handling this?

Correct, and we are not deciding that right now, but when the timer expires.

Thanks for your feedback.
