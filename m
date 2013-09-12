Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755042Ab3ILSv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:51:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44111 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab3ILSvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:51:25 -0400
Date: Thu, 12 Sep 2013 11:51:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130912185107.GV3966@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
 <20130911220228.GB15367@somewhere>
 <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
 <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <20130912153922.GP3966@linux.vnet.ibm.com>
 <20130912183503.GB25386@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912183503.GB25386@somewhere>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091218-5806-0000-0000-000022B7AC59
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 08:35:05PM +0200, Frederic Weisbecker wrote:
> On Thu, Sep 12, 2013 at 08:39:22AM -0700, Paul E. McKenney wrote:
> > On Thu, Sep 12, 2013 at 05:11:04PM +0200, Frederic Weisbecker wrote:
> > > On Thu, Sep 12, 2013 at 02:52:56PM +0000, Christoph Lameter wrote:
> > > > On Thu, 12 Sep 2013, Frederic Weisbecker wrote:
> > > > 
> > > > > > > Ok but you can change the affinity of a kthread from userspace, as
> > > > > > > long as you define a cpu set that is among that kthread's cpus allowed.
> > > > > >
> > > > > > Ok but at that point kthread has already spawned a lot of kernel threads.
> > > > > >
> > > > > > The same is true for init and kmod.
> > > > > >
> > > > >
> > > > > Ok but then we just need to set the affinity of all these kthreads.
> > > > > A simple lookup on /proc/[0-9]+/ should do the trick.
> > > > 
> > > > Yea but the kernel option makes it easy. No extras needed. Kernel brings
> > > > it up user space cleanly configured and ready to go.
> > > 
> > > Ok but really that's just two lines of bash. I really wish we don't complicate
> > > core kernel code for that.
> > 
> > OK, I will bite...  How do you handle the case where you have collected
> > all the kthreads, one of the kthreads spawns another kthread, then you
> > set affinity on the collected kthreads, which does not include the newly
> > spawned one?
> 
> Just offline the CPUs you want to isolate, affine your kthreads and re-online
> the CPUs.
> 
> If you're lucky enough to have 1024 CPUs, a winter night should be enough ;-)

Running at RT prio 99 to reduce the probability of respawns?  ;-)

							Thanx, Paul

