Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaEIQam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 12:30:42 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:61209 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744AbaEIQal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 12:30:41 -0400
Date: Fri, 9 May 2014 20:30:38 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Don Zickus <dzickus@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: perf_fuzzer crash on pentium 4
Message-ID: <20140509163038.GH320@moon.sw.swsoft.com>
References: <alpine.DEB.2.10.1405061137560.3220@vincent-weaver-1.umelst.maine.edu>
 <20140506202307.GA1458@moon>
 <20140508020050.GX39568@redhat.com>
 <20140508073756.GM8607@moon>
 <20140508074930.GN8607@moon>
 <20140508080234.GO8607@moon>
 <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405091211430.13652@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:19:49PM -0400, Vince Weaver wrote:
> On Thu, 8 May 2014, Cyrill Gorcunov wrote:
> > 
> > Updated.
> > ---
> >  arch/x86/kernel/cpu/perf_event_p4.c |   67 ++++++++++++++++--------------------
> >  1 file changed, 30 insertions(+), 37 deletions(-)
> 
> I tried this patch, and even though it seemed to fix one of the NMI storms 
> I was experiencing I've managed to trigger again using a different random 
> seed.

Thanks a lot for help in testing, Vince! I think the patch would be still
needed so I will prepare normal change log explaining what has been fixed
in the patch.

> I've been trying to track down a trace of what is triggering things, but 
> this is very difficult as the full log isn't making it to the serial 
> console, even when I fsync() stdout.

I see. Need to think. Maybe something comes to mind. Debuggin it is really
a hard job :/ I've been promised to get access to real p4 machine next
week, maybe I find something.

> Maybe related, but the following messages tend to happen a lot while 
> fuzzing, and always happen before the fuzzing that eventually locks up:
> 
> The warnings are for
> 	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
> and
> 	WARN_ON_ONCE(hwc->state & PERF_HES_STOPPED);	

Thanks for info, Vince! Look, every time you start perf_fuzzer (note,
I didn't read its code yet, that's why I'm asking) -- does it log
which events are passed to kernel from userspace? Btw, do you run
kernel with nmi-watchdog turned on?
