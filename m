Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbaEND3S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 23:29:18 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:59234 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056AbaEND3P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 23:29:15 -0400
MIME-Version: 1.0
In-Reply-To: <20140513231708.7eb39a38@gandalf.local.home>
References: <1400036111-7803-1-git-send-email-ast@plumgrid.com>
	<20140513231708.7eb39a38@gandalf.local.home>
Date: Tue, 13 May 2014 20:29:14 -0700
Message-ID: <CAMEtUuzct=k_9f4QTqRf2TG6mFCjpnfTjo+JkHYQDHKj_i2b+A@mail.gmail.com>
Subject: Re: [PATCH RFC net-next] tracing: accelerate tracing filters with BPF
From: Alexei Starovoitov <ast@plumgrid.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 8:17 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Tue, 13 May 2014 19:55:11 -0700
> Alexei Starovoitov <ast@plumgrid.com> wrote:
>
>> Tracing filters are parsing user supplied character string and constructing
>> a predicate tree. filter_match_preds() was used to walk nodes of the tree to
>> simulate matching of boolean expression.
>>
>
> I applied this on top of net-next, from:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
>  (master branch)
>
> and got this compile error:

Sorry I wasn't clear in the log.
This patch depends on JIT patches that were posted separately.
Since this one is RFC, I didn't want to mix them.
JIT patches:
http://patchwork.ozlabs.org/patch/348558/
http://patchwork.ozlabs.org/patch/348559/
http://patchwork.ozlabs.org/patch/348560/

> kernel/trace/trace_events_filter.c: In function ‘emit_cond’:
> kernel/trace/trace_events_filter.c:1361:36: error: ‘__bpf_call_base’ undeclared (first use in this function)
> kernel/trace/trace_events_filter.c:1361:36: note: each undeclared identifier is reported only once for each function it appears in
> kernel/trace/trace_events_filter.c: In function ‘filter_gen_bpf’:
> kernel/trace/trace_events_filter.c:1622:2: error: implicit declaration of function ‘bpf_int_jit_compile’ [-Werror=implicit-function-declaration]
>
> Config attached.
>
> -- Steve
