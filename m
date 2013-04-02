Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761967Ab3DBQey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:34:54 -0400
Received: from service87.mimecast.com ([91.220.42.44]:48162 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761929Ab3DBQex convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:34:53 -0400
Message-ID: <1364920489.3019.26.camel@hornet>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Pawel Moll <pawel.moll@arm.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, David Ahern <dsahern@gmail.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Tue, 02 Apr 2013 17:34:49 +0100
In-Reply-To: <515B0502.8070408@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	 <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	 <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
	 <515B0502.8070408@linaro.org>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 02 Apr 2013 16:34:50.0744 (UTC) FILETIME=[FF37F780:01CE2FBF]
X-MC-Unique: 113040217345100201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-04-02 at 17:19 +0100, John Stultz wrote:
> I still think exposing the perf clock to userland is a bad idea, and 
> would much rather the kernel provide timestamp data in the logs 
> themselves to make the logs useful. But if we're going to have to do 
> this via a clockid, I'm going to want it to be done via a dynamic posix 
> clockid, so its clear its tightly tied with perf and not considered a 
> generic interface (and I can clearly point folks having problems to the 
> perf maintainers ;).

Hm. 15 mins ago I didn't know about dynamic posix clocks existence at
all ;-)

I feel that the idea of opening a magic character device to obtain a
magic number to be used with clock_gettime() to get the timestamp may
not be popular, but maybe (just a thought) we could somehow use the file
descriptor obtained by the sys_perf_open() itself? How different would
it be from the ioctl(*_GET_TIME) I'm not sure, but I'll try to research
the idea. Counts as number 4 (5?) on my list ;-)

Paweł


