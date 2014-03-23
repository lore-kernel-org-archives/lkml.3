Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbaCWPO1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 11:14:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:58171 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaCWPOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 11:14:25 -0400
Date: Sun, 23 Mar 2014 16:14:31 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: rb tree hrtimer lockup bug (found by perf_fuzzer)
In-Reply-To: <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.02.1403231613230.18573@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1403031526210.11945@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1403190941170.18343@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403191456120.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191039560.18652@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403191552570.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403191300540.18754@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403201056020.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201045560.21603@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403201609540.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403201724430.23339@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.02.1403210956000.18573@ionos.tec.linutronix.de> <alpine.DEB.2.10.1403211610430.30801@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.02.1403221118060.18573@ionos.tec.linutronix.de> <alpine.DEB.2.02.1403221419000.18573@ionos.tec.linutronix.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2014, Thomas Gleixner wrote:

> On Sat, 22 Mar 2014, Thomas Gleixner wrote:
> > On Fri, 21 Mar 2014, Vince Weaver wrote:
> > 
> > > On Fri, 21 Mar 2014, Thomas Gleixner wrote:
> > > > 
> > > > I'm a complete idiot. I was staring at oaddr and did not notice that
> > > > descr->name is the real culprit. Sorry. Delta patch below.
> > > 
> > > OK.  The log was much longer this time, attached.
> > 
> > Hmmm.
> > 
> > [    2.739858] NULL pointer dereference at           (null)
> > [    2.747390] IP: [<          (null)>]           (null)
> > [    2.752970] PGD 0
> > [    2.755287] Oops: 0010 [#1] SMP
> > 
> > So this time the CPU branched to NULL. So let me recap.
> > 
> > First you had the explosion in the hrtimer code. After enabling debug
> > stuff it went to the timer_list and now it looks different again.
> > 
> > So that looks more like a random memory corruption.
> > 
> > Nasty to debug. And of course it does not reproduce here. I'll throw
> > your config at more machines in the hope that something will trigger
> > it.
> 
> I've refined the trace_printk stuff in the hope to get a bit more info
> out of it.

You might also try with the trace_printks removed. That wont give us
the history, but maybe then the bug happens again at some decodable
place.

