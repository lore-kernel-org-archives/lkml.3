Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab3LJUnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:43:47 -0500
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52526 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3LJUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:43:46 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1312102130580.28330@ionos.tec.linutronix.de>
References: <20131210154724.GA30020@redhat.com>
	<CA+55aFxgFAfcQKDoDhmJcCRb5pfxumxJ9OmpUhhNzs+CY_Yqqw@mail.gmail.com>
	<alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	<CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	<alpine.DEB.2.02.1312102130580.28330@ionos.tec.linutronix.de>
Date: Tue, 10 Dec 2013 12:43:45 -0800
X-Google-Sender-Auth: KwGV_Zlbn_C24UtuM87AJcVwfu0
Message-ID: <CA+55aFx3UkrX5Q5kL7mWOoEwd+cr3mTjmsZBw-ZRZ-OsU3i4pg@mail.gmail.com>
Subject: Re: process 'stuck' at exit.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 12:33 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> The -EAGAIN is when the user value changed, simplified:

No it's not.

Thomas, stop this crap already. Look at the f*cking code carefully
instead of just dismissing cases.

The worrisome EAGAIN case is

  futex_requeue
    futex_proxy_trylock_atomic
      futex_lock_pi_atomic
        lookup_pi_state:
          ret = (p->flags & PF_EXITPIDONE) ? -ESRCH : -EAGAIN;

and now futex_requeue() will do "goto repeat" for that EAGAIN case.

So, Christ, Thomas, you have now *twice* dismissed a real concern with
totally bogus "that can never happen" by explaining some totally
unrelated *simple* case rather than the much more complex case.

So please. Really. Truly look at the code and thing about it, or shut
the f*ck up. No more of this shit where you glance at the code, find
some simple case, and say "that can't happen", and dismiss the
bug-report.

So far Dave's bug-reports have generally pretty much universally shown
real bugs. Being dismissive about it is not helpful, quite the
reverse.

Maybe the loop I'm pointing at cannot happen, but *your* explanation
for why it couldn't happen was pure and utter garbage, and was clearly
because you hadn't even bothered to look at all the cases.

                Linus
