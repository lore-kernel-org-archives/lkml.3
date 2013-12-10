Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615Ab3LJVSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:18:22 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:43091 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3LJVSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:18:20 -0500
MIME-Version: 1.0
In-Reply-To: <1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<20131210203559.GA1209@redhat.com>
	<20131210204925.GB27373@redhat.com>
	<1386709583.3685.78.camel@dvhart-mobl4.amr.corp.intel.com>
Date: Tue, 10 Dec 2013 13:18:20 -0800
X-Google-Sender-Auth: cFBzo4Lmby5AsQf_o3iTQNhjsRk
Message-ID: <CA+55aFx1Eech-MXWgJkERjJPSeg_9HVyLo_8nz=saNJyNmS7Kg@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Dave Jones <davej@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 1:06 PM, Darren Hart <dvhart@linux.intel.com> wrote:
>
>    . Knowing exactly what syscall was made would
> be very useful, but I don't know if that information is even available
> anymore.

Well, the loop should be visible in the profile, since it's still active.

So doing something like

     perf record -e cycles:pp -g -a sleep 60

to get a good profile for a minute, and then looking at the
instruction-level profiles in futex_requeue() should be possible.

Of course, inlining etc often makes those rather hard to see, and the
bulk of the profile is clearly all about the lock debugging overhead,
but if the loop is in futex_requeue() then that *should* be visible in
the profile, even if it may not be anywhere near the top..

Dave?

               Linus
