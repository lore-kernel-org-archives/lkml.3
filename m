Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab3LJVdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:33:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48597 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976Ab3LJVdR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:33:17 -0500
Date: Tue, 10 Dec 2013 16:32:01 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Darren Hart <dvhart@linux.intel.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Subject: Re: process 'stuck' at exit.
Message-ID: <20131210213201.GF27373@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Darren Hart <dvhart@linux.intel.com>,
	Oleg Nesterov <oleg@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
References: <20131210154724.GA30020@redhat.com>
 <CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
 <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
 <20131210203559.GA1209@redhat.com>
 <20131210204925.GB27373@redhat.com>
 <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
 <CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 01:18:20PM -0800, Linus Torvalds wrote:
 > On Tue, Dec 10, 2013 at 1:06 PM, Darren Hart <dvhart@linux.intel.com> wrote:
 > >
 > >    . Knowing exactly what syscall was made would
 > > be very useful, but I don't know if that information is even available
 > > anymore.
 > 
 > Well, the loop should be visible in the profile, since it's still active.
 > 
 > So doing something like
 > 
 >      perf record -e cycles:pp -g -a sleep 60
 > 
 > to get a good profile for a minute, and then looking at the
 > instruction-level profiles in futex_requeue() should be possible.
 > 
 > Of course, inlining etc often makes those rather hard to see, and the
 > bulk of the profile is clearly all about the lock debugging overhead,
 > but if the loop is in futex_requeue() then that *should* be visible in
 > the profile, even if it may not be anywhere near the top..
 > 
 > Dave?

http://www.codemonkey.org.uk/junk/perf.data.xz

	Dave

