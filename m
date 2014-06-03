Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933550AbaFCSoc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:44:32 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:60070 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaFCSob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140603182850.GJ16155@laptop.programming.kicks-ass.net>
References: <20140522130931.GV13658@twins.programming.kicks-ass.net>
 <CALCETrVBVOjs0EVqEz3qKtSHQg1agJzAyG4Ohqueky-zPF7uKA@mail.gmail.com>
 <20140529064827.GI19143@laptop.programming.kicks-ass.net> <CALCETrWnG7fSuinDv+GAHsnTLJ-6xn+_1LB2XdLGVXcC=TQURA@mail.gmail.com>
 <20140603104347.GT11096@twins.programming.kicks-ass.net> <20140603140223.GA13658@twins.programming.kicks-ass.net>
 <CALCETrW3cr_RLnMeMtutM5H+3cJSerUxXuEmiT9miDOEmkpANw@mail.gmail.com>
 <20140603161950.GB30445@twins.programming.kicks-ass.net> <CALCETrWOrYTK01ev34mP+5iyeBWw14u+3n4fg0+O5Zp9oPQ+3g@mail.gmail.com>
 <20140603170018.GD30445@twins.programming.kicks-ass.net> <20140603182850.GJ16155@laptop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Jun 2014 11:44:10 -0700
Message-ID: <CALCETrVGGSv51NxMXaD-=9ukkYLTT7DrLTscgA0pa0+PkUYw3Q@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/8] sched,idle: need resched polling rework
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        nicolas.pitre@linaro.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 11:28 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Jun 03, 2014 at 07:00:18PM +0200, Peter Zijlstra wrote:
>> On Tue, Jun 03, 2014 at 09:52:22AM -0700, Andy Lutomirski wrote:
>> > > So you could cheat and set it in pick_next_task_idle() and clear in
>> > > put_prev_task_idle(), that way the entire idle loop, when running has it
>> > > set.
>> > >
>> >
>> > Isn't that a little late for sched_ttwu_pending?  I guess it could be
>> > okay, but I'm hesitant to muck around with the scheduler innards that
>> > much.  I don't see anything that'll break, though.
>>
>> Yeah, only later did I see you clear much earlier, which makes sense.
>
> Could we clear it from set_nr_and_not_polling()/set_nr_if_polling()?
> That's the only two functions that'll kick a cpu out of its polling
> loop, and we're already writing to the word anyhow.

I'd be nervous about this.  I think it could break if
cpuidle_idle_call decides not to idle for any reason, and there is
plenty of complicated code in there.

I'm currently working on some patches that might make this clearer.
Give me a bit.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
