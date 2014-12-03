Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbaLCUKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:10:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbaLCUKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:10:00 -0500
Date: Wed, 3 Dec 2014 15:09:06 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203200906.GA3118@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	John Stultz <john.stultz@linaro.org>
References: <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
 <20141203190045.GB32005@redhat.com>
 <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
 <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 11:48:55AM -0800, Linus Torvalds wrote:
 > On Wed, Dec 3, 2014 at 11:25 AM, Linus Torvalds
 > <torvalds@linux-foundation.org> wrote:
 > >
 > > I don't know. This piece of code:
 > >
 > >         delta = clocksource_delta(wdnow, cs->wd_last, watchdog->mask);
 > >
 > > makes no sense to me.
 > 
 > Yeah, no, I see what's up. I missed that whole wd_last vs cs_last
 > pairing. I guess that part is all good. There are other crazy issues
 > in there, though, like the double test of 'watchdog_reset_pending'. So
 > I still wonder, though, since that odd 96-second delta is just insane
 > and makes no sense from a TSC standpoint (it's closer to a 32-bit
 > overflow of a hpet counter, but that sounds off too).

fwiw, there's quite a bit of variance in the delta that seems to show up.

Clocksource tsc unstable (delta = -1010986453 ns) 
Clocksource tsc unstable (delta = -112130224777 ns) 
Clocksource tsc unstable (delta = -154880389323 ns) 
Clocksource tsc unstable (delta = -165033940543 ns) 
Clocksource tsc unstable (delta = -16610147135 ns) 
Clocksource tsc unstable (delta = -169783264218 ns) 
Clocksource tsc unstable (delta = -183044061613 ns) 
Clocksource tsc unstable (delta = -188697049603 ns) 
Clocksource tsc unstable (delta = -190100649573 ns) 
Clocksource tsc unstable (delta = -192732788150 ns) 
Clocksource tsc unstable (delta = -211622574067 ns) 
Clocksource tsc unstable (delta = -219378634234 ns) 
Clocksource tsc unstable (delta = -226609871873 ns) 
Clocksource tsc unstable (delta = -228355467642 ns) 
Clocksource tsc unstable (delta = -233950238702 ns) 
Clocksource tsc unstable (delta = -243666538341 ns) 
Clocksource tsc unstable (delta = -251535074315 ns) 
Clocksource tsc unstable (delta = -26880030622 ns) 
Clocksource tsc unstable (delta = -37899993747 ns) 
Clocksource tsc unstable (delta = -50471031780 ns) 
Clocksource tsc unstable (delta = -6821168015 ns) 
Clocksource tsc unstable (delta = -7067883139 ns)
Clocksource tsc unstable (delta = -76682050692 ns) 
Clocksource tsc unstable (delta = -8296489689 ns) 
Clocksource tsc unstable (delta = -88373866635 ns) 
Clocksource tsc unstable (delta = -89099193219 ns) 
Clocksource tsc unstable (delta = -95946009388 ns) 


(sort -u'ed post grep, the ordering here doesn't mean anything)

	Dave
