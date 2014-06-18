Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569AbaFRVh6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:37:58 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:40659 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaFRVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:37:57 -0400
Date: Wed, 18 Jun 2014 14:37:52 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140618213752.GX4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
 <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
 <20140618143612.GC4669@linux.vnet.ibm.com>
 <CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com>
 <20140618162117.GM4669@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1406182232390.2303@pobox.suse.cz>
 <20140618210757.GU4669@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1406182310070.2303@pobox.suse.cz>
 <20140618212022.GV4669@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1406182323300.2303@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406182323300.2303@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061821-0928-0000-0000-000002BEEEF3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 11:32:53PM +0200, Jiri Kosina wrote:
> On Wed, 18 Jun 2014, Paul E. McKenney wrote:
> 
> > > I agree that it might work nicely for RCU stall detector indeed. I was 
> > > looking for solution that'd work nicely both for RCU and for sysrq-l 
> > > (where we can't rely on processess being stuck in any way).
> > 
> > Agreed.  And if some more generally useful approach appears, I will be
> > quite happy to adjust RCU to use it.  In the meantime, I expect that
> > my patch will be helpful.
> 
> Agreed. And we'll look into fixing sysrq-l in parallel I guess; once there 
> is a working solution (hangs with sysrq-l can be trivially reproduced 
> almost immediately), we can then migrate RCU to it.
> 
> Still, I feel bad about the fact that we are now hostages of our printk() 
> implementation, which doesn't allow for any fixes/improvements. Having the 
> possibility to printk() from NMI would be nice and more robust ... 
> otherwise, we'll be getting people trying to do it in the future over and 
> over again, even if we now get rid of it at once.

Well, we could always have printk() splat if invoke in_nmi().

Oh, wait...  ;-)

More seriously, an in_nmi() printk() could taint the kernel, set a
flag that results in a deferred splat, do a trace_printk(), or any
number of things to let the developer know that this was a bad idea.

							Thanx, Paul

