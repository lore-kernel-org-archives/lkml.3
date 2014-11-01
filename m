Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166AbaKAWKP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:10:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:47629 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaKAWKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:10:13 -0400
Date: Sat, 1 Nov 2014 23:10:02 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: X86 ML <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        Vince Weaver <vince@deater.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH v2 5/8] perf: Add pmu callbacks to track event mapping
 and unmapping
In-Reply-To: <CALCETrVjG4T-+jZ+4AZX-i9s_Do8BY=+fp1JmWCxnbAfGiVvug@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411012308490.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <266afcba1d1f91ea5501e4e16e94bbbc1a9339b6.1414190806.git.luto@amacapital.net> <alpine.DEB.2.11.1411012058030.5308@nanos> <CALCETrXBkc8_rMdr0ueBTBYwSVQ7C3juZo4JCEY9UU=rm_nNww@mail.gmail.com>
 <alpine.DEB.2.11.1411012135040.5308@nanos> <CALCETrVjG4T-+jZ+4AZX-i9s_Do8BY=+fp1JmWCxnbAfGiVvug@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014, Andy Lutomirski wrote:
> On Nov 1, 2014 1:39 PM, "Thomas Gleixner" <tglx@linutronix.de> wrote:
> > On Sat, 1 Nov 2014, Andy Lutomirski wrote:
> > > There's plenty of room to tighten up the restrictions further, but
> > > this is, I think, a decent first step, and it solves the problem of
> > > information leaking into seccomp sandboxes.
> >
> > In which way?
> 
> All the performance counters were readable without using any syscalls.
> That leaks hints as to which events are in use, and it possibly leaks
> interesting side channel information.   With this series applied, you
> need a at least mmap an rdpmc-able event, which most seccomp sandboxes
> won't allow.

Ok. So you are preventing the seccomp sandboxes to open/mmap a counter.
 
> Unfortunately, rdpmc access to counters can't be controlled
> individually, so it's hard to do all that much better than this.

Yeah, I know ...

Thanks,

	tglx
