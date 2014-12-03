Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaLCU4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:56:16 -0500
Received: from www.linutronix.de ([62.245.132.108]:55597 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaLCU4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:56:14 -0500
Date: Wed, 3 Dec 2014 21:55:57 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1412032141040.16275@nanos>
References: <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com> <20141201230339.GA20487@ret.masoncoding.com> <1417529606.3924.26.camel@maggy.simpson.net> <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com> <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com>
 <CA+55aFxa90b31Fvy6RkvMneY3+GTR=Nko2Sgj2mk7SSHZC7b6g@mail.gmail.com> <20141203200906.GA3118@redhat.com> <CA+55aFxLmBjTOdGu3TFzTJ-ym7TVLDBt79BKqU-vZbX4CvSGog@mail.gmail.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Linus Torvalds wrote:
> On Wed, Dec 3, 2014 at 12:09 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > fwiw, there's quite a bit of variance in the delta that seems to show up.
> 
> Yeah, anything from 1 to 251 seconds. That's definitely "quite a bit
> of variance"

But it's always negative, which means HPET is always ahead of
TSC. That excludes pretty much the clocksource watchdog starvation
issue which results in TSC being ahead of HPET due to a HPET
wraparound (which takes ~300s).

Thanks,

	tglx
