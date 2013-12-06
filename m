Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab3LFEt5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 23:49:57 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:36229 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab3LFEty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 23:49:54 -0500
MIME-Version: 1.0
In-Reply-To: <20131205183735.5f9c8bae@gandalf.local.home>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131205104113.GB20283@gmail.com>
	<20131205084657.09b6a2ce@gandalf.local.home>
	<CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com>
	<20131205183735.5f9c8bae@gandalf.local.home>
Date: Thu, 5 Dec 2013 20:49:53 -0800
Message-ID: <CAMEtUuzkGNbh_ZOd5SbWEdNMz3NEpDZzzAKP=Ov10DKD5hVaKQ@mail.gmail.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 3:37 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Thu, 5 Dec 2013 14:36:58 -0800
> Alexei Starovoitov <ast@plumgrid.com> wrote:
>
>> On Thu, Dec 5, 2013 at 5:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
>> >
>> > I know that it would be great to have the bpf filter run before
>> > recording of the tracepoint, but as that becomes quite awkward for a
>> > user interface, because it requires intimate knowledge of the kernel
>> > source, this speed up on the filter itself may be worth while to have
>> > it happen after the recording of the buffer. When it happens after the
>> > record, then the bpf has direct access to the event entry and its
>> > fields as described by the trace event format files.
>>
>> I don't understand that 'awkward' part yet. What do you mean by 'knowledge of
>> the kernel'? By accessing pt_regs structure? Something else ?
>> Can we try fixing the interface first before compromising on performance?
>
> Let me ask you this. If you do not have the source of the kernel on
> hand, can you use BPF to filter the sched_switch tracepoint on prev pid?
>
> The current filter interface allows you to filter with just what the
> running kernel provides. No need for debug info from the vmlinux or
> anything else.

Understood and agreed. For the users that are satisfied with amount of info
that single trace_event provides (like sched_switch) there is probably
little reason to do complex filtering. Either they're fine with all
the events or will
just filter based on pid only.

> I'm fine if it becomes a requirement to have a vmlinux built with
> DEBUG_INFO to use BPF and have a tool like perf to translate the
> filters. But it that must not replace what the current filters do now.
> That is, it can be an add on, but not a replacement.

Of course. tracing filters via bpf is an additional tool for kernel debugging.
bpf by itself has use cases beyond tracing.
