Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367Ab3BRUgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 15:36:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:57141 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753494Ab3BRUgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 15:36:05 -0500
Date: Mon, 18 Feb 2013 21:35:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
In-Reply-To: <51118797.9080800@linaro.org>
Message-ID: <alpine.LFD.2.02.1302182132230.22263@ionos>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, John Stultz wrote:
> On 02/05/2013 02:13 PM, Stephane Eranian wrote:
> > But if people are strongly opposed to the clock_gettime() approach, then
> > I can go with the ioctl() because the functionality is definitively needed
> > ASAP.
> 
> I prefer the ioctl method, since its less likely to be re-purposed/misused.

Urgh. No! With a dedicated CLOCK_PERF we might have a decent chance to
put this into a vsyscall. With an ioctl not so much.
 
> Though I'd be most comfortable with finding some way for perf-timestamps to be
> CLOCK_MONOTONIC based (or maybe CLOCK_MONOTONIC_RAW if it would be easier),
> and just avoid all together adding another time domain that doesn't really
> have clear definition (other then "what perf uses").

What's wrong with that. We already have the infrastructure to create
dynamic time domains which can be completely disconnected from
everything else.

Tracing/perf/instrumentation is a different domain and the main issue
there is performance. So going for a vsyscall enabled clock_gettime()
approach is definitely the best thing to do.

Thanks,

	tglx
