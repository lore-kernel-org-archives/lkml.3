Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaCAW5Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 17:57:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36263 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbaCAW5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 17:57:24 -0500
Message-ID: <53126581.1090407@zytor.com>
Date: Sat, 01 Mar 2014 14:56:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Stefani Seibold <stefani@seibold.net>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Subject: Re: Final: Add 32 bit VDSO time function support
References: <1393443298.1917.5.camel@wall-e.seibold.net> <20140226204524.GA1598@kroah.com> <CALCETrU+u3GMK-GaTk4gbAjyMbpQY15qNC4D9q9h2a26YfsLwA@mail.gmail.com> <CALCETrW_PHbDzn2S3NyGTSk4yqYjnpJbStCuLc_yBGdfspfFCA@mail.gmail.com> <1393572124.1019.3.camel@wall-e.seibold.net> <CALCETrUH1tZcu0upkTV0gsXtpnf-BAY4vmWKnN19=ZXsbqWT8A@mail.gmail.com>
In-Reply-To: <CALCETrUH1tZcu0upkTV0gsXtpnf-BAY4vmWKnN19=ZXsbqWT8A@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 06:00 PM, Andy Lutomirski wrote:
> 
> This leads to a potentially interesting question: is rdtsc_barrier()
> actually necessary on UP?  IIRC the point is that, if an
> rdtsc_barrier(); rdtsc in one thread is "before" (in the sense of
> being synchronized by some memory operation) an rdtsc_barrier(); rdtsc
> in another thread, then the first rdtsc needs to return an earlier or
> equal time to the second one.
> 
> I assume that no UP CPU is silly enough to execute two rdtsc
> instructions out of order relative to each other in the absence of
> barriers.  So this is a nonissue on UP.
> 
> On the other hand, suppose that some code does:
> 
> volatile long x = *(something that's not in cache)
> clock_gettime
> 
> I can imagine a modern CPU speculating far enough ahead that the rdtsc
> happens *before* the cache miss.  This won't cause visible
> non-monotonicity as far as I can see, but it might annoy people who
> try to benchmark their code.
> 
> Note: actually making this change might be a bit tricky.  I don't know
> if the alternatives code is smart enough.
> 

Let's put it this way... this is at best a third-order optimization...
let's not worry about it right now.

	-hpa


