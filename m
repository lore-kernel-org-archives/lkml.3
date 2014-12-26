Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751609AbaLZXQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2014 18:16:43 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:37558 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaLZXQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2014 18:16:42 -0500
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
Date: Fri, 26 Dec 2014 15:16:41 -0800
X-Google-Sender-Auth: 2TAWgwgK8-1mR88GEj9ud3OTDIs
Message-ID: <CA+55aFxu+8Ty2id7hB++BZZsr0w_-U0tVz1tm6y=OKqp5vi5Og@mail.gmail.com>
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
> hm.

So with the previous patch that had the false positives, you never saw
this? You saw the false positives instead?

I'm wondering if the added debug noise just ended up helping. Doing a
printk() will automatically cause some scheduler activity. And they
also caused the time reading jiggle.

That said, it's also possible that I screwed something up in the
second version of the patch, just breaking it and making it generally
ineffective.

Oh - and have you actually seen the "TSC unstable (delta = xyz)" +
"switched to hpet" messages there yet?

                         Linus
