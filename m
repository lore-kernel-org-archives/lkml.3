Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaILJrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 05:47:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbaILJrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 05:47:14 -0400
Date: Fri, 12 Sep 2014 10:44:19 +0100
From: Aaron Tomlin <atomlin@redhat.com>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: peterz@infradead.org, dzickus@redhat.com, jcastillo@redhat.com,
        riel@redhat.com, x86@kernel.org, akpm@linux-foundation.org,
        minchan@kernel.org, bmr@redhat.com, prarit@redhat.com, oleg@redhat.com,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org,
        mingo@redhat.com, aneesh.kumar@linux.vnet.ibm.com, akpm@google.com,
        jgh@redhat.com, linuxppc-dev@lists.ozlabs.org, tglx@linutronix.de,
        pzijlstr@redhat.com
Subject: Re: [PATCH v3 3/3] sched: BUG when stack end location is over written
Message-ID: <20140912094419.GD1873@atomlin.usersys.redhat.com>
References: <1410255749-2956-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-1-git-send-email-atomlin@redhat.com>
 <1410450088-18236-4-git-send-email-atomlin@redhat.com>
 <1410494817.17540.4.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1410494817.17540.4.camel@concordia>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 02:06:57PM +1000, Michael Ellerman wrote:
> On Thu, 2014-09-11 at 16:41 +0100, Aaron Tomlin wrote:
> > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > index a285900..2a8280a 100644
> > --- a/lib/Kconfig.debug
> > +++ b/lib/Kconfig.debug
> > @@ -824,6 +824,18 @@ config SCHEDSTATS
> >  	  application, you can say N to avoid the very slight overhead
> >  	  this adds.
> >  
> > +config SCHED_STACK_END_CHECK
> > +	bool "Detect stack corruption on calls to schedule()"
> > +	depends on DEBUG_KERNEL
> > +	default y
> 
> Did you really mean default y?
> 
> Doing so means it will be turned on more or less everywhere, which defeats the
> purpose of having a config option in the first place.

Only if Kconfig CONFIG_DEBUG_KERNEL is enabled in the first place.

-- 
Aaron Tomlin
