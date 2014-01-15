Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaAOKr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 05:47:29 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56441 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaAOKr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 05:47:26 -0500
MIME-Version: 1.0
In-Reply-To: <20140115103808.GY31570@twins.programming.kicks-ass.net>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115103808.GY31570@twins.programming.kicks-ass.net>
Date: Wed, 15 Jan 2014 16:17:26 +0530
Message-ID: <CAKohpomtNWZTn4zhf3og=Ff8LvBMH_68tLNgYLOyBK5Az6WXuA@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 January 2014 16:08, Peter Zijlstra <peterz@infradead.org> wrote:
> Nah, its just ugly and we should fix it. You need to be careful to not
> place tasks in a cpuset you're going to unplug though, that'll give
> funny results.

Okay. So how do you suggest to get rid of cases like a work queued
on CPU1 initially and because it gets queued again from its work handler,
it stays on the same CPU forever.

And then there were timer overflow events that occur because hrtimer
is started by tick-sched stuff for 450 seconds later in time.

--
viresh
