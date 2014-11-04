Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaKDPZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 10:25:41 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:52913 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbaKDPZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 10:25:36 -0500
Message-ID: <1415114727.24819.8.camel@arm.com>
Subject: Re: [PATCH v3 1/3] perf: Use monotonic clock as a source for
 timestamps
From: Pawel Moll <pawel.moll@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christopher Covington <cov@codeaurora.org>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tomeu Vizoso <tomeu@tomeuvizoso.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Date: Tue, 04 Nov 2014 15:25:27 +0000
In-Reply-To: <20141104072308.GE10501@worktop.programming.kicks-ass.net>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	 <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
	 <20141104072308.GE10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 07:23 +0000, Peter Zijlstra wrote:
> On Tue, Nov 04, 2014 at 12:28:36AM +0000, Pawel Moll wrote:
> 
> > +int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;
> 
> const ?

Sure (unless we have to change it as mentioned below)

> >  /*
> >   * perf samples are done in some very critical code paths (NMIs).
> >   * If they take too much CPU time, the system can lock up and not
> > @@ -324,7 +326,7 @@ extern __weak const char *perf_pmu_name(void)
> >  
> >  static inline u64 perf_clock(void)
> >  {
> > -	return local_clock();
> > +	return ktime_get_mono_fast_ns();
> >  }
> 
> Do we maybe want to make it boot-time switchable back to local_clock for
> people with bad systems and or backwards compat issues?

Very good idea, should have came up with it myself :-)

Does __setup("perf_use_local_clock") sound reasonable? Then we have to
decide whether to hide the sysctl "perf_sample_time_clk_id" (my
preferred option, will see how difficult it is) or just provide an
invalid clock_id (eg. -1) in it.

Cheers!

Pawel

