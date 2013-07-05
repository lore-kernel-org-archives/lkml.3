Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3GEFlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 01:41:23 -0400
Received: from mout.gmx.net ([212.227.15.19]:61663 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259Ab3GEFlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 01:41:21 -0400
Message-ID: <1373002865.8318.11.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Fri, 05 Jul 2013 07:41:05 +0200
In-Reply-To: <51D64C84.5080100@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
	 <20130702085202.GA23916@twins.programming.kicks-ass.net>
	 <51D29EE5.8080307@linux.vnet.ibm.com>
	 <20130704091339.GK18898@dyad.programming.kicks-ass.net>
	 <51D5428D.7080805@linux.vnet.ibm.com>
	 <1372934013.9046.16.camel@marge.simpson.net>
	 <51D633DB.5010508@linux.vnet.ibm.com>
	 <1372997318.7315.23.camel@marge.simpson.net>
	 <51D64C84.5080100@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V03:K0:XPhS6/67pMOnoAXYxj4SuLKIX9NVenIu1yHsu6gGb5fIu9HYWvh
 RnpEmtiOWAMNvLd0EJrd8BhsCiMU7fQrJro/BWnBndXwgdZ/W9K3pep6oTXXI045gxn/od8
 kp4vSVjJ1dCqCOqQf/Nr57WZaS3DiFRyrGWtkQfvwMRmHbHxCcgLrSVLgEPXjPD3eUa0Fqu
 s89aoaENSNFxAG066TLqw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-07-05 at 12:33 +0800, Michael Wang wrote:
> On 07/05/2013 12:08 PM, Mike Galbraith wrote:
> [snip]
> >>
> >> Wow, I used to think such issue is very hard to be tracked by
> >> benchmarks, is this regression stable?
> > 
> > Yeah, seems to be.  I was curious as to why you saw an improvement to
> > hackbench, didn't seem there should be any, so though I'd try it on my
> > little box on the way to a long weekend.  The unexpected happened.
> 
> Oh, I think I failed to explain things clearly in comments...
> 
> It's not the patch who bring 15% benefit to hackbench, but the
> wake-affine stuff itself.
> 
> In the prev-test, I removed the whole stuff and find that hackbench
> dropped 15%, which means with wake-affine enabled, we will gain 15%
> benefit (and that's actually the reason why we don't kill the stuff).

Ah.

> And this idea is try to not harm that 15% benefit, and meanwhile regain
> the pgbench lost performance, thus, apply this patch to mainline won't
> improve hackbench performance, but improve pgbench performance.
> 
> But this regression is really unexpected... I could hardly believe it's
> just caused by cache issue now, since the number is not small (10% at
> most?).
> 
> Have you tried to use more loops and groups? will that show even bigger
> regressions?

Nope, less on either side.

hackbench -g 100 -l 1000
                                                                       avg
3.10.0-regress    21.895    21.564    21.777    21.958    22.093    21.857     1.000
3.10.0-regressx   22.844    23.268    23.056    23.231    22.375    22.954     1.050

hackbench -g 1 -l 100000
                                                                       avg
3.10.0-regress    29.913    29.711    30.395    30.213    30.236    30.093     1.000
3.10.0-regressx   30.392    31.003    30.728    31.008    30.389    30.704     1.020
 
> BTW, is this the results of 10 group and 40 sockets == 400 tasks?

Yeah, stock.

Off to do some body/mind tuning.  Bavarian mushrooms don't hide as well
as memory access thingies.. and I can still out run 'em.

-Mike 



