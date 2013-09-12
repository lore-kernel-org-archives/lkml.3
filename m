Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3ILSqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:46:06 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:50748 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608Ab3ILSqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:46:03 -0400
Date: Thu, 12 Sep 2013 20:45:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130912184557.GC25386@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
 <20130911220228.GB15367@somewhere>
 <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
 <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <0000014112cd3565-3372fafc-390c-4d71-806a-348b4f4e5d71-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014112cd3565-3372fafc-390c-4d71-806a-348b4f4e5d71-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 03:32:20PM +0000, Christoph Lameter wrote:
> On Thu, 12 Sep 2013, Frederic Weisbecker wrote:
> 
> > > Yea but the kernel option makes it easy. No extras needed. Kernel brings
> > > it up user space cleanly configured and ready to go.
> >
> > Ok but really that's just two lines of bash. I really wish we don't complicate
> > core kernel code for that.
> 
> Thread placement is an issue in general for the future. The more hardware
> threads we get the more aware of thread placement we need to become
> because caches become more important for performance. Disturbing the cache
> of another is significant. So it moving a thread away from its default
> thread because memory accesses will have to be done again.

Sure I expect the CPU load balancer will do crazy stuff in the future with
the spread of NUMA, involving a lot the kernel in such decision making.
But although I'm no scheduler expert, I suspect this will entangle finer grained
datas than a big fat kthread mask :)

> 
> > > This also allows us to cleanup kernel uses of cpumasks in such a way that
> > > proper thread placement for various other uses (reclaim f.e. kswpad) is
> > > possible.
> >
> > Same here, a central tool should be able to solve that.
> 
> I think this is something that belongs in the kernel under consideration
> of the developers. The user space scripts that I have seen are not
> that clean and they are strongly kernel version dependant.

The fact that no nice stuff has been done in userspace for this yet doesn't
mean it has to be done in the kernel.
