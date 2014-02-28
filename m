Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751741AbaB1JEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 04:04:50 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:45217 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaB1JEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 04:04:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140115113406.GC31570@twins.programming.kicks-ass.net>
References: <CAKohpomO+2WbNLceBznWwYRcv0e7RsPiaRF7ctRZ+6GFKtr4aA@mail.gmail.com>
	<20140115103808.GY31570@twins.programming.kicks-ass.net>
	<CAKohpomtNWZTn4zhf3og=Ff8LvBMH_68tLNgYLOyBK5Az6WXuA@mail.gmail.com>
	<20140115113406.GC31570@twins.programming.kicks-ass.net>
Date: Fri, 28 Feb 2014 14:34:42 +0530
Message-ID: <CAKohpo=_5RUZGQKaS2-oLqOxF2BspD0TA8PE1jbsF=CGB8umLA@mail.gmail.com>
Subject: Re: [QUERY]: Is using CPU hotplug right for isolating CPUs?
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
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

On 15 January 2014 17:04, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Jan 15, 2014 at 04:17:26PM +0530, Viresh Kumar wrote:
>> On 15 January 2014 16:08, Peter Zijlstra <peterz@infradead.org> wrote:
>> > Nah, its just ugly and we should fix it. You need to be careful to not
>> > place tasks in a cpuset you're going to unplug though, that'll give
>> > funny results.
>>
>> Okay. So how do you suggest to get rid of cases like a work queued
>> on CPU1 initially and because it gets queued again from its work handler,
>> it stays on the same CPU forever.
>
> We should have a cpuset.quiesce control or something that moves all
> timers out.

What should we do here if we have a valid base->running_timer for the
cpu requesting the quiesce ?
