Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756448Ab3J1NTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:19:53 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36172 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883Ab3J1NTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:19:51 -0400
MIME-Version: 1.0
In-Reply-To: <526E55B9.20902@hitachi.com>
References: <20131024075813.GA26929@gmail.com>
	<CAGdX0WFu=sxWUckkZiUQMTxo_tOFbxX-paqU2p_5YR8NaN6gSA@mail.gmail.com>
	<20131025101511.GB3439@gmail.com>
	<CAGdX0WGrGbb-eJvS4HHg9umk7X3-vrzyrJCuhAJrfGvOriKHSQ@mail.gmail.com>
	<20131026085955.GD14237@gmail.com>
	<526E55B9.20902@hitachi.com>
Date: Mon, 28 Oct 2013 21:19:50 +0800
Message-ID: <CAGdX0WE-m1M8GEqx3N8ccX=KkO0Hj_igN1XkrpjHW=qkrwtCAw@mail.gmail.com>
Subject: Re: Re: ktap inclusion in drivers/staging/?
From: Jovi Zhangwei <jovi.zhangwei@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 28, 2013 at 8:16 PM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2013/10/26 17:59), Ingo Molnar wrote:
>>
>> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>>
>>> Thanks. An addition question I want to discuss in here is the ktap
>>> code structure layout in first patch series, this don't need to
>>> dig out any ktap design detail, so we can make agreement on this
>>> point, and ease for me to prepare patch series.
>>>
>>> Do I need to prepare patchset target on staging tree or "real"
>>> part of kernel? [...]
>>
>> I'd suggest adding it to the core, i.e. kernel/tracing/ and
>> kernel/trace/trace_events_filter.c in particular which includes the
>> current filter script interpreter.
>
> It means we'll need to put Lua compiler in the kernel...
> I just recommend to put the ktap *on* the ftrace or perf. Not directly
> integrate it. Bytecode interpreter is good, limited fomula parser is also
> good, but IMHO, integrating complete lua compiler into the kernel looks
> crazy.
> I think it is just enough to include lua compiler as a tool in the kernel.
>
Agree, putting lua language compiler into kernel is a crazy idea, and I
cannot find the good reason for this, IMO.

If you knows lua, they combine compiler and interpreter together, but
when I decided to start ktap, I decoupled the compiler and interpreter,
some reasons behind that decision:

- focus on interpreter(ktapvm)
   we should optimize interpreter as much as we can, but if we also put
   compiler into kernel, we need to open another eye on compiler, to be
   careful on performance/overhead of compiler design, too crazy to
   consider those issues, and not needed.

- debugging info (like vmline, CTF, dwarf)
   debugging info should handle in userspace, not kernel.

- less kernel problems (aka, safety)

- future language syntax change
  easy to change the compiler in userspace, also it's have a possibility
  one kernel interpreter back end for different compiler.

ktap is defined as"lightweight", mainly for ktapvm. if putting compiler
into kernel, then it's not "lightweight" anymore.

Thanks.

Jovi
