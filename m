Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497AbaKAUjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 16:39:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:47514 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759300AbaKAUj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 16:39:29 -0400
Date: Sat, 1 Nov 2014 21:39:17 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 5/8] perf: Add pmu callbacks to track event mapping
 and unmapping
In-Reply-To: <CALCETrXBkc8_rMdr0ueBTBYwSVQ7C3juZo4JCEY9UU=rm_nNww@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411012135040.5308@nanos>
References: <cover.1414190806.git.luto@amacapital.net> <266afcba1d1f91ea5501e4e16e94bbbc1a9339b6.1414190806.git.luto@amacapital.net> <alpine.DEB.2.11.1411012058030.5308@nanos> <CALCETrXBkc8_rMdr0ueBTBYwSVQ7C3juZo4JCEY9UU=rm_nNww@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014, Andy Lutomirski wrote:
> On Sat, Nov 1, 2014 at 12:59 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Fri, 24 Oct 2014, Andy Lutomirski wrote:
> >
> > I'm probably missing something.
> >
> > Why is this tied to the mmap? If I just open a counter then I should
> > be able to read the counter from user space w/o mmapping something in
> > the first place.
> 
> You can read it with read(2), which this patch shouldn't affect.  If
> you want to read it with rdpmc, then you need to know what rdpmc index
> to use, and the API for that is to mmap the event, check the
> userpage's cap_user_rdpmc, and then rdpmc on ->idx - 1 (assuming that
> ->idx != 0).  You can't safely make any assumptions about which rdpmc
> index it will be without explicitly checking, because perf reserves
> the right to change the index whenever it wants.

Got it. As I expected: I was missing something :)
 
> There's plenty of room to tighten up the restrictions further, but
> this is, I think, a decent first step, and it solves the problem of
> information leaking into seccomp sandboxes.

In which way?

Thanks,

	tglx

