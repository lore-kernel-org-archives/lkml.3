Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751635AbaCBIBr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 03:01:47 -0500
Received: from www84.your-server.de ([213.133.104.84]:44667 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaCBIBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 03:01:43 -0500
Message-ID: <1393747272.995.11.camel@wall-e.seibold.net>
Subject: Re: Final: Add 32 bit VDSO time function support
From: Stefani Seibold <stefani@seibold.net>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Sun, 02 Mar 2014 09:01:12 +0100
In-Reply-To: <53126581.1090407@zytor.com>
References: <1393443298.1917.5.camel@wall-e.seibold.net>
	 <20140226204524.GA1598@kroah.com>
	 <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com>
	 <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com>
	 <1393572124.1019.3.camel@wall-e.seibold.net>
	 <CALCETrUH1tZcu0upkTV0gsXtpnf-BAY4vmWKnN19=ZXsbqWT8A@mail.gmail.com>
	 <53126581.1090407@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, den 01.03.2014, 14:56 -0800 schrieb H. Peter Anvin:
> On 02/28/2014 06:00 PM, Andy Lutomirski wrote:
> > 
> > This leads to a potentially interesting question: is rdtsc_barrier()
> > actually necessary on UP?  IIRC the point is that, if an
> > rdtsc_barrier(); rdtsc in one thread is "before" (in the sense of
> > being synchronized by some memory operation) an rdtsc_barrier(); rdtsc
> > in another thread, then the first rdtsc needs to return an earlier or
> > equal time to the second one.
> > 
> > I assume that no UP CPU is silly enough to execute two rdtsc
> > instructions out of order relative to each other in the absence of
> > barriers.  So this is a nonissue on UP.
> > 
> > On the other hand, suppose that some code does:
> > 
> > volatile long x = *(something that's not in cache)
> > clock_gettime
> > 
> > I can imagine a modern CPU speculating far enough ahead that the rdtsc
> > happens *before* the cache miss.  This won't cause visible
> > non-monotonicity as far as I can see, but it might annoy people who
> > try to benchmark their code.
> > 
> > Note: actually making this change might be a bit tricky.  I don't know
> > if the alternatives code is smart enough.
> > 
> 
> Let's put it this way... this is at best a third-order optimization...
> let's not worry about it right now.
> 

IMHO it is the behaviour that most developer expect. It would a bad idea
to get a time value before the previous operations are not finished. In
some use case this will result in a fail.

Imagine a HW where two designated register can only consecutively
accessed after a given time period is elapsed. This would be normally
done by a busy loop for very short periods. It would be okay when the
time period to wait is exceeded, but will maybe fail when the wait time
is to short.

- Stefani


