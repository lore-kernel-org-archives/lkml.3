Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab3GESVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 14:21:32 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:41666 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab3GESVb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 14:21:31 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: RE: Yet more softlockups.
Thread-Topic: Yet more softlockups.
Thread-Index: AQHOeY1q0We6LeM5qUqVLKQYjsff3JlWdNCAgAAMvoCAAACMgIAACsWA///XBpA=
Date: Fri, 5 Jul 2013 18:20:15 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443E197DC@USINDEM103.corp.hds.com>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <alpine.DEB.2.02.1307051802070.32106@ionos.tec.linutronix.de>
 <51D6F729.8030101@zytor.com>
In-Reply-To: <51D6F729.8030101@zytor.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-07-05_08:2013-07-05,2013-07-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1307050145
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: H. Peter Anvin [mailto:hpa@zytor.com]
> Sent: Friday, July 05, 2013 12:41 PM
> To: Thomas Gleixner
> Cc: Dave Jones; Linus Torvalds; Linux Kernel; Ingo Molnar; Peter Zijlstra; Seiji Aguchi
> Subject: Re: Yet more softlockups.
> 
> On 07/05/2013 09:02 AM, Thomas Gleixner wrote:
> > On Fri, 5 Jul 2013, Dave Jones wrote:
> >> On Fri, Jul 05, 2013 at 05:15:07PM +0200, Thomas Gleixner wrote:
> >>   > On Fri, 5 Jul 2013, Dave Jones wrote:
> >>   >
> >>   > > BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child1:14565]
> >>   > > perf samples too long (2519 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> >>   > > INFO: NMI handler (perf_event_nmi_handler) took too long to run: 238147.002 msecs
> >>   >
> >>   > So we see a softlockup of 23 seconds and the perf_event_nmi_handler
> >>   > claims it did run 23.8 seconds.
> >>   >
> >>   > Are there more instances of NMI handler messages ?
> >>
> >> [ 2552.006181] perf samples too long (2511 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> >> [ 2552.008680] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 500392.002 msecs
> >
> > Yuck. Spending 50 seconds in NMI context surely explains a softlockup :)
> >
> 
> Hmmm... this makes me wonder if the interrupt tracepoint stuff is at
> fault here, as it changes the IDT handling for NMI context.

This softlockup happens while disabling the interrupt tracepoints,
Because if it is enabled, "smp_trace_apic_timer_interrupt" is displayed
instead of "smp_apic_timer_interrupt" in the call trace below.

But I can't say anything how this issue is related to the tracepoint stuff,
I need to reproduce it on my machine first.

Call Trace:
 <IRQ> 
 [<ffffffff8105424f>] __do_softirq+0xff/0x440
 [<ffffffff8105474d>] irq_exit+0xcd/0xe0
 [<ffffffff816f5fcb>] smp_apic_timer_interrupt+0x6b/0x9b
 [<ffffffff816f512f>] apic_timer_interrupt+0x6f/0x80

Seiji
