Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbaILK7D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 06:59:03 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:63187 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbaILK7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 06:59:00 -0400
Message-ID: <1410519533.5547.49.camel@marge.simpson.net>
Subject: Re: [PATCH v3 3/3] sched: BUG when stack end location is over
 written
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Aaron Tomlin <atomlin@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>, peterz@infradead.org,
        dzickus@redhat.com, jcastillo@redhat.com, riel@redhat.com,
        x86@kernel.org, akpm@linux-foundation.org, minchan@kernel.org,
        bmr@redhat.com, prarit@redhat.com, oleg@redhat.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mingo@redhat.com, aneesh.kumar@linux.vnet.ibm.com, akpm@google.com,
        jgh@redhat.com, linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de,
        pzijlstr@redhat.com
Date: Fri, 12 Sep 2014 12:58:53 +0200
In-Reply-To: <20140912094419.GD1873@atomlin.usersys.redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
	 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
	 <1410450088-18236-4-git-send-email-atomlin@redhat.com>
	 <1410494817.17540.4.camel@concordia>
	 <20140912094419.GD1873@atomlin.usersys.redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-09-12 at 10:44 +0100, Aaron Tomlin wrote: 
> On Fri, Sep 12, 2014 at 02:06:57PM +1000, Michael Ellerman wrote:
> > On Thu, 2014-09-11 at 16:41 +0100, Aaron Tomlin wrote:
> > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > index a285900..2a8280a 100644
> > > --- a/lib/Kconfig.debug
> > > +++ b/lib/Kconfig.debug
> > > @@ -824,6 +824,18 @@ config SCHEDSTATS
> > >  	  application, you can say N to avoid the very slight overhead
> > >  	  this adds.
> > >  
> > > +config SCHED_STACK_END_CHECK
> > > +	bool "Detect stack corruption on calls to schedule()"
> > > +	depends on DEBUG_KERNEL
> > > +	default y
> > 
> > Did you really mean default y?
> > 
> > Doing so means it will be turned on more or less everywhere, which defeats the
> > purpose of having a config option in the first place.
> 
> Only if Kconfig CONFIG_DEBUG_KERNEL is enabled in the first place.

Which is likely enabled just about everywhere on the planet.

-Mike


