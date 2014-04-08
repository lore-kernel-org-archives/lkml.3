Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200AbaDHGvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 02:51:02 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:55024 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785AbaDHGu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 02:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <20140404073616.GC1637@gmail.com>
References: <1396014469-5937-1-git-send-email-jovi.zhangwei@gmail.com>
	<20140331071749.GA1252@gmail.com>
	<CAGdX0WEV5OEfk4vfMKYeEpHP_7XqpUKk2-iwTVoTup1ObYu3eg@mail.gmail.com>
	<CAMEtUuw24=+CkcdwDnJ4AbSCjGBBFx+8pTFzn5gXbQAy=KYWng@mail.gmail.com>
	<CAGdX0WEvsPqWjE8Uade5_i58AepKxGndM0eSg=viB+UYGOSkJw@mail.gmail.com>
	<CAMEtUuxYigBYnH_n_MCrs_=r9KLGOha3rSuNZ876mgH1tAvVCg@mail.gmail.com>
	<CAGdX0WE_xtUY7=CH7Qzxn9Oe8Mz=60wb6izD-APbF5d3caEthA@mail.gmail.com>
	<20140402074322.GA22744@gmail.com>
	<CAGdX0WHh3UqiCLbz+18_fj5s4PMpTfy638HA=LHpgLfVc2JpOg@mail.gmail.com>
	<20140404073616.GC1637@gmail.com>
Date: Tue, 8 Apr 2014 14:50:28 +0800
Message-ID: <CAGdX0WEkWq7hVnoffNaOEouDd17qr08EiPG2osF+DBPj4nZ-Gg@mail.gmail.com>
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

On Fri, Apr 4, 2014 at 3:36 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Jovi Zhangwei <jovi.zhangwei@gmail.com> wrote:
>
>> I don't see any suggestion about integrating BPF before this review
>> cycle.
>
> Hm, I mentioned it at the kernel summit to folks who raised the ktap
> subject, but apparently not over email. I assumed a new ktap
> submission would come quickly.
>
> Anyway, considering how BPF is integrating with (and hopefully
> replacing) tracing filters, it makes sense to apply the same concept
> in the ktap case as well.
>
It seems that kernel developers want a C based tracing filter, BPF
rooted from C(Compiler, performance, and networking target),
but ktap designed from a different point of view, which highlights
simplicity and flexibility, this simplicity and flexibility is not only
presented by simple syntax, but also in its bytecode engine.

trace syscalls:* {
    print(cpu, pid, execname, argstr, stack())
}

Each expression have own type in kernel, the type is not judged by
userspace compiler, this make print expression much much easy,
also make handle associate array(and aggregation) extremely simple.
If we force replace ktap core with a much "static" bytecode engine,
then it will lose the highlight feature: simplicity and flexibility.

ktap is not designed to be a built-in tracing filter and not purpose for
high performance bytecode engine(can use for networking), BPF is
suit for that way, but that is not a design flaw in ktap, it's designed
to be like that.

Obviously many people love ktap nowadays even though it's not a
C-family language, people can use ktap one-liner to do interesting
things(http://brendangregg.com/ktap.html), and used in real world.
Also especially people in embedded world like ktap very much,
they already included ktap into OpenEmebedded as I know.

It seems that more and more tracing related kernel modules will
come in future(like https://github.com/draios/sysdig/issues/81),
so maybe these third-part kernel modules based on tracing export
symbols should locate in drivers/, not kernel/trace/, today we have
well defined tracing kernel interface(tracepoint, kprobe, uprobe, perf
callback),
no reason to put all these external modules sit in kernel/trace one place,
especially if the module have real end users in world.

Thanks.

Jovi
