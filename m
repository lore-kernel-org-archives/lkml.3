Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362AbaLDAWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:22:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751106AbaLDAW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:22:29 -0500
Date: Wed, 3 Dec 2014 19:20:44 -0500
From: Dave Jones <davej@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141204002044.GA15239@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	John Stultz <john.stultz@linaro.org>
References: <20141203190045.GB32005@redhat.com>
 <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
 <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
 <20141203200906.GA3118@redhat.com>
 <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
 <alpine.DEB.2.11.1412032141040.16275@nanos>
 <CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com>
 <alpine.DEB.2.11.1412032249050.16275@nanos>
 <20141203232115.GA13266@redhat.com>
 <alpine.DEB.2.11.1412040043170.16275@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1412040043170.16275@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2014 at 12:49:29AM +0100, Thomas Gleixner wrote:

 > > I just got 
 > > 
 > > [ 1472.614433] Clocksource tsc unstable (delta = -26373048906 ns)
 > > 
 > > without any sign of the pr_err above.
 > 
 > Bah. Would have been too simple ....
 > 
 > Could you please run Ingos time-warp test on that machine for a while?
 > 
 >    http://people.redhat.com/mingo/time-warp-test/time-warp-test.c
 > 
 > Please change:
 > 
 > - #define TEST_CLOCK 0
 > + #define TEST_CLOCK 1

Seems to be 32-bit only, so I built it with -m32. I assume that's ok?

Also, should I run it in isolation, with nothing else going on,
or under load where I see problems ?

	Dave
