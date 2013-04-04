Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763224Ab3DDQd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:33:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42300 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763115Ab3DDQd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:33:26 -0400
Message-ID: <1365093202.26858.111.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Thu, 04 Apr 2013 17:33:22 +0100
In-Reply-To: <20130404073700.GA1860@localhost.localdomain>
References: <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
	 <515B0502.8070408@linaro.org> <1365009558.26858.19.camel@hornet>
	 <515C66FE.7030501@linaro.org> <1365010502.26858.32.camel@hornet>
	 <515C6C01.9070905@linaro.org> <20130404073700.GA1860@localhost.localdomain>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 04 Apr 2013 16:33:22.0689 (UTC) FILETIME=[1F8F5710:01CE3152]
X-MC-Unique: 113040417332422001
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-04-04 at 08:37 +0100, Richard Cochran wrote:
> > I get the reasoning around reusing the fd we already have, but is
> > the possibility of a dynamic chardev pathname really a big concern?
> 
> I have been following this thread, and, not knowing very much about
> perf, I would think that the userland can easily open a second file
> (the dynamic posix clock chardev) in order to get these time stamps.

Sure it can - I've tested it. It's just a bit cumbersome in my opinion
(there is nothing else perf-related in /dev). I can agree to disagree if
you think otherwise :-)

> > Maybe can we extend the dynamic posix clock code to work on more
> > then just the chardev? Although I worry about multiplexing too much
> > functionality on the file.
> 
> I don't yet see a need for that, but if we do, then it should work in
> a generic way, and not as a list of special cases, like we saw in the
> patch.

By all means - and even more generic way than it is now (why character
devices not any other file?). I'll give it a try.

Paweł



