Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab3LIH3v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 02:29:51 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48830 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3LIH3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 02:29:50 -0500
X-AuditID: 9c93017e-b7bb9ae000000ec8-54-52a5716c4039
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?RnLDqWTDqXJpYw==?= Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Pekka Enberg <penberg@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Hellwig <hch@infradead.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH tip 0/5] tracing filters with BPF
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<20131203091655.GB20179@gmail.com>
	<20131203103346.65c744e3@gandalf.local.home>
	<CAMEtUuw_6dCuZd=1fQxNYrZid67n7MRYBT16qBkgR_JxOPkfdg@mail.gmail.com>
	<529E81C1.2070208@hitachi.com>
Date: Mon, 09 Dec 2013 16:29:48 +0900
In-Reply-To: <529E81C1.2070208@hitachi.com> (Masami Hiramatsu's message of
	"Wed, 04 Dec 2013 10:13:37 +0900")
Message-ID: <877gbemqhf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

On Wed, 04 Dec 2013 10:13:37 +0900, Masami Hiramatsu wrote:
> (2013/12/04 3:26), Alexei Starovoitov wrote:
>> the only inconvenience so far is to know how parameters are getting
>> into registers.
>> on x86-64, arg1 is in rdi, arg2 is in rsi,... I want to improve that
>> after first step is done.
>
> Actually, that part is done by the perf-probe and ftrace dynamic events
> (kernel/trace/trace_probe.c). I think this generic BPF is good for
> re-implementing fetch methods. :)

For implementing patch method, it seems that it needs to access to user
memory, stack and/or current (task_struct - for utask or vma later) from
the BPF VM as well.  Isn't it OK from the security perspective?

Anyway, I'll take a look at it later if I have time, but I want to get
the existing/pending implementation merged first. :)

Thanks,
Namhyung
