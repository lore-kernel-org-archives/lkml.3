Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaLCTs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:48:57 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:47659 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbaLCTs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:48:56 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
References: <547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
	<CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
	<1417540493.21136.3@mail.thefacebook.com>
	<20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
	<CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
Date: Wed, 3 Dec 2014 11:48:55 -0800
X-Google-Sender-Auth: UhyeKo0rLfB7h6H6qb4bpgNuJGM
Message-ID: <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 11:25 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I don't know. This piece of code:
>
>         delta = clocksource_delta(wdnow, cs->wd_last, watchdog->mask);
>
> makes no sense to me.

Yeah, no, I see what's up. I missed that whole wd_last vs cs_last
pairing. I guess that part is all good. There are other crazy issues
in there, though, like the double test of 'watchdog_reset_pending'. So
I still wonder, though, since that odd 96-second delta is just insane
and makes no sense from a TSC standpoint (it's closer to a 32-bit
overflow of a hpet counter, but that sounds off too).

                 Linus
