Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751649AbaLZXaX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:30:23 -0500
Received: from mail-qg0-f43.google.com ([209.85.192.43]:50567 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845AbaLZXaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:30:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141226225744.GA30955@codemonkey.org.uk>
References: <20141221223204.GA9618@codemonkey.org.uk>
	<CA+55aFygv+PRcYScwCjGVQ7-0PA1mHOGYaKGKS4LBhxPm0YBJA@mail.gmail.com>
	<CA+55aFwaghUQxp9LJRWH6ANCX5y45c3Fu9T0OnpBaqRdn1=tvw@mail.gmail.com>
	<CA+55aFz0n=sJgn5LeBLcTzj9=eCVkrWiQZNCKupuD7CMTwm=jQ@mail.gmail.com>
	<20141222225725.GA8140@codemonkey.org.uk>
	<CA+55aFzjA_KSqUJiKm5qeZEeFBdrg17doANao+8iphBvVM8boQ@mail.gmail.com>
	<20141224030125.GA8725@codemonkey.org.uk>
	<20141226163410.GA25161@codemonkey.org.uk>
	<20141226181204.GA26527@codemonkey.org.uk>
	<CA+55aFyySYFJjV5689Ej+Rer_igR0R1S5=h0GwWpWpA6Tk1Okw@mail.gmail.com>
	<20141226225744.GA30955@codemonkey.org.uk>
Date: Fri, 26 Dec 2014 15:30:20 -0800
X-Google-Sender-Auth: 30EuQrtyuiIBFH4Cc-T3Q7aJA2g
Message-ID: <CA+55aFxOWzJxUAENR3=SpbEzQ5sHQRvP=onK7MzLjO5HTWVXjQ@mail.gmail.com>
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

On Fri, Dec 26, 2014 at 2:57 PM, Dave Jones <davej@codemonkey.org.uk> wrote:
>
> still running though..

Btw, did you ever boot with "tsc=reliable" as a kernel command line option?

For the last night, can you see if you can just run it with that, and
things work? Because by now, my gut feel is that we should start
derating the HPET rather than the TSC, especially going forward on
modern hardware. And if this is some subtle timing issue with our hpet
code (the whole -ETIME thing when getting close to setting a timer is
subtle, for example, even if the HPET hardware itself would be ok),
I'm wondering if the fix isn't to just stop believing in HPET if there
are better alternatives around.

So I'm not even convinced that trying to debug some HPET issue is
really worth it. Especially if your machine is a preproduction board
from Intel.

But verifying that with just the TSC everything is ok might still be worth it.

                       Linus
