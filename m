Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaEESHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 14:07:50 -0400
Received: from www.linutronix.de ([62.245.132.108]:57031 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaEESHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 14:07:48 -0400
Date: Mon, 5 May 2014 20:08:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>, peterz@infradead.org,
        davidlohr@hp.com, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [3.15-rc3] rtmutex-debug assertion.
In-Reply-To: <20140502045640.GA27264@redhat.com>
Message-ID: <alpine.DEB.2.02.1405052002360.6261@ionos.tec.linutronix.de>
References: <20140429151655.GA14277@redhat.com> <20140430001432.GA32142@redhat.com> <alpine.DEB.2.02.1404301113110.6261@ionos.tec.linutronix.de> <20140502045640.GA27264@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;3202;0cOn Fri, 2 May 2014, Dave Jones wrote:
> On Wed, Apr 30, 2014 at 11:13:57AM +0200, Thomas Gleixner wrote:
>  > On Tue, 29 Apr 2014, Dave Jones wrote:
>  > > This is trickier to reproduce than it first seemed, as logging slows
>  > > things down so much.  But after a few hours, it logged that the
>  > > call that triggered this was..
>  > > 
>  > > futex(uaddr=0x7f55ff8c4000, op=0x6, val=0x200000006223800b, utime=0x7f55ff8c4000, uaddr2=0x7f55ff8c4000, val3=-123)
>  > > 
>  > > Those addresses come from an mmap we made on startup..
>  > > 
>  > > [init] mapping[3]: (zeropage PROT_READ | PROT_WRITE) 0x7f55ff8c4000 (1MB)
>  > > 
>  > > op = FUTEX_LOCK_PI
>  > > 
>  > > val seems to be garbage.
>  > > 
>  > > I'll do another run, just to see if it's always the same set of values,
>  > > but it's going to probably take an overnight run.
>  > 
>  > Do you have the full fuzzing log, so I can see what happened
>  > before/around that?
> 
> This is tough, because it takes a long time to reproduce when the
> logging is enabled, and that ends up generating a lot of output.
> I've tried to cut it down some using just 4 threads, but that's
> still over 30M of logs.
> http://www.codemonkey.org.uk/junk/futex.tar.xz
> 
> In this run, child0 was the pid that faulted.
> You can see the last line in trinity-child0.log has a similar
> fingerprint to the trace above.
> 
> One thing that does look suspicious, is that all 4 threads were doing
> op=0x6 right before the kernel went south.
> 
> Hope this helps.

I twisted my brain around that for a fricking long time, but I really
can't see the failure in the code.

Neither did I succeed to trigger the issue in a VM (with and without
function tracing) on Linus latest.

I grabbed trinity source and did:

# ./trinity -l off -c futex -q

That should be enough, right?

All I see in dmesg are occasional ooms which kill random trinity
childs. 

I ran that stuff for almost two days now with a total of 629656086
syscalls. :(

Thanks,

	tglx
