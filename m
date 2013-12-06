Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab3LFFqm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 00:46:42 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39349 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab3LFFqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 00:46:39 -0500
MIME-Version: 1.0
In-Reply-To: <871u1qwzae.fsf@tassilo.jf.intel.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131206001454.GB21717@two.firstfloor.org>
	<52A12421.2040208@zytor.com>
	<871u1qwzae.fsf@tassilo.jf.intel.com>
Date: Fri, 6 Dec 2013 13:46:38 +0800
Message-ID: <CAGdX0WF89qDz84uoDYzFmi_k-NVofUm-6wUbGa0aPh4-jx8Umg@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alexei Starovoitov <ast@plumgrid.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 6, 2013 at 9:20 AM, Andi Kleen <andi@firstfloor.org> wrote:
> "H. Peter Anvin" <hpa@zytor.com> writes:
>>
>> Not to mention that in that case we might as well -- since we need a
>> compiler anyway -- generate the machine code in user space; the JIT
>> solution really only is useful if it can provide something that we can't
>> do otherwise, e.g. enable it in secure boot environments.
>
> I can see there may be some setups which don't have a compiler
> (e.g. I know some people don't use systemtap because of that)
> But this needs a custom gcc install too as far as I understand.
>
If it's depend on gcc, then it's look like Systemtap. There have big
inconvenient for embedded environment and many production system
to install gcc.
(not sure if it need kernel compilation environment as well)

It seems the event filter is binding to specific event, it's not possible
to trace many events in a cooperation style, look Systemtap and ktap
samples, many event handler need to cooperate, the simplest
example is record syscall execution time(duration of exit - entry).

If this design is intentional, then I would think it's target for speed up
current kernel tracing filter.(but need extra usespace filter compiler)

And I guess bpf filter still need to take mind on usespace tracing :),
if it want to be a complete and integrated tracing solution.
(use a separated userspace compiler or translator to resolve symbol)

Thanks

Jovi
