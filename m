Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbaLCU7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:59:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:55615 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaLCU7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:59:37 -0500
Date: Wed, 3 Dec 2014 21:59:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dave Jones <davej@redhat.com>
cc: John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?ISO-8859-15?Q?D=E2niel_Fraga?= <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
In-Reply-To: <20141203204439.GA5019@redhat.com>
Message-ID: <alpine.DEB.2.11.1412032156210.16275@nanos>
References: <20141201230339.GA20487@ret.masoncoding.com> <1417529606.3924.26.camel@maggy.simpson.net> <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com> <1417540493.21136.3@mail.thefacebook.com> <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com> <20141203190045.GB32005@redhat.com> <CA+55aFxoBqHtSi3VyoTDrB_v8KA94HyLcn5Sfkma-r9mZ-xzjA@mail.gmail.com> <CANcMJZA1NXUMLEveA2k5njFnWc1pCSwSeAOQH7VQCOR-QtiR8g@mail.gmail.com>
 <alpine.DEB.2.11.1412032126130.16275@nanos> <20141203204439.GA5019@redhat.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Dec 2014, Dave Jones wrote:
> On Wed, Dec 03, 2014 at 09:37:10PM +0100, Thomas Gleixner wrote:
>  
>  > Right, that resulted in a delta > 0. I have no idea how we could
>  > create a negative delta via wrapping the HPET around, i.e. HPET being
>  > 96 seconds ahead of TSC.
>  > 
>  > This looks more like a genuine TSC wreckage. So we have these possible
>  > causes:
>  > 
>  >    1) SMI
>  > 
>  >    2) Power states
>  > 
>  >    3) Writing to the wrong MSR
>  > 
>  > So I assume that 1/2 are a non issue. They should surface in normal
>  > non fuzzed operation as well.
>  > 
>  > Dave, does that TSC unstable thing always happen AFTER you started
>  > fuzzing? If yes, what is the fuzzer doing this time?
> 
> I've seen it even after doing just a kernel build sometimes, It's
> happened so regularly I've just assumed "the tsc is crap on this box".
> 
> On occasion I even see it shortly after boot, while idle.

Can you please provide the cpuinfo flags of that box?

Thanks,

	tglx
