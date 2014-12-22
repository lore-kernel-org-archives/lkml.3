Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaLVUGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 15:06:09 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:40778 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754764AbaLVUGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 15:06:07 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
References: <20141219145528.GC13404@redhat.com>
	<CA+55aFychipT9e0DenUumsGJ-=9BUTOX-OmAmQ3azMCspUrUtw@mail.gmail.com>
	<alpine.DEB.2.11.1412192201520.17382@nanos>
	<CA+55aFx4zjAVHN5DrSCh1_MJjqf4fxoAVT3RmC+1QGP6bq7b0Q@mail.gmail.com>
	<alpine.DEB.2.11.1412200100130.17382@nanos>
	<CA+55aFxY5hCuGaK0JvTwHFsQKFGeh3_82ukKrU9ss4x4uHMY3Q@mail.gmail.com>
	<CA+55aFzj_2tYJ1b=_7eKSz7UMuUL+qZX39r0xq5vOZkB4JmHMA@mail.gmail.com>
	<CA+55aFyQzpQgT91sqpEhXho8KoVRkA1MeRjk+fXO7w2dJkY_Gg@mail.gmail.com>
	<CA+55aFy8DCMmkPRz0kqNC80pn4VkeQr2Wz2fTRm=32oH2dhfRQ@mail.gmail.com>
	<CA+55aFwA7uOFgb-Y4dHS099HuoV+oQvxXf+cfZYh9T7H_c0PHA@mail.gmail.com>
	<20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
Date: Mon, 22 Dec 2014 12:06:06 -0800
X-Google-Sender-Auth: UoLwc0VJxk0xpPsM1VRpYPfUplU
Message-ID: <CA+55aFxJrAbA_Y1nZ9MgtX4OHBQPvbcwCAA6BBrNZPBDrZhaTg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Suresh Siddha <sbsiddha@gmail.com>, Oleg Nesterov <oleg@redhat.com>,
        Peter Anvin <hpa@linux.intel.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 11:47 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> .. and we might still lock up under some circumstances. But at least
> from my limited testing, it is infinitely much better, even if it
> might not be perfect. Also note that my "testing" has been writing
> zero to the HPET lock (so the HPET clock difference tends to be pretty
> specific), while my next step is to see what happens when I write
> random values (and a lot of them).
>
> Since I expect that to cause more problems, I thought I'd send this
> RFC out before I start killing my machine again ;)

Ok, not horrible. Although I'd suggest not testing in a terminal
window while running X. The time jumping will confuse X input timing
and the screensaver, to the point that the machine may not be dead,
but it isn't exactly usable. Do it in a virtual console.

Again, making the limit tighter (one second?) and perhaps not trusting
insane values too much at walltime clock update time either, might
make it all work smoother still.

I did manage to confuse systemd with all the garbage the kernel
spewed, with a lot of stuff like:

   systemd-journald[779]: Failed to write entry (9 items, 276 bytes),
ignoring: Invalid argument

showing up in the logs, but I'm writing this without having had to
reboot the machine.

                         Linus
