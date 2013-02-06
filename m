Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756831Ab3BFBT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:19:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3875 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3BFBT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:19:58 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MbCFXo7hY28A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=2HxqKFuZ9XIA:10 a=3Na1lyL4eMvHLq9UQ1cA:9 a=PUjeQqilurYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360113595.2621.30.camel@gandalf.local.home>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Steven Rostedt <rostedt@goodmis.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>,
        Robert Richter <robert.richter@amd.com>, tglx <tglx@linutronix.de>
Date: Tue, 05 Feb 2013 20:19:55 -0500
In-Reply-To: <51118797.9080800@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-05 at 14:28 -0800, John Stultz wrote:
> I prefer the ioctl method, since its less likely to be re-purposed/misused.
> 
> Though I'd be most comfortable with finding some way for perf-timestamps 
> to be CLOCK_MONOTONIC based (or maybe CLOCK_MONOTONIC_RAW if it would be 
> easier), and just avoid all together adding another time domain that 
> doesn't really have clear definition (other then "what perf uses").

Perhaps add a new perf system call? Does everything need to go through
the one great mighty perf_ioctl aka sys_perf_event_open()? I mean, if
there's something that can be agnostic to an event, but still very much
related to perf, perhaps another perf syscall should be created.

If people are worried about adding a bunch of new perf syscalls, maybe
add a sys_perf_control() system call that works like an ioctl but
without a file descriptor. Something for things that don't require an
event attached to it, like to retrieve a time stamp counter that perf
uses, but done in a way that it could be used for other things perf
related that does not require an event.

-- Steve


