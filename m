Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab3GJPUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 11:20:19 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:51315 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754155Ab3GJPUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 11:20:17 -0400
Date: Wed, 10 Jul 2013 17:20:15 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Anvin <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: Yet more softlockups.
Message-ID: <20130710152015.GA757@x4>
References: <20130704015525.GA8486@redhat.com>
 <CA+55aFykwkTVtZuoCEvwpF+5q1LUscw1shkWNPtGdHu+1DgDJA@mail.gmail.com>
 <20130705143821.GB325@redhat.com>
 <alpine.DEB.2.02.1307051710070.32106@ionos.tec.linutronix.de>
 <20130705160043.GF325@redhat.com>
 <20130706072408.GA14865@gmail.com>
 <20130710151324.GA11309@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130710151324.GA11309@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013.07.10 at 11:13 -0400, Dave Jones wrote:
> On Sat, Jul 06, 2013 at 09:24:08AM +0200, Ingo Molnar wrote:
>  > 
>  > * Dave Jones <davej@redhat.com> wrote:
>  > 
>  > > On Fri, Jul 05, 2013 at 05:15:07PM +0200, Thomas Gleixner wrote:
>  > >  > On Fri, 5 Jul 2013, Dave Jones wrote:
>  > >  > 
>  > >  > > BUG: soft lockup - CPU#3 stuck for 23s! [trinity-child1:14565]
>  > >  > > perf samples too long (2519 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>  > >  > > INFO: NMI handler (perf_event_nmi_handler) took too long to run: 238147.002 msecs
>  > >  > 
>  > >  > So we see a softlockup of 23 seconds and the perf_event_nmi_handler
>  > >  > claims it did run 23.8 seconds.
>  > >  > 
>  > >  > Are there more instances of NMI handler messages ?
>  > > 
>  > > [ 2552.006181] perf samples too long (2511 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
>  > > [ 2552.008680] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 500392.002 msecs
>  > 
>  > Dave, could you pull in the latest perf fixes at:
>  > 
>  >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf/urgent
>  > 
>  > In particular this:
>  > 
>  >   e5302920da9e perf: Fix interrupt handler timing harness
>  > 
>  > could make a difference - if your tests somehow end up activating perf.
> 
> Something is really fucked up in the kernel side of perf.
> I get this right after booting..
> 
> [  114.516619] perf samples too long (4262 > 2500), lowering kernel.perf_event_max_sample_rate to 50000

You can disable this warning by:

echo 0 > /proc/sys/kernel/perf_cpu_time_max_percent

-- 
Markus
