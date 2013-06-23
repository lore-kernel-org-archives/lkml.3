Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154Ab3FWXdq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 19:33:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:57898 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891Ab3FWXdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 19:33:45 -0400
Message-ID: <1372030320.3944.114.camel@pasglop>
Subject: Re: power-efficient scheduling design
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        David Lang <david@lang.hm>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "peterz@infradead.org" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "efault@gmx.de" <efault@gmx.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "pjt@google.com" <pjt@google.com>, Ingo Molnar <mingo@kernel.org>
Date: Mon, 24 Jun 2013 09:32:00 +1000
In-Reply-To: <51C4C6C8.1050008@linux.intel.com>
References: <20130530134718.GB32728@e103034-lin>
	 <20130531105204.GE30394@gmail.com> <20130614160522.GG32728@e103034-lin>
	 <51C07ABC.2080704@linux.intel.com>
	 <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
	 <51C1D0BB.3040705@linux.intel.com> <20130619170042.GH5460@e103034-lin>
	 <51C1E58D.9000408@linux.intel.com> <20130621085002.GJ5460@e103034-lin>
	 <51C47377.2000208@linux.intel.com>
	 <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>
	 <51C4C6C8.1050008@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-21 at 14:34 -0700, Arjan van de Ven wrote:
> On 6/21/2013 2:23 PM, Catalin Marinas wrote:
> >>
> >> oops sorry I misread your mail (lack of early coffee I suppose)
> >>
> >> I can see your point of having a thing for "did we ask for all the performance
> >> we could ask for" prior to doing a load balance (although, for power efficiency,
> >> if you have two tasks that could run in parallel, it's usually better to
> >> run them in parallel... so likely we should balance anyway)
> >
> > Not necessarily, especially if parallel running implies powering up a
> > full cluster just for one CPU (it depends on the hardware but for
> > example a cluster may not be able to go in deeper sleep states unless
> > all the CPUs in that cluster are idle).
> 
> I guess it depends on the system

Sort-of. We have something similar with threads on ppc. IE, the core can
only really stop if all threads are. From a Linux persepctive it's a
matter of how we define the scope of that 'cluster' Catalin is talking
about. I'm sure you do too.

Then there is the package, which adds MC etc...

> the very first cpu needs to power on
> * the core itself
> * the "cluster" that you mention
> * the memory controller
> * the memory (out of self refresh)
> 
> while the second cpu needs
> * the core itself
> * maybe a second cluster
> 
> normally on Intel systems, the memory power delta is quite significant
> which then means the efficiency of the second core is huge compared to
> running things in sequence.

What's your typical latency for bringing an MC back (and memory out of
self refresh) ? IE. Basically bringing a package back up ?

Cheers,
Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


