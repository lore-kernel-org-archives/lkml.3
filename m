Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753097AbaKJOrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:47:11 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:38129 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901AbaKJOrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:47:09 -0500
Date: Mon, 10 Nov 2014 15:47:04 +0100
From: Ingo Molnar <mingo@kernel.org>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Vince Weaver <vince@deater.net>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFD] perf syscall error handling
Message-ID: <20141110144704.GA24040@gmail.com>
References: <20141031122824.GZ12020@console-pimps.org>
 <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
 <alpine.DEB.2.10.1411010130170.6256@pianoman.cluster.toy>
 <20141103162548.GB18464@kernel.org>
 <20141103165019.GY10501@worktop.programming.kicks-ass.net>
 <20141103170059.GC18464@kernel.org>
 <20141110102725.GA19309@gmail.com>
 <20141110121527.GQ18464@kernel.org>
 <20141110122446.GA21503@gmail.com>
 <5460C83B.5050905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5460C83B.5050905@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Ahern <dsahern@gmail.com> wrote:

> On 11/10/14, 5:24 AM, Ingo Molnar wrote:
> >Programmatic use in user-spaec is very simple - go with my
> >initial example, tooling can either just display the error string
> >and bail out, or do:
> >
> >   if (unlikely(error)) {
> >	if (!strcmp(attr->error_str, "x86/bts: BTS not supported by this CPU architecture")) {
> >		fprintf(stderr, "x86/BTS: No hardware support falling back to branch sampling\n");
> >		activate_x86_bts_fallback_code();
> >		goto out;
> >	}
> 
> That makes the exact string content part of the ABI. [...]

That's ok: messages might still disappear, new messages might 
still be introduced.

> [...] As I recall ftrace had a problem with format strings 
> changing and tooling then limiting the ability to change it.

I think there's a real difference between extended strings 
provided by an error/exception path (perf) and strings provided 
by the primary ABI (ftrace).

In the first case tooling is still functional without extended 
strings, in the second case ftrace tooling is useless if it 
cannot interpret the ftrace string output.

So it's apples to oranges.

Thanks,

	Ingo
