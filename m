Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665Ab3LEXhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:37:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:32369 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754679Ab3LEXhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:37:38 -0500
Date: Thu, 5 Dec 2013 18:37:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
Message-ID: <20131205183735.5f9c8bae@gandalf.local.home>
In-Reply-To: <CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<87fvq9cwlk.fsf@tassilo.jf.intel.com>
	<CAMEtUuzweYxqwoaYH+J5a2uRM+PFcBH+Pb8Z_ALPUMp+QFz1tQ@mail.gmail.com>
	<CAMEtUuzWLcTOeQSrhEQHVn7DbuoJn7bNek9-toQ9xZYzya3-ag@mail.gmail.com>
	<20131205104113.GB20283@gmail.com>
	<20131205084657.09b6a2ce@gandalf.local.home>
	<CAMEtUuyp0q9YSMq7OchEeWLz9oPYd3qQ+0SDV5Pt8F10KLbFpg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Dec 2013 14:36:58 -0800
Alexei Starovoitov <ast@plumgrid.com> wrote:

> On Thu, Dec 5, 2013 at 5:46 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I know that it would be great to have the bpf filter run before
> > recording of the tracepoint, but as that becomes quite awkward for a
> > user interface, because it requires intimate knowledge of the kernel
> > source, this speed up on the filter itself may be worth while to have
> > it happen after the recording of the buffer. When it happens after the
> > record, then the bpf has direct access to the event entry and its
> > fields as described by the trace event format files.
> 
> I don't understand that 'awkward' part yet. What do you mean by 'knowledge of
> the kernel'? By accessing pt_regs structure? Something else ?
> Can we try fixing the interface first before compromising on performance?

Let me ask you this. If you do not have the source of the kernel on
hand, can you use BPF to filter the sched_switch tracepoint on prev pid?

The current filter interface allows you to filter with just what the
running kernel provides. No need for debug info from the vmlinux or
anything else.

pt_regs is not that useful without having something to translate what
that means.

I'm fine if it becomes a requirement to have a vmlinux built with
DEBUG_INFO to use BPF and have a tool like perf to translate the
filters. But it that must not replace what the current filters do now.
That is, it can be an add on, but not a replacement.

 -- Steve
