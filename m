Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FXKKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 06:10:30 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:58714 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751916Ab3FXKK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 06:10:29 -0400
Date: Mon, 24 Jun 2013 11:07:32 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
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
Subject: Re: power-efficient scheduling design
Message-ID: <20130624100732.GB14982@arm.com>
References: <51C07ABC.2080704@linux.intel.com>
 <alpine.DEB.2.02.1306181039340.9258@nftneq.ynat.uz>
 <51C1D0BB.3040705@linux.intel.com>
 <20130619170042.GH5460@e103034-lin>
 <51C1E58D.9000408@linux.intel.com>
 <20130621085002.GJ5460@e103034-lin>
 <51C47377.2000208@linux.intel.com>
 <CAHkRjk5G7XJxzjcWa4BqRxz0AtAAh_-Eomzk4+dQRaFk1=HQqA@mail.gmail.com>
 <51C4C6C8.1050008@linux.intel.com>
 <1372030320.3944.114.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372030320.3944.114.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 12:32:00AM +0100, Benjamin Herrenschmidt wrote:
> On Fri, 2013-06-21 at 14:34 -0700, Arjan van de Ven wrote:
> > On 6/21/2013 2:23 PM, Catalin Marinas wrote:
> > >>
> > >> oops sorry I misread your mail (lack of early coffee I suppose)
> > >>
> > >> I can see your point of having a thing for "did we ask for all the performance
> > >> we could ask for" prior to doing a load balance (although, for power efficiency,
> > >> if you have two tasks that could run in parallel, it's usually better to
> > >> run them in parallel... so likely we should balance anyway)
> > >
> > > Not necessarily, especially if parallel running implies powering up a
> > > full cluster just for one CPU (it depends on the hardware but for
> > > example a cluster may not be able to go in deeper sleep states unless
> > > all the CPUs in that cluster are idle).
> > 
> > I guess it depends on the system
> 
> Sort-of. We have something similar with threads on ppc. IE, the core can
> only really stop if all threads are. From a Linux persepctive it's a
> matter of how we define the scope of that 'cluster' Catalin is talking
> about. I'm sure you do too.
> 
> Then there is the package, which adds MC etc...

I think we can say cluster == package so that we use some common
terminology. On a big.little configuration (TC2), we have 3xA7 in one
package and 2xA15 in the other. So to efficiently stop an entire package
(cluster, multi-core etc.) we need to stop all the CPUs it has.

-- 
Catalin
