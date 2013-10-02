Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab3JBNNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:13:19 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:48376 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710Ab3JBNNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:13:17 -0400
MIME-Version: 1.0
In-Reply-To: <20131002130143.GF28601@twins.programming.kicks-ass.net>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
	<20130930161546.GG3081@twins.programming.kicks-ass.net>
	<CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
	<20130930165420.GI3081@twins.programming.kicks-ass.net>
	<CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
	<20131002112316.GP3081@twins.programming.kicks-ass.net>
	<20131002115826.GM26785@twins.programming.kicks-ass.net>
	<20131002123953.GB27811@gmail.com>
	<20131002124610.GD28601@twins.programming.kicks-ass.net>
	<CABPqkBQyCfz5d+SQxDwPD5m52ofE6y5HKur+s-F0s=hN00cxkw@mail.gmail.com>
	<20131002130143.GF28601@twins.programming.kicks-ass.net>
Date: Wed, 2 Oct 2013 15:13:16 +0200
Message-ID: <CABPqkBTdWZaJzv4PA3yBor+o_iaBSmK73CrUQeY1tANR36ah8Q@mail.gmail.com>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 2, 2013 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Oct 02, 2013 at 02:59:32PM +0200, Stephane Eranian wrote:
>> On Wed, Oct 2, 2013 at 2:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Wed, Oct 02, 2013 at 02:39:53PM +0200, Ingo Molnar wrote:
>> >>  - then there are timing attacks, and someone having access to a PMU
>> >>    context and who can trigger this SHA1 computation arbitrarily in task
>> >>    local context can run very accurate and low noise timing attacks...
>> >>
>> >>    I don't think the kernel's sha_transform() is hardened against timing
>> >>    attacks, it's performance optimized so it has variable execution time
>> >>    highly dependent on plaintext input - which leaks information about the
>> >>    plaintext.
>> >
>> > Typical user doesn't have enough priv to profile kernel space; once you
>> > do you also have enough priv to see kernel addresses outright (ie.
>> > kallsyms etc..).
>> >
>> I was going to say just that. But that's not the default, paranoid level
>> is at 1 by default and not 2. So I supposedly can still do:
>
> Oh right you are.. so yes that's a very viable avenue.

You mean simply encoding the vma->vm_mm as the ino number, for instance.
