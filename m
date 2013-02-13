Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3BMSnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 13:43:16 -0500
Received: from merlin.infradead.org ([205.233.59.134]:39567 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754236Ab3BMSnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 13:43:15 -0500
Message-ID: <1360780981.8957.3.camel@laptop>
Subject: Re: [PATCH 2/3] sched: Move idle_balance() to post_schedule
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Wed, 13 Feb 2013 19:43:01 +0100
In-Reply-To: <20130212230017.625583020@goodmis.org>
References: <20130212225412.781044738@goodmis.org>
	 <20130212230017.625583020@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 17:54 -0500, Steven Rostedt wrote:
> There's no real reason that the idle_balance() needs to be called in
> the
> middle of schedule anyway. The only benefit is that if a task is
> pulled
> to this CPU, it can be scheduled without the need to schedule the idle
> task. 

Uhm, istr that extra schedule being an issue somewhere.. Make very sure
you don't regress anything silly like sysbench or hackbench. Maybe ask
Mike, he seems to have a better retention for benchmark weirdness than
me.

> But load balancing and migrating the task makes a switch to idle
> and back negligible.

How does that follow? We can have to-idle switches _far_ more often than
we balance.

