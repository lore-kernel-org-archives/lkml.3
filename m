Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3D1Tx0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 15:53:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:53874 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756344Ab3D1TxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 15:53:25 -0400
Date: Sun, 28 Apr 2013 21:53:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Borislav Petkov <bp@alien8.de>
cc: vitalif@yourcmc.ru, Ben Hutchings <ben@decadent.org.uk>,
        "Venkatesh Pallipadi (Venki)" <venki@google.com>,
        700333@bugs.debian.org, LKML <linux-kernel@vger.kernel.org>,
        Clemens Ladisch <clemens@ladisch.de>
Subject: Re: Bug#700333: Stack trace
In-Reply-To: <20130428190541.GA2301@pd.tnic>
Message-ID: <alpine.LFD.2.02.1304282152220.21884@ionos>
References: <1362536476.3768.416.camel@deadeye.wl.decadent.org.uk> <15ec7b46ebd929a67caea0d80b324af9@yourcmc.ru> <1362971451.3937.29.camel@deadeye.wl.decadent.org.uk> <cc9020446ea75ed733ec96c505039f2a@yourcmc.ru> <20130420225516.GB4649@pd.tnic>
 <alpine.LFD.2.02.1304221409420.21884@ionos> <alpine.LFD.2.02.1304251139340.21884@ionos> <2666050d6d50efdbfa3503aa10c0e5ec@yourcmc.ru> <20130427154956.GC4358@pd.tnic> <925b81fa055e645546ae9d237eeb2ef4@yourcmc.ru> <20130428190541.GA2301@pd.tnic>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Apr 2013, Borislav Petkov wrote:

> On Sun, Apr 28, 2013 at 05:26:07PM +0400, vitalif@yourcmc.ru wrote:
> > >When you do a suspend/resume cycle.
> > 
> > OK, yes, I've found it there.
> > 
> > >The bug says "The photo shows a BUG in hrtimer_interrupt() after
> > >making
> > >the hibernation image and while resuming the non-boot CPUs." so I'm
> > >guessing with Thomas' patch it suspends fine now?
> > 
> > Yeah, now I'm using a patched kernel and it's OK.
> > 
> > So, does it mean the problem is fixed by this patch or it's just
> > confirmed and should be fixed by another one?
> 
> Well, it makes sense to me, at least: we remove the handler on suspend
> so that the HPET interrupt doesn't fire. If, when the box comes up
> again, the pending interrupt is cleared, then all is fine - we can
> safely register the handler again and everyone goes about their merry
> way.
> 
> But don't worry, if Thomas has an idea, it is almost guaranteed you'll
> get a proper fix soon. :-)

I merged a slightly better fix, you all were on cc. It's going into
3.10 and it's tagged stable, so it will show up in stable kernels
soon.

Thanks,

	tglx
