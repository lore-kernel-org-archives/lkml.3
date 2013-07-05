Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972Ab3GEWV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 18:21:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:46872 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067Ab3GEWV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 18:21:58 -0400
Date: Sat, 6 Jul 2013 00:21:48 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Seiji Aguchi <seiji.aguchi@hds.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: RE: Yet more softlockups.
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D443E197DC@USINDEM103.corp.hds.com>
Message-ID: <alpine.DEB.2.02.1307060019060.32106@ionos.tec.linutronix.de>
References: <20130704015525.GA8486@redhat.com> <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com> <20130705143821.GB325@redhat.com> <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de> <20130705160043.GF325@redhat.com>
 <alpine.DEB.2.02.1307051802070.32106@ionos.tec.linutronix.de> <51D6F729.8030101@zytor.com> <A5ED84D3BB3A384992CBB9C77DEDA4D443E197DC@USINDEM103.corp.hds.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jul 2013, Seiji Aguchi wrote:
> > -----Original Message-----
> > Hmmm... this makes me wonder if the interrupt tracepoint stuff is at
> > fault here, as it changes the IDT handling for NMI context.
> 
> This softlockup happens while disabling the interrupt tracepoints,
> Because if it is enabled, "smp_trace_apic_timer_interrupt" is displayed
> instead of "smp_apic_timer_interrupt" in the call trace below.
> 
> But I can't say anything how this issue is related to the tracepoint stuff,

I doubt it is related. I rather suspect that trinity is able to fuzz
perf into a DoS facility.

Dave, can you trace the perf sys calls and dump that data over serial
when the softlockup hits?

Thanks,

	tglx
