Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab3BQG0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 01:26:30 -0500
Received: from mout.gmx.net ([212.227.17.20]:64296 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab3BQG02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 01:26:28 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/wM0d1mUTwe6VUWAap2sw7JPotv91+7AxKj9Dxar
	jLGGlKTJxHvw/2
Message-ID: <1361082379.6088.22.camel@marge.simpson.net>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Mike Galbraith <efault@gmx.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Sun, 17 Feb 2013 07:26:19 +0100
In-Reply-To: <1360908819.23152.97.camel@gandalf.local.home>
References: <1360908819.23152.97.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-15 at 01:13 -0500, Steven Rostedt wrote: 
> I've been working on cleaning up the scheduler a little and I moved the
> call to idle_balance() from directly in the scheduler proper into the
> idle class. Benchmarks (well hackbench) improved slightly as I did this.
> I was adding some more tweaks and running perf stat on the results when
> I made a mistake and notice a drastic change.
> 
> My runs looked something like this on my i7 4 core 4 hyperthreads:
> 

> 293,801,912,874 cycles                    #    1.470 GHz                      ( +-  4.20% ) [100.00%]

> 215,927,081,108 cycles                    #    2.198 GHz                      ( +-  5.48% ) [100.00%]

Hm.  Maybe set governor to performance?

-Mike

