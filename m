Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab3LEFLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 00:11:41 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:62439 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab3LEFLk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 00:11:40 -0500
MIME-Version: 1.0
In-Reply-To: <529FC352.7090004@hitachi.com>
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-5-git-send-email-ast@plumgrid.com>
	<529E7BEC.70509@hitachi.com>
	<20131203201133.52934a02@gandalf.local.home>
	<529FC352.7090004@hitachi.com>
Date: Wed, 4 Dec 2013 21:11:39 -0800
Message-ID: <CAMEtUuwMv6PtN=9_RmxouZpVB8PVN8oZDNDUyLva2J+xos48og@mail.gmail.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
From: Alexei Starovoitov <ast@plumgrid.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 4, 2013 at 4:05 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/12/04 10:11), Steven Rostedt wrote:
>> On Wed, 04 Dec 2013 09:48:44 +0900
>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>
>>> fetch functions and actions. In that case, we can continue
>>> to use current interface but much faster to trace.
>>> Also, we can see what filter/arguments/actions are set
>>> on each event.
>>
>> There's also the problem that the current filters work with the results
>> of what is written to the buffer, not what is passed in by the trace
>> point, as that isn't even displayed to the user.
>
> Agreed, so I've said I doubt this implementation is a good
> shape to integrate. Ktap style is better, since it just gets
> parameters from perf buffer entry (using event format).

Are you saying always store all arguments into ring buffer and let
filter run on it?
It's slower, but it's cleaner, because of human readable? since ktap
arg1 matches first
argument of tracepoint is better than doing ctx->regs.di ? Sure.
si->arg1 is easy to fix.
With si->arg1 tweak the bpf will become architecture independent. It
will run through JIT on x86 and through interpreter everywhere else.
but for kprobes user have to specify 'var=cpu_register' during probe
creation… how is it better than doing the same in filter?
I'm open to suggestions on how to improve the usability.

Thanks
Alexei
