Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3LFInz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 03:43:55 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:38426 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab3LFInw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 03:43:52 -0500
Message-ID: <52A18E31.6030605@hitachi.com>
Date: Fri, 06 Dec 2013 17:43:29 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com> <1386044930-15149-5-git-send-email-ast@plumgrid.com> <529E7BEC.70509@hitachi.com> <20131203201133.52934a02@gandalf.local.home> <529FC352.7090004@hitachi.com> <CAMEtUuwMv6PtN=9_RmxouZpVB8PVN8oZDNDUyLva2J+xos48og@mail.gmail.com>
In-Reply-To: <CAMEtUuwMv6PtN=9_RmxouZpVB8PVN8oZDNDUyLva2J+xos48og@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/12/05 14:11), Alexei Starovoitov wrote:
> On Wed, Dec 4, 2013 at 4:05 PM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> (2013/12/04 10:11), Steven Rostedt wrote:
>>> On Wed, 04 Dec 2013 09:48:44 +0900
>>> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>> fetch functions and actions. In that case, we can continue
>>>> to use current interface but much faster to trace.
>>>> Also, we can see what filter/arguments/actions are set
>>>> on each event.
>>>
>>> There's also the problem that the current filters work with the results
>>> of what is written to the buffer, not what is passed in by the trace
>>> point, as that isn't even displayed to the user.
>>
>> Agreed, so I've said I doubt this implementation is a good
>> shape to integrate. Ktap style is better, since it just gets
>> parameters from perf buffer entry (using event format).
> 
> Are you saying always store all arguments into ring buffer and let
> filter run on it?

Yes, it is what ftrace does. I doubt your way fits all of the existing
trace-event macros. However, I think just for dynamic events, you can
integrating the argument fetching and filtering.

> It's slower, but it's cleaner, because of human readable? since ktap
> arg1 matches first
> argument of tracepoint is better than doing ctx->regs.di ? Sure.
> si->arg1 is easy to fix.
> With si->arg1 tweak the bpf will become architecture independent. It
> will run through JIT on x86 and through interpreter everywhere else.
> but for kprobes user have to specify 'var=cpu_register' during probe
> creation… how is it better than doing the same in filter?

Haven't you used perf-probe yet? It already supports such kind of
translation from kernel local variable name to registers, offsets,
and dereference. :) And kprobe-events can parse such arguments into
method chain. See Documentation/trace/kprobetrace.txt and
tools/perf/Documentation/perf-probe.txt for more detail.
Anyway, I'd like to use the bpf for re-implementing fetch method. :)

Thank you,

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


