Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbaBKUhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 15:37:10 -0500
Received: from gate.crashing.org ([63.228.1.57]:57218 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754364AbaBKUhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 15:37:07 -0500
Message-ID: <1392147268.3835.11.camel@pasglop>
Subject: Re: [PATCH v2] powerpc ticket locks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Torsten Duwe <duwe@lst.de>,
        Raghavendra KT <raghavendra.kt.linux@gmail.com>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Tom Musta <tommusta@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linuxppc-dev@lists.ozlabs.org,
        Raghavendra KT <raghavendra.kt@linux.vnet.ibm.com>
Date: Wed, 12 Feb 2014 06:34:28 +1100
In-Reply-To: <1392143455.6733.386.camel@snotra.buserror.net>
References: <20140207165801.GC2107@lst.de>
	 <1392001823.3996.21.camel@pasglop>
	 <CAC4Lta2Pssu5QY_QLmy5C3Fm2G3fwpiuc5BNOLBnQTmmRH+W4Q@mail.gmail.com>
	 <20140211104030.GG2107@lst.de>
	 <1392143455.6733.386.camel@snotra.buserror.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-11 at 12:30 -0600, Scott Wood wrote:
> > It's something very special to IBM pSeries: the hypervisor can assign
> > fractions of physical CPUs to guests. Sometimes a guest with 4 quarter
> > CPUs will be faster than 1 monoprocessor. (correct me if I'm wrong).
> > 
> > The directed yield resolves the silly situation when holder and waiter
> > reside on the same physical CPU, as I understand it.
> > 
> > x86 has nothing comparable.
> 
> How is this different from the very ordinary case of an SMP KVM guest
> whose vcpus are not bound to host cpus, and thus you could have multiple
> vcpus running on the same host cpu?

It's not really ... though I can see drawbacks with the scheme as well
and I think in KVM we should be careful to only confer if the owner
vcpu last scheduled on the same physical cpu where the waiter is, other
wise, there's too much chances of us bouncing things around the machine
for minor contention cases.

Paul, what's your policy today ?

Cheers,
Ben.


