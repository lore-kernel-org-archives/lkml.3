Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbaDVVYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 17:24:31 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:45347 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbaDVVYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 17:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140422205439.GM22728@two.firstfloor.org>
References: <20140422180305.GK8488@redhat.com>
	<20140422205439.GM22728@two.firstfloor.org>
Date: Tue, 22 Apr 2014 23:24:24 +0200
Message-ID: <CABPqkBTNeAoW6z91q_2U+KWAXnkn3b7K6bGNc3PmRp+h89_cFw@mail.gmail.com>
Subject: Re: mapping instructions to dynamic languages like java, python, ruby
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, William Cohen <wcohen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 10:54 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> Does anyone have any thoughts or experience on this?
>
> perf has a JIT interface today, but it's extremely primitive
> and only supports symbols. Clearly it could be done better.
>
> Various JITs (e.g. Java) have special debug interfaces for this.
>
> Various non perf profilers support it too. e.g. Vtune has a special
> API for it:
> https://software.intel.com/sites/default/files/jit_profiling_api_lin_0.pdf
>
> Essentially you would need to write a JIT specific adapter
> that translates to perf format. Or emulate the Vtune interface
> and reuse existing Vtune adaptations.
>
> perf record needs some kind of side band interface where the JIT adapter
> can report to it:
> - symbols
> - the assembler code (so it can be shown)
> - source lines
> - report any changes when JITed code changes
>
Forgot to mention that my implementation does go all the way to jitted
code assembly view via perf annotate + source view.

So it does cover all aspects.

As for attaching to a running JIT, this again needs some cooperation
from JIT environment.


> Then perf record could put that information into the perf.data.
>
> In theory that information could be passed through the kernel,
> but just using some user protocol (unix sockets or files) would be
> likely enough. The current interface uses files in /tmp.
> I would likely change that, it's not clear even if it's secure.
>
> It's likely a substantial project.
>
> It would be even useful for the kernel, as the kernel does JITing
> itself these days.
>
> -Andi
