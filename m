Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbaDBItQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 04:49:16 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:53483 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757528AbaDBItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 04:49:12 -0400
MIME-Version: 1.0
In-Reply-To: <20140402074322.GA22744@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<20140331071749.GA1252@gmail.com>
	<CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
	<CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
	<CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
	<CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
	<CAGdX0WE_xtUY7=CH7Qzxn9Oe8Mz=60wb6izD-APbF5d3caEthA@mail.gmail.com>
	<20140402074322.GA22744@gmail.com>
Date: Wed, 2 Apr 2014 16:49:11 +0800
Message-ID: <CAGdX0WHh3UqiCLbz+18_fj5s4PMpTfy638HA=LHpgLfVc2JpOg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/28] ktap: A lightweight dynamic tracing tool for Linux
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Alexei Starovoitov <ast@plumgrid.com>, Ingo Molnar <mingo@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>,
        Geoff Levand <geoff@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 3:43 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>
>> So based on all these input, I suggest:
>>
>> Put all these community efforts together, figure out the proper
>> design implementation of dynamic tracing tool, ktap can be a good
>> start to build upon it, evolve to a unified kernel script engine
>> with ebpf together, finally service for dynamic tracing and
>> network(if possible).
>>
>> Our goal is same and very clearly, we really want a "simple &
>> flexible & safe" dynamic scripting tracing tool for Linux, which
>> could compare or even better than Dtrace, this is the motivation of
>> ktap project.
>>
>> Two solution may be take:
>>
>> 1). upstream ktap into core trace and evolve it step by step, and
>>     finally make a integrated bytecode engine, it's a long process,
>>     but I think it's worth.
>>
>> 2). move ktap back into staging, and graduate from staging after the
>>     code make tracing people and ebpf people both happy.
>>
>> The benefit is the process will be under the eyes of community.
>>
>> Ingo, steven, Greg, what do you think?
>
> For now I'm opting for a third option:
>
>   3) Maintain my NAK on the ktap patches until they address the
>      fundamental design concerns outlined by Alexei and others in
>      their review feedback:
>
There is no fundamental design concerns outlined about ktap, that
'loop' in ktap design is not fundamental, others review feedback
is focus on patch, not fundamental design, and those "safety"
concerns raised by Alexei is just bound checking.
I don't see any others.

>      NAKed-by: Ingo Molnar <mingo@kernel.org>
>
> The thing is, I've outlined some of the concerns in my previous
> review. Not much happened on that front, for example ktap did not get
> any closer in integrating with BPF.
>
I don't see any suggestion about integrating BPF before this review cycle.

> Many months have passed since the
> previous ktap submission, still I see no progress on the 'design'
> front. That really needs to change.
>

I think the change need both in ktap and ebpf, not ktap one side,
if you really want integrate ktap and BPF is a way.

There have no proven that current ebpf low level bytecode design is suit
for generic dynamic tracing use, I also raised some design concern
about ebpf in previous mail but got no clear answer, like exposed too
much low level stuff to end user, that would be a problem because
script engine need to validate more memory references which should
not need to; and also there may be expose table lock into user inf future,
that would be more complex IMO.

The efforts need all related people participation, not only ktap,
ktap and bpf maybe need to close with each other, but not means
bpf stay and let ktap move close.

That's why I think the things would be more faster and effective if in
public place(like staging tree), otherwise the change may be hard to
happen.

Thanks.

Jovi
