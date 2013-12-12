Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab3LLCLp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 21:11:45 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:8398 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750894Ab3LLCLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 21:11:44 -0500
Date: Wed, 11 Dec 2013 21:11:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Sonny Rao <sonnyrao@chromium.org>
Cc: Stephane Eranian <eranian@google.com>,
        Josh Triplett <josh@joshtriplett.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Olof Johansson <olof@lixom.net>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, pawel.moll@arm.com
Subject: Re: [RFC PATCH] drivers: char: Add a dynamic clock for the trace
 clock
Message-ID: <20131211211142.3120bd2a@gandalf.local.home>
In-Reply-To: <CAPz6YkV0z6XBApD+hcSeaAuLGEZZEeuDM0Aq95Q3ySL89NMEzg@mail.gmail.com>
References: <1386376451-24593-1-git-send-email-sonnyrao@chromium.org>
	<20131209074933.GA2922@jtriplet-mobl1>
	<CABPqkBTufgMk=iqXM87+psUeLd865QF9tCEVHT6hwT4=TtetfQ@mail.gmail.com>
	<CAPz6YkU6-ccJ8eJwYUgs_Gjo5rYeSh3ftSgd_MzCXRTyzhPiiQ@mail.gmail.com>
	<20131211204900.76993a7d@gandalf.local.home>
	<CAPz6YkV0z6XBApD+hcSeaAuLGEZZEeuDM0Aq95Q3ySL89NMEzg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 18:06:06 -0800
Sonny Rao <sonnyrao@chromium.org> wrote:


> > ftrace has several clocks that it uses:
> >
> > o local - basically sched_clock()
> > o global - something like hpet that is monotonic across CPUs but slower
> > o counter - a simple atomic counter (no time associated to it)
> > o uptime - jiffy counter
> > o perf  - trace_clock, which is what perf uses
> > o x86_tsc - the raw tsc counter.
> >
> > # cat /sys/kernel/debug/trace_clock
> > [local] global counter uptime perf x86-tsc
> >
> 
> Ah ok sorry for the incorrect info there, thanks for clarifying.
> So, If I wanted to make sure everything is synced up between ftrace
> events and perf events I should say perf here instead of local.

Correct, that's why I created that clock.

-- Steve
