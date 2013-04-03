Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab3DCOWu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:22:50 -0400
Received: from mail-qc0-f172.google.com ([209.85.216.172]:55854 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759883Ab3DCOWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:22:48 -0400
MIME-Version: 1.0
In-Reply-To: <515C393C.8030405@gmail.com>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	<1350408232.2336.42.camel@laptop>
	<1359728280.8360.15.camel@hornet>
	<CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	<51118797.9080800@linaro.org>
	<alpine.LFD.2.02.1302182132230.22263@ionos>
	<5123C3AF.8060100@linaro.org>
	<1361356160.10155.22.camel@laptop>
	<51285BF1.2090208@linaro.org>
	<1361801441.4007.40.camel@laptop>
	<CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	<1363291021.3100.144.camel@hornet>
	<51586315.7080006@gmail.com>
	<5159D221.70304@linaro.org>
	<515A0A3A.2040105@gmail.com>
	<CABPqkBStMd-VT8aoPhFV-rxiLOrH7h2HtS9O9FBkd+ggd5X+xQ@mail.gmail.com>
	<515C34BF.6060508@gmail.com>
	<CABPqkBS_z8zzSn=N_Q+AGbo1kV2EMOoF4dz2Aze=rPNB2n_n2g@mail.gmail.com>
	<515C393C.8030405@gmail.com>
Date: Wed, 3 Apr 2013 16:22:47 +0200
Message-ID: <CABPqkBQjur31gpPWTavjSP5nbc7u8mQwqsRRctYiHnPXz0d=_A@mail.gmail.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 4:14 PM, David Ahern <dsahern@gmail.com> wrote:
> On 4/3/13 8:00 AM, Stephane Eranian wrote:
>>>
>>> What's the advantage of changing apps -- like the JIT compiler -- to emit
>>> perf based timestamps versus having perf emit existing timestamps? ie.,
>>> monotonic and realtime clocks already have vdso mappings for userspace
>>> with
>>> well known performance characteristics. Why not have perf convert its
>>> perf_clock timestamps into monotonic or realtime when dumping events?
>>>
>> Can monotonic timestamps be obtained from NMI context in the kernel?
>
>
> I don't understand the context of the question.
>
> I am not suggesting perf_clock be changed. I am working on correlating
> existing perf_clock timestamps to clocks typically used by apps (REALTIME
> and time-of-day but also applies to MONOTONIC).
>
But for that, you'd need to expose to users the correlation between
the two clocks.
And now you'd fixed two clock sources definitions not just one.

> You are wanting the reverse -- have apps emit perf_clock timestamps. I was
> just wondering what is the advantage of this approach?
>
Well, that's how I interpreted your question ;-<

If you could have perf_clock use monotonic then we would not have this
discussion.
The correlation would be trivial.
