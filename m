Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab3JBNiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 09:38:18 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46346 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703Ab3JBNiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 09:38:15 -0400
Date: Wed, 2 Oct 2013 15:37:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Hugh Dickins <hughd@google.com>, Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] perf: mmap2 not covering VM_CLONE regions
Message-ID: <20131002133759.GH28601@twins.programming.kicks-ass.net>
References: <CABPqkBSRV651SynNHpAo7-B+8aX2hsMXKJNeTkimBoWo91TvFQ@mail.gmail.com>
 <20130930165420.GI3081@twins.programming.kicks-ass.net>
 <CABPqkBS_zDkgX4NioducZ+H9VEt1jb7gQDbZ_zB6ui5Tf=UR5A@mail.gmail.com>
 <20131002112316.GP3081@twins.programming.kicks-ass.net>
 <20131002115826.GM26785@twins.programming.kicks-ass.net>
 <20131002123953.GB27811@gmail.com>
 <20131002124610.GD28601@twins.programming.kicks-ass.net>
 <CABPqkBQyCfz5d+SQxDwPD5m52ofE6y5HKur+s-F0s=hN00cxkw@mail.gmail.com>
 <20131002130143.GF28601@twins.programming.kicks-ass.net>
 <CABPqkBTdWZaJzv4PA3yBor+o_iaBSmK73CrUQeY1tANR36ah8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTdWZaJzv4PA3yBor+o_iaBSmK73CrUQeY1tANR36ah8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 03:13:16PM +0200, Stephane Eranian wrote:
> On Wed, Oct 2, 2013 at 3:01 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Oct 02, 2013 at 02:59:32PM +0200, Stephane Eranian wrote:
> >> On Wed, Oct 2, 2013 at 2:46 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> >> > On Wed, Oct 02, 2013 at 02:39:53PM +0200, Ingo Molnar wrote:
> >> >>  - then there are timing attacks, and someone having access to a PMU
> >> >>    context and who can trigger this SHA1 computation arbitrarily in task
> >> >>    local context can run very accurate and low noise timing attacks...
> >> >>
> >> >>    I don't think the kernel's sha_transform() is hardened against timing
> >> >>    attacks, it's performance optimized so it has variable execution time
> >> >>    highly dependent on plaintext input - which leaks information about the
> >> >>    plaintext.
> >> >
> >> > Typical user doesn't have enough priv to profile kernel space; once you
> >> > do you also have enough priv to see kernel addresses outright (ie.
> >> > kallsyms etc..).
> >> >
> >> I was going to say just that. But that's not the default, paranoid level
> >> is at 1 by default and not 2. So I supposedly can still do:
> >
> > Oh right you are.. so yes that's a very viable avenue.
> 
> You mean simply encoding the vma->vm_mm as the ino number, for instance.

Nah.. I think Kees would very much shoot us on the spot for doing that.
But with the paranoid level defaulting to 1 the PMU attack on the kernel
SHA implenentation is feasible.

