Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763042Ab3DDQ3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 12:29:30 -0400
Received: from service87.mimecast.com ([91.220.42.44]:52562 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762927Ab3DDQ32 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 12:29:28 -0400
Message-ID: <1365092963.26858.107.camel@hornet>
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
        Robert Richter <robert.richter@amd.com>,
        Richard Cochran <richardcochran@gmail.com>
Date: Thu, 04 Apr 2013 17:29:23 +0100
In-Reply-To: <515C6C01.9070905@linaro.org>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	 <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>
	 <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	 <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>
	 <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>
	 <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>
	 <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	 <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
	 <5159D221.70304@linaro.org> <1364889256.16858.1.camel@laptop>
	 <515B0502.8070408@linaro.org> <1365009558.26858.19.camel@hornet>
	 <515C66FE.7030501@linaro.org> <1365010502.26858.32.camel@hornet>
	 <515C6C01.9070905@linaro.org>
X-Mailer: Evolution 3.6.2-0ubuntu0.1
Mime-Version: 1.0
X-OriginalArrivalTime: 04 Apr 2013 16:29:24.0113 (UTC) FILETIME=[915B8810:01CE3151]
X-MC-Unique: 113040417292601601
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-03 at 18:50 +0100, John Stultz wrote:
> I get the reasoning around reusing the fd we already have, but is the 
> possibility of a dynamic chardev pathname really a big concern?

Well, in my particular development system I have no udev, so I had to
manually do "mknod". Perf syscall works out of the box. Of course one
could say it's my problem...

> I'm guessing the private_data on the perf file is already used?

Of course.

> Maybe can we extend the dynamic posix clock code to work on more then 
> just the chardev? 

The idea I'm following now is to make the dynamic clock framework even
more generic, so there could be a clock associated with an arbitrary
struct file * (the perf syscall is getting one with
anon_inode_getfile()). I don't know how to get this done yet, but I'll
give it a try and report.

Paweł


