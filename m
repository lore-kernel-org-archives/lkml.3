Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759646Ab3LHSXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 13:23:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12489 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab3LHSXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 13:23:07 -0500
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Jovi Zhangwei <jovi.zhangwei@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Tom Zanussi <tom.zanussi@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>
Subject: Re: [RFC PATCH tip 4/5] use BPF in tracing filters
References: <1386044930-15149-1-git-send-email-ast@plumgrid.com>
	<1386044930-15149-5-git-send-email-ast@plumgrid.com>
	<529E7BEC.70509@hitachi.com>
	<20131203201133.52934a02@gandalf.local.home>
	<529FC352.7090004@hitachi.com>
	<CAMEtUuwMv6PtN=9_RmxouZpVB8PVN8oZDNDUyLva2J+xos48og@mail.gmail.com>
	<52A18E31.6030605@hitachi.com>
	<CAGdX0WGK13RVo6dgNbMKm81gy4GLZUBFEhmYfHj6tjz33FpmnQ@mail.gmail.com>
	<52A26268.5070403@hitachi.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 08 Dec 2013 13:22:44 -0500
In-Reply-To: <52A26268.5070403@hitachi.com> (Masami Hiramatsu's message of "Sat, 07 Dec 2013 08:48:56 +0900")
Message-ID: <y0m38m3qk23.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


masami.hiramatsu.pt wrote:

> [...]
> Anyway, as far as I can see, there looks be two different models of
> tracing in our mind.
>
> A) Fixed event based tracing: In this model, there are several fixed
> "events" which well defined with fixed arguments. tracer handles these
> events and only use limited arguments. It's like a packet stream
> processing. ftrace, perf etc. are used this model.
>
> B) Flexible event-point tracing: In this model, each tracer(or even
> trace user) can freely define their own event, there will be some fixed
> tracing points defined, but arguments are defined by users. It's like a
> debugger's breakpoint debugging. systemtap, ktap etc. are used this model.

It may be more useful to think of it as a contrast along the
hard-coded versus programmable axis.  (perf, systemtap, and ktap can
each reach to some extent across your "fixed" vs "flexible" line.
Each has some dynamic and some static-tracepoint capability.)


> e.g. B model has a good flexibility and A model is easy to use for
> beginners.

I don't think it's the model that dictates ease-of-use, but the
quality of implementation, logistics, documentation, and examples.


- FChE
