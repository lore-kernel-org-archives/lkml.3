Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751109Ab3FWJna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 05:43:30 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:62912 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FWJn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 05:43:29 -0400
Date: Sun, 23 Jun 2013 11:43:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH][GIT PULL] trace,x86: Move creation of irq tracepoints
 from apic.c to irq.c
Message-ID: <20130623094324.GA15002@gmail.com>
References: <1371835898.18733.122.camel@gandalf.local.home>
 <51C4BC09.3000708@linux.intel.com>
 <20130623090317.GA13445@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623090317.GA13445@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * H. Peter Anvin <hpa@linux.intel.com> wrote:
> 
> > On 06/21/2013 10:31 AM, Steven Rostedt wrote:
> > > 
> > > Peter,
> > > 
> > > I noticed that you pulled in Seiji's patches into tip. Last night I was
> > > running my test suite on them, and this morning they showed the
> > > following compile bug. I found the fix and attached it below. I pushed
> > > it into my tree that's based on your x86/trace branch, for your
> > > convenience.
> > > 
> > > My testing also triggered another bug, but I'm not sure it's related to
> > > these patches or something that already existed. I'm currently
> > > investigating it now.
> > > 
> > > -- Steve
> > > 
> > > 
> > > Please pull the latest tip/x86/trace tree, which can be found at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> > > tip/x86/trace
> > > 
> > > Head SHA1: 83ab85140bc1492f92de263a1c30ea04a0f465f7
> > > 
> > 
> > Thanks, pulled!
> 
> It's still broken for some configs:
> 
> arch/x86/built-in.o: In function `trace_threshold_interrupt':
> (.entry.text+0x1226): undefined reference to `smp_trace_threshold_interrupt'
> arch/x86/built-in.o: In function `trace_thermal_interrupt':
> (.entry.text+0x1306): undefined reference to `smp_trace_thermal_interrupt'
> 
> config attached.

I've applied the fix from Seiji Aguchi and I'm testing the updated 
tip:x86/trace branch now.

Thanks,

	Ingo
