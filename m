Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3FXTzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 15:55:54 -0400
Received: from www.linutronix.de ([62.245.132.108]:51541 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab3FXTzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 15:55:53 -0400
Date: Mon, 24 Jun 2013 21:55:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Vrabel <david.vrabel@citrix.com>
cc: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/4] time: add a notifier chain for when the system time
 is stepped
In-Reply-To: <51C87B26.3010904@citrix.com>
Message-ID: <alpine.DEB.2.02.1306242153330.4013@ionos.tec.linutronix.de>
References: <1371755792-25962-1-git-send-email-david.vrabel@citrix.com> <1371755792-25962-3-git-send-email-david.vrabel@citrix.com> <alpine.DEB.2.02.1306210953480.4013@ionos.tec.linutronix.de> <51C44A09.9010402@citrix.com> <alpine.DEB.2.02.1306212328350.4013@ionos.tec.linutronix.de>
 <51C824A8.1080305@citrix.com> <alpine.DEB.2.02.1306241753080.4013@ionos.tec.linutronix.de> <51C87B26.3010904@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jun 2013, David Vrabel wrote:

> On 24/06/13 17:30, Thomas Gleixner wrote:
> > 
> > We already have a synchronous notifier in place and the notifier call
> > itself is not expensive. What's expensive is the hypercall and there
> > is no way at the moment to figure out whether the update is relevant
> > for you or just a tick. Though that's trivial information to provide
> > without imposing another notifier including the surrounding mess on
> > the core code.
> 
> This looks good, thanks.
> 
> > --- a/kernel/time/timekeeping.c
> > +++ b/kernel/time/timekeeping.c
> [...]
> > @@ -508,7 +509,7 @@ int do_settimeofday(const struct timespec *tv)
> >  
> >  	tk_set_xtime(tk, tv);
> >  
> > -	timekeeping_update(tk, true, true);
> > +	timekeeping_update(tk, true, true, true);
> 
> These three booleans in a row is getting a bit opaque. How about I also
> change it to a set of flags?  e.g.,
> 
> timekeeping_updated(tk, TK_CLEAR_NTP | TK_MIRROR | TK_CLOCK_WAS_SET);

Fair enough. Can you convert the existing booleans first and then put
the CLOCK_WAS_SET patch on top of that?

Thanks,

	tglx

