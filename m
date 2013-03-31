Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3CaQYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 12:24:00 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41675 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab3CaQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 12:23:59 -0400
Message-ID: <51586315.7080006@gmail.com>
Date: Sun, 31 Mar 2013 10:23:49 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Pawel Moll <pawel.moll@arm.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>  <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>  <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>  <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>  <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>  <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>  <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com> <1363291021.3100.144.camel@hornet>
In-Reply-To: <1363291021.3100.144.camel@hornet>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/13 1:57 PM, Pawel Moll wrote:
> Ok, how about the code below? I must say I have some doubts about the
> resolution, as there seem to be no generic way of figuring it out for
> the sched_clock (the arch/arm/kernel/sched_clock.c is actually
> calculating it, but than just prints it out and nothing more).
>
> And, to summarize, we went through 3 ideas:
>
> 1. ioctl() - http://article.gmane.org/gmane.linux.kernel/1433933
> 2. syscall - http://article.gmane.org/gmane.linux.kernel/1437057
> 3. POSIX clock - below
>
> John also suggested that maybe the perf could use CLOCK_MONOTONIC_RAW
> instead of local/sched_clock().

Any chance a decision can be reached in time for 3.10? Seems like the 
simplest option is the perf event based ioctl.

Converting/correlating perf_clock timestamps to time-of-day is a feature 
I have been trying to get into perf for over 2 years. This is a big 
piece needed for that goal -- along with the xtime tracepoints:
   https://lkml.org/lkml/2013/3/19/433

David

