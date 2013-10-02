Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3JBPWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 11:22:18 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:57637 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752965Ab3JBPWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 11:22:14 -0400
Date: Wed, 2 Oct 2013 17:22:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131002152210.GA15757@gmail.com>
References: <CABPqkBQrTzMKnL-f5iCe4jhM1mHXNE6aZ=OwVmpsezOLaRLntA@mail.gmail.com>
 <20130930161546.GG3081@twins.programming.kicks-ass.net>
 <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
 <20130930165420.GI3081@twins.programming.kicks-ass.net>
 <CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
 <20131002112316.GP3081@twins.programming.kicks-ass.net>
 <20131002115826.GM26785@twins.programming.kicks-ass.net>
 <20131002123953.GB27811@gmail.com>
 <20131002124610.GD28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131002124610.GD28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Oct 02, 2013 at 02:39:53PM +0200, Ingo Molnar wrote:
> >  - then there are timing attacks, and someone having access to a PMU
> >    context and who can trigger this SHA1 computation arbitrarily in task 
> >    local context can run very accurate and low noise timing attacks...
> > 
> >    I don't think the kernel's sha_transform() is hardened against timing 
> >    attacks, it's performance optimized so it has variable execution time
> >    highly dependent on plaintext input - which leaks information about the 
> >    plaintext.
> 
> Typical user doesn't have enough priv to profile kernel space; once you 
> do you also have enough priv to see kernel addresses outright (ie. 
> kallsyms etc..).

I didn't mean profiling - that's not a 'timing attack'.

A simple RDTSC done around repeated calls to sha_transform() using kernel 
functionality is.

Thanks,

	Ingo
