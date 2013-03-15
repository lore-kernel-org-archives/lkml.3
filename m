Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3COUt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 16:49:29 -0400
Received: from www.linutronix.de ([62.245.132.108]:59672 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932386Ab3COUt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 16:49:28 -0400
Date: Fri, 15 Mar 2013 21:49:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Stephane Eranian <eranian@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] perf,x86: fix kernel crash with PEBS/BTS after
 suspend/resume
In-Reply-To: <CA+55aFxqibqOvWcv691ZciO7rXpRFUL=zZVVGRSbD4N1Sz+fFQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1303152149090.22263@ionos>
References: <20130315132607.GA4565@quad> <CA+55aFxqibqOvWcv691ZciO7rXpRFUL=zZVVGRSbD4N1Sz+fFQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Mar 2013, Linus Torvalds wrote:

> On Fri, Mar 15, 2013 at 6:26 AM, Stephane Eranian <eranian@google.com> wrote:
> >
> > This patch fixes a kernel crash when using precise sampling (PEBS)
> > after a suspend/resume.
> 
> Yup, works. Applied.
> 
> Can we please get rid of the crazy CPU notifier crap from the perf
> code, and do this like we do most other wrmsr's etc? Doing
> 
>     git grep "case CPU_" arch/x86/kernel/cpu
> 
> shows that the perf layer seems to be full of this kind of BS. This is
> all CPU state, it should be initialized by the regular CPU
> initialization code, not hooked up with some random callbacks.

It's on my list ....
