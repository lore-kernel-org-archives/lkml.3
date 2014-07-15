Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaGOJVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:21:49 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:40955 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaGOJVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:21:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140714135106.GZ19379@twins.programming.kicks-ass.net>
References: <1404144343-18720-1-git-send-email-vincent.guittot@linaro.org>
 <1404144343-18720-9-git-send-email-vincent.guittot@linaro.org>
 <20140710111833.GY3935@laptop> <CAKfTPtD=TiURcppZ+oVUmhMf6Ofxbp4BPA0SCFViu0SDb05oRw@mail.gmail.com>
 <20140711145138.GC3935@laptop> <CAKfTPtCdd6uR_qBuW2W4asMgEV=OfsNvrOCVQCci+w3C8RAoCQ@mail.gmail.com>
 <20140714135106.GZ19379@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 15 Jul 2014 11:21:24 +0200
Message-ID: <CAKfTPtCoBpt5aOe9z2LjvOZBsiNnnC5wCFRyyOS_RPoqshJCxw@mail.gmail.com>
Subject: Re: [PATCH v3 08/12] sched: move cfs task on a CPU with higher capacity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 July 2014 15:51, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Jul 11, 2014 at 05:17:44PM +0200, Vincent Guittot wrote:
>> > In any case, its feels rather arbitrary to me. What about machines where
>> > there's no cache sharing at all (the traditional SMP systems). This
>> > thing you're trying to do still seems to make sense there.
>>
>> ok, I thought that traditional SMP systems have this flag set at core
>> level.
>
> Yeah, with 1 core, so its effectively disabled.
>
>> I mean ARM platforms have the flag for CPUs in the same cluster
>> (which include current ARM SMP system) and the corei7 of my laptop has
>> the flag at the cores level.
>
> So I can see 'small' parts reducing shared caches in order to improve
> idle performance.
>
> The point being that LLC seems a somewhat arbitrary measure for this.
>
> Can we try and see what happens if you remove the limit. Its always best
> to try the simpler things first and only make it more complex if we have
> to.

ok. i will remove the condition in the next version
