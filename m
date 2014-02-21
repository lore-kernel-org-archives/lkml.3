Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaBUMo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:44:26 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:43524 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086AbaBUMoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:44:24 -0500
Date: Fri, 21 Feb 2014 13:44:38 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: Kirill Tkhai <tkhai@yandex.ru>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
Message-Id: <20140221134438.ab2d02c4165fa2a6cbd663be@gmail.com>
In-Reply-To: <311621392984565@web3h.yandex.ru>
References: <230991392848160@web13m.yandex.ru>
	<20140221103715.GP9987@twins.programming.kicks-ass.net>
	<128831392982418@web15j.yandex.ru>
	<311621392984565@web3h.yandex.ru>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Feb 2014 16:09:25 +0400
Kirill Tkhai <tkhai@yandex.ru> wrote:

> 
> 
> 21.02.2014, 15:39, "Kirill Tkhai" <tkhai@yandex.ru>:
> > 21.02.2014, 14:37, "Peter Zijlstra" <peterz@infradead.org>:
> >
> >>  On Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
> >>>   Since deadline tasks share rt bandwidth, we must care about
> >>>   bandwidth timer set. Otherwise rt_time may grow up to infinity
> >>>   in update_curr_dl(), if there are no other available RT tasks
> >>>   on top level bandwidth.
> >>>
> >>>   I'm going to decide the problem the way below. Almost untested
> >>>   because of I skipped almost all of recent patches which haveto be applied from lkml.
> >>>
> >>>   Please say, if I skipped anything in idea. Maybe better put
> >>>   start_top_rt_bandwidth() into set_curr_task_dl()?
> >>  How about we only increment rt_time when there's an RT bandwidth timer
> >>  active?
> >
> > This case RT and DL may eat all the time:
> >
> > --------------  time ------------------>
> > |RT's working |DL's working|
> > ----------------------------
> > |rt_runtime   |            |
> > ----------------------------
> > |        rt_period         |
> >
> > Or at least more, than it's allowed.
> >
> > It looks like, if we want to limit time of high priority classes
> > execution, we have to set the timer anyway.
> 
> Oh, above is confusing. Sorry.
> 
> I mean one RT task and
> 
> -----------------  time -------------------------->
> |DL's working    |RT's working| |DL's working    |
> --------------------------------------------------
> |                |rt_runtime  | |                |
> --------------------------------------------------
> |                |   rt_period  |                |
> 
> In this case FAIR receives less ratio, than (rt_period-rt_runtime)/rt_period.
> 

DL tasks won't be allowed to run in this situation, as their bw exceedes
rt_runtime/rt_period.

Thanks,

- Juri
