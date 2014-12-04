Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382AbaLDAT7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:19:59 -0500
Received: from mail-qg0-f48.google.com ([209.85.192.48]:40912 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaLDAT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:19:58 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1412040043170.16275@nanos>
References: <20141203184111.GA32005@redhat.com>
	<CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
	<20141203190045.GB32005@redhat.com>
	<CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
	<CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com>
	<20141203200906.GA3118@redhat.com>
	<CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
	<alpine.DEB.2.11.1412032141040.16275@nanos>
	<CA+55aFw8L06BxpsVnbdiNaU2WSFo=tafND25uV_SHUig=CC1AA@mail.gmail.com>
	<alpine.DEB.2.11.1412032249050.16275@nanos>
	<20141203232115.GA13266@redhat.com>
	<alpine.DEB.2.11.1412040043170.16275@nanos>
Date: Wed, 3 Dec 2014 16:19:57 -0800
X-Google-Sender-Auth: ckz90y2cEoeGRTg_butIpjBaGvw
Message-ID: <CA+55aFyaRByi2NLb7YZ_jHnHc6VTb-Ht748ZVVfa-XC7sdqL-g@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 3:49 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Bah. Would have been too simple ....

I do think you tend to trust the hpet too much.

Yes, we've had issues with people doing bad things to the tsc, but on
the whole I really would tend to trust the internal CPU counter a
_lot_ more than the external hpet.

So I think it's equally (if not more) likely that switching from tsc
to hpet causes trouble, because I'd trust the tsc more than the hpet.

DaveJ, do this:

> Could you please run Ingos time-warp test on that machine for a while?

but perhaps also boot with "tsc=reliable", which _should_ get rid of
that CLOCK_SOURCE_MUST_VERIFY, and the clocksource watchdog should do
nothing.

Thomas? Am I misreading that?

              Linus
