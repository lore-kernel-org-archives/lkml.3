Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaL0DO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 22:14:58 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:48933 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbaL0DO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 22:14:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141227003636.GA32271@codemonkey.org.uk>
References: <CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
	<20141222225725.GA8140@codemonkey.org.uk>
	<CA+55aFzjA_KSqUJiKm5qeZEeFBdrg17doANao+8iphBvVM8boQ@mail.gmail.com>
	<20141224030125.GA8725@codemonkey.org.uk>
	<20141226163410.GA25161@codemonkey.org.uk>
	<20141226181204.GA26527@codemonkey.org.uk>
	<CA+55aFyySYFJjV5689Ej+Rer_igR0R1S5=h0GwWpWpA6Tk1Okw@mail.gmail.com>
	<20141226225744.GA30955@codemonkey.org.uk>
	<CA+55aFxu+8Ty2id7hB++BZZsr0w_-U0tVz1tm6y=OKqp5vi5Og@mail.gmail.com>
	<20141227003636.GA32271@codemonkey.org.uk>
Date: Fri, 26 Dec 2014 19:14:55 -0800
X-Google-Sender-Auth: U3oJhaVklom3odLIPhwJ8Zq_FHE
Message-ID: <CA+55aFwjM4U4oKX7Yt8gRZLUayF_vHVQ1Eemp8Pi5c=Z0S2cSA@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@codemonkey.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
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

On Fri, Dec 26, 2014 at 4:36 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
>  >
>  > Oh - and have you actually seen the "TSC unstable (delta = xyz)" +
>  > "switched to hpet" messages there yet?
>
> not yet. 3 hrs in.

Ok, so then the

     INFO: rcu_preempt detected stalls on CPUs/tasks:

has nothing to do with HPET, since you'd still be running with the TSC enabled.

My googling around did find a number of "machine locks up a few hours
after switching to hpet" reports, so it is possible that the whole rcu
stall and nmi watchdog thing is independent and unrelated to the
actual locking up.

It *is* intriguing that my broken patch seemed to prevent it from
happening, though. And both NMI watchdogs and the rcu stall are
related to wall-clock time.  But hey, maybe there really is some odd
loop in the kernel that stops scheduling or RCU grace periods. It just
seems to be never caught by your backtraces..

             Linus
