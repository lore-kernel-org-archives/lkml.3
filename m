Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab3DCNzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:55:22 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:61189 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab3DCNzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:55:21 -0400
Message-ID: <515C34BF.6060508@gmail.com>
Date: Wed, 03 Apr 2013 07:55:11 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: John Stultz <john.stultz@linaro.org>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org> <alpine.LFD.2.02.1302182132230.22263@ionos> <5123C3AF.8060100@linaro.org> <1361356160.10155.22.camel@laptop> <51285BF1.2090208@linaro.org> <1361801441.4007.40.camel@laptop> <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com> <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com> <5159D221.70304@linaro.org> <515A0A3A.2040105@gmail.com> <CABPqkBStMd-VT8aoPhFV-rxiLOrH7h2HtS9O9FBkd+ggd5X+xQ@mail.gmail.com>
In-Reply-To: <CABPqkBStMd-VT8aoPhFV-rxiLOrH7h2HtS9O9FBkd+ggd5X+xQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/3/13 3:17 AM, Stephane Eranian wrote:
> I haven't done any specific testing with either approach yet. The goal is to
> use this perf timestamp to correlate user level events to hardware
> events recorded
> by the kernel. I would assume there would be situations where those user events
> could be on the critical path, and thus the timestamp operation would have to be
> as efficient as possible. The vdso approach would be ideal.
>
>>
>> The performance/speed depends on how often is called. I have no idea what
>> Stephane's use case is but for me it is to correlate perf_clock timestamps
>> to timeofday. In my perf-based daemon that tracks process schedulings, I
>> update the correlation every 5-10 minutes.
>>
> I was more thinking along the lines of runtime environments like Java where
> a JIT compiler is invoked frequently and you need to correlate samples in the
> native code with Java source. For that, the JIT compiler has to emit mapping
> tables which have to be timestamped as address ranges may be re-used.

What's the advantage of changing apps -- like the JIT compiler -- to 
emit perf based timestamps versus having perf emit existing timestamps? 
ie., monotonic and realtime clocks already have vdso mappings for 
userspace with well known performance characteristics. Why not have perf 
convert its perf_clock timestamps into monotonic or realtime when 
dumping events?

David

