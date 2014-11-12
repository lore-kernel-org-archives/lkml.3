Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbaKLPHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 10:07:16 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:35221 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbaKLPHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 10:07:14 -0500
Date: Wed, 12 Nov 2014 16:06:51 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>
Subject: Re: Future of NOHZ full/isolation development (was Re: [NOHZ] Remove
 scheduler_tick_max_deferment)
Message-ID: <20141112150651.GF21343@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
 <alpine.DEB.2.11.1411012313320.5308@nanos>
 <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
 <20141110153147.GK4901@linux.vnet.ibm.com>
 <alpine.DEB.2.11.1411101226310.12918@gentwo.org>
 <20141111171526.GC3216@lerouge>
 <CAKohpok3U_8zQurs219fOmwERFrnZ0sOE-YUc7B+fKYfFLmEpg@mail.gmail.com>
 <20141112135455.GA6895@lerouge>
 <CAKohpo=U7K==YMytwcGwteTXdf1RFdxo8BoDhfR-9AriL83D8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpo=U7K==YMytwcGwteTXdf1RFdxo8BoDhfR-9AriL83D8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 08:26:05PM +0530, Viresh Kumar wrote:
> On 12 November 2014 19:24, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > I'd rather leave that to tracepoints. Like trace_hrtimer_spurious().
> 
> Yeah, it was just to prove things right on the console without getting
> into traces.
> 
> > Or better yet: have trace_hrtimer_interrupt() which we can compare against
> > trace_hrtimer_expire_entry/exit() to check if any hrtimer callback have run
> > in the interrupt. This way we avoid workarounds like the above count.
> 
> Yeah, I also believe we better add this debug information to mainline kernel.
> I will try to get a patch for that soon.
> 
> Would it be recommended to add both trace points?
> i.e. trace_hrtimer_interrupt() and trace_hrtimer_spurious() 

I don't think you need to add anything. We already have tracepoints for
every single interrupt (and therefore also for the hrtimer one) and we
have expiry tracepoints.


