Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaH2BJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 21:09:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:43426 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaH2BJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 21:09:42 -0400
Date: Fri, 29 Aug 2014 03:09:34 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Peter Zijlstra <peterz@infradead.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>, Aubrey Li <aubrey.li@intel.com>
Subject: Re: [PATCH 0/5 v3] irq / PM: Suspend-to-idle wakeup interrupts
In-Reply-To: <14849230.M7591XGLg0@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408290256020.23342@nanos>
References: <26580319.OZP7jvJnA9@vostro.rjw.lan> <5320472.coYotHR1d0@vostro.rjw.lan> <alpine.DEB.2.10.1408282355350.23342@nanos> <14849230.M7591XGLg0@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2014, Rafael J. Wysocki wrote:
> On Friday, August 29, 2014 12:44:11 AM Thomas Gleixner wrote:
> > So really, I'm too lazy to walk through that mess further. I bet NONE
> > of the usage sites except those for which this has been introduced in
> > the first place has a real good reason to do so.
> 
> A quite similar conclusion occured to me earlier today independently,
> so we seem to be in agreement here. :-)

I appreciate that!
 
> > Unless someone comes up with a use case where a shared NO_SUSPEND
> > handler is absolutely required, there is nothing which needs to be
> > addressed. You've proven yourself, that the wake mechanism is
> > sufficient to solve the problem which led to this discussion.
> 
> Yeah, that particular thing can be perfectly addressed without using
> IRQF_NO_SUSPEND.
> 
> There seems to be quite some confusion about that in the ARM world,
> though, as IRQF_NO_SUSPEND things *happen* to wake the system up if WFI is
> used to emulate "suspend" and that appears to make people believe that using
> them for this purpose is actually fine (because that appears to work).

Well, the problem in the ARM world is still the same as we had 10
years ago, just a bit different. While 10 years ago, the "make it work
for me" attitude was hidden in some vendor tree and stayed there
forever, today its still the same "make it work for me" thing which
gets applied to the vendor tree (they still sport 1000+ patches
despite all efforts) and then trickles into the mainline w/o much
review to fulfil the "we need to be mainline" mantra.
 
> That said I was not involved in the introduction of IRQF_EARLY_RESUME (or
> at least I can't recall being involved) and I also can't recall having used
> it for anything, so I can't really say what the original motivation was.

It was solely introduced to solve an oddball issue with the XEN "IPIs"
and I take the blame for not documenting it proper. Though I really
have a hard time to understand why random drivers use this w/o comment
and for no obvious reason. "Works for me" looks like a reasonable
explanation.

I've uploaded an incomplete and completely untested patch series to
handle this stuff to: https://tglx.de/~tglx/patches.tar

Feel free to pick it up and work from there.

Thanks,

	tglx
