Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab3ILO7M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:59:12 -0400
Received: from a14-74.smtp-out.amazonses.com ([54.240.14.74]:53285 "EHLO
	a14-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751631Ab3ILO7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:59:11 -0400
X-Greylist: delayed 374 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 10:59:11 EDT
Date: Thu, 12 Sep 2013 14:52:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
In-Reply-To: <20130912143137.GA23839@somewhere>
Message-ID: <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <20130911220228.GB15367@somewhere> <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com> <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com> <20130912143137.GA23839@somewhere>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.12-54.240.14.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Frederic Weisbecker wrote:

> > > Ok but you can change the affinity of a kthread from userspace, as
> > > long as you define a cpu set that is among that kthread's cpus allowed.
> >
> > Ok but at that point kthread has already spawned a lot of kernel threads.
> >
> > The same is true for init and kmod.
> >
>
> Ok but then we just need to set the affinity of all these kthreads.
> A simple lookup on /proc/[0-9]+/ should do the trick.

Yea but the kernel option makes it easy. No extras needed. Kernel brings
it up user space cleanly configured and ready to go.

This also allows us to cleanup kernel uses of cpumasks in such a way that
proper thread placement for various other uses (reclaim f.e. kswpad) is
possible.


