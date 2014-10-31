Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbaJaVWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:22:23 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:49508 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131AbaJaVWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:22:20 -0400
MIME-Version: 1.0
In-Reply-To: <20141031122824.GZ12020@console-pimps.org>
References: <20141030222814.GF15602@worktop.programming.kicks-ass.net>
	<alpine.DEB.2.10.1410302111150.2766@pianoman.cluster.toy>
	<20141031072109.GD12706@worktop.programming.kicks-ass.net>
	<20141031092713.GA23124@gmail.com>
	<20141031122824.GZ12020@console-pimps.org>
Date: Fri, 31 Oct 2014 22:22:19 +0100
Message-ID: <CABPqkBS0gKWyTc=TFpGxRwOQkAe1o5zXtWaUyHezpO53LhCqrQ@mail.gmail.com>
Subject: Re: [RFD] perf syscall error handling
From: Stephane Eranian <eranian@google.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Vince Weaver <vince@deater.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Oct 31, 2014 at 1:28 PM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 31 Oct, at 10:27:13AM, Ingo Molnar wrote:
>>
>>  - user-space gets back the regular errno (-EOPNOTSUPP or -ENOSYS
>>    or -EINVAL, etc.) and a string. Strings are really the most
>>    helpful information, because tools can just print that. They
>>    can also match on specific strings and programmatically react
>>    to them if they want to: we can promise to not arbitrarily
>>    change error strings once they are introduced. (but even if
>>    they change, user-space can still print them out.)
>
> I guess we'd run into a problem if userspace doesn't want to just print
> the kernel string but instead wants to parse it in some fashion.
>
> That may or may not be a problem in practice, Vince can probably comment
> on that. I'm just thinking along the lines of making the perf syscall
> interface as useful as possible for tools other than tools/perf.
>
Maybe I missed something in the earlier thread, but I am trying to understand
why perf_event_open() would need such extended error retrieval system when
no other syscall does.

In any case, I would go with Ingo's proposal.
