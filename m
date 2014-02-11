Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017AbaBKPqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 10:46:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:58913 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaBKPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 10:46:19 -0500
Date: Tue, 11 Feb 2014 16:46:14 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>
Subject: Re: [PATCH] sched/fair: Remove idle_balance() declaration in sched.h
Message-ID: <20140211154614.GQ27965@twins.programming.kicks-ass.net>
References: <1392130864-4416-1-git-send-email-daniel.lezcano@linaro.org>
 <20140211151148.GP27965@twins.programming.kicks-ass.net>
 <52FA42D4.9050401@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52FA42D4.9050401@linaro.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 04:33:40PM +0100, Daniel Lezcano wrote:
> On 02/11/2014 04:11 PM, Peter Zijlstra wrote:
> >On Tue, Feb 11, 2014 at 04:01:04PM +0100, Daniel Lezcano wrote:
> >>The idle_balance() function is called within a #ifdef CONFIG_SMP section.
> >>
> >>Remove its declaration in sched.h for !CONFIG_SMP because it is pointless.
> >>
> >>Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> >
> >The below again makes a horrible mess of idle_balance() -- which you
> >tried to clean up.. but it does rid us of some #ifdef goo.
> >
> >Hmmm?
> 
> Yes, it sounds ok.
> 
> Why is idle_enter_fair() called unconditionally in idle_balance() ?
> Isn't the call in pick_next_task_idle enough ?  Shouldn't be called when we
> will go to idle effectively ?
> 
> If I am not wrong idle_enter_fair() is called from idle_balance() but a task
> may be pulled, so we the next task won't be the idle task and idle_exit_fair
> won't be called at put_prev_task.
> 
> May be I missed this change which was done at purpose in the previous
> patchset you sent...

lkml.kernel.org/r/CAKfTPtAMmhq0tBpu+pk_uzwrfUM-6Fz4Do1yrzc4NRQS4cZ_-A@mail.gmail.com

I seem to be terminally confused on the subject, but Vincent explains it
there I think.
