Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764186Ab3DDHhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 03:37:14 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:34397 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763314Ab3DDHhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 03:37:10 -0400
Date: Thu, 4 Apr 2013 09:37:00 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Pawel Moll <pawel.moll@arm.com>, Peter Zijlstra <peterz@infradead.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
Message-ID: <20130404073700.GA1860@localhost.localdomain>
References: <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
 <1363291021.3100.144.camel@hornet>
 <51586315.7080006@gmail.com>
 <5159D221.70304@linaro.org>
 <1364889256.16858.1.camel@laptop>
 <515B0502.8070408@linaro.org>
 <1365009558.26858.19.camel@hornet>
 <515C66FE.7030501@linaro.org>
 <1365010502.26858.32.camel@hornet>
 <515C6C01.9070905@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515C6C01.9070905@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 10:50:57AM -0700, John Stultz wrote:
> 
> I get the reasoning around reusing the fd we already have, but is
> the possibility of a dynamic chardev pathname really a big concern?

I have been following this thread, and, not knowing very much about
perf, I would think that the userland can easily open a second file
(the dynamic posix clock chardev) in order to get these time stamps.

> Maybe can we extend the dynamic posix clock code to work on more
> then just the chardev? Although I worry about multiplexing too much
> functionality on the file.

I don't yet see a need for that, but if we do, then it should work in
a generic way, and not as a list of special cases, like we saw in the
patch.

Thanks,
Richard
