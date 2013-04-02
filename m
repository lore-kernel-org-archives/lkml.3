Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab3DBHyp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 03:54:45 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:39752
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759947Ab3DBHyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 03:54:43 -0400
Message-ID: <1364889256.16858.1.camel@laptop>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user
 samples with kernel samples
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: David Ahern <dsahern@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Date: Tue, 02 Apr 2013 09:54:16 +0200
In-Reply-To: <5159D221.70304@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	  <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	  <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	  <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	  <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	  <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	  <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-01 at 11:29 -0700, John Stultz wrote:
> I'm still not sold on the CLOCK_PERF posix clock. The semantics are 
> still too hand-wavy and implementation specific.

How about we define the semantics as: match whatever comes out of perf
(and preferably ftrace by default) stuff?

Since that stuff is already exposed to userspace, doesn't it make sense
to have a user accessible time source that generates the same time-line
so that people can create logs that can be properly interleaved?

