Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3ILPcX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:32:23 -0400
Received: from a9-54.smtp-out.amazonses.com ([54.240.9.54]:48137 "EHLO
	a9-54.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752841Ab3ILPcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:32:22 -0400
Date: Thu, 12 Sep 2013 15:32:20 +0000
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
In-Reply-To: <20130912151102.GB23839@somewhere>
Message-ID: <0000014112cd3565-3372fafc-390c-4d71-806a-348b4f4e5d71-000000@email.amazonses.com>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com> <20130911220228.GB15367@somewhere> <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com> <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com> <20130912143137.GA23839@somewhere> <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com> <20130912151102.GB23839@somewhere>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.12-54.240.9.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Frederic Weisbecker wrote:

> > Yea but the kernel option makes it easy. No extras needed. Kernel brings
> > it up user space cleanly configured and ready to go.
>
> Ok but really that's just two lines of bash. I really wish we don't complicate
> core kernel code for that.

Thread placement is an issue in general for the future. The more hardware
threads we get the more aware of thread placement we need to become
because caches become more important for performance. Disturbing the cache
of another is significant. So it moving a thread away from its default
thread because memory accesses will have to be done again.

> > This also allows us to cleanup kernel uses of cpumasks in such a way that
> > proper thread placement for various other uses (reclaim f.e. kswpad) is
> > possible.
>
> Same here, a central tool should be able to solve that.

I think this is something that belongs in the kernel under consideration
of the developers. The user space scripts that I have seen are not
that clean and they are strongly kernel version dependant.

