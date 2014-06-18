Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbaFRVc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 17:32:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52515 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755588AbaFRVcz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 17:32:55 -0400
Date: Wed, 18 Jun 2014 23:32:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <20140618212022.GV4669@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1406182323300.2303@pobox.suse.cz>
References: <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz> <20140610164641.GD1951@localhost.localdomain> <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com> <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz> <20140618143612.GC4669@linux.vnet.ibm.com>
 <CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com> <20140618162117.GM4669@linux.vnet.ibm.com> <alpine.LNX.2.00.1406182232390.2303@pobox.suse.cz> <20140618210757.GU4669@linux.vnet.ibm.com> <alpine.LNX.2.00.1406182310070.2303@pobox.suse.cz>
 <20140618212022.GV4669@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Paul E. McKenney wrote:

> > I agree that it might work nicely for RCU stall detector indeed. I was 
> > looking for solution that'd work nicely both for RCU and for sysrq-l 
> > (where we can't rely on processess being stuck in any way).
> 
> Agreed.  And if some more generally useful approach appears, I will be
> quite happy to adjust RCU to use it.  In the meantime, I expect that
> my patch will be helpful.

Agreed. And we'll look into fixing sysrq-l in parallel I guess; once there 
is a working solution (hangs with sysrq-l can be trivially reproduced 
almost immediately), we can then migrate RCU to it.

Still, I feel bad about the fact that we are now hostages of our printk() 
implementation, which doesn't allow for any fixes/improvements. Having the 
possibility to printk() from NMI would be nice and more robust ... 
otherwise, we'll be getting people trying to do it in the future over and 
over again, even if we now get rid of it at once.

Thanks,

-- 
Jiri Kosina
SUSE Labs
