Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbaFRQir (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 12:38:47 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:47118 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750862AbaFRQiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 12:38:46 -0400
Date: Wed, 18 Jun 2014 12:38:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Petr Mladek <pmladek@suse.cz>, Kay Sievers <kay@vrfy.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140618123837.0073be7d@gandalf.local.home>
In-Reply-To: <20140618162117.GM4669@linux.vnet.ibm.com>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz>
	<alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
	<20140529000909.GC6507@localhost.localdomain>
	<alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
	<20140610164641.GD1951@localhost.localdomain>
	<CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
	<alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
	<20140618143612.GC4669@linux.vnet.ibm.com>
	<CA+55aFwPgDC6gSEPfu3i-pA4f0ZbsTSvykxzX4sXMeLbdXuKrw@mail.gmail.com>
	<20140618162117.GM4669@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014 09:21:17 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Wed, Jun 18, 2014 at 05:58:40AM -1000, Linus Torvalds wrote:
> > On Jun 18, 2014 4:36 AM, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > wrote:
> > >
> > > I could easily add an option to RCU to allow people to tell it not to
> > > use NMIs to dump the stack.
> > 
> > I don't think it should be an "option".
> > 
> > We should stop using nmi as if it was something "normal". It isn't. Code
> > running in nmi context should be special, and should be very very aware
> > that it is special. That goes way beyond "don't use printk". We seem to
> > have gone way way too far in using nmi context.
> > 
> > So we should get *rid* of code in nmi context rather than then complain
> > about printk being buggy.
> 
> OK, unconditional non-use of NMIs is even easier.  ;-)
> 
> Something like the following.
> 

I have found the RCU stalls extremely useful in debugging lockups. In
case this doesn't work as well, I'm willing to write up something that
could send NMIs to all CPUs that would write into the ftrace ring
buffer and when finished, the calling CPU can dump it out. No printk
from NMI context at all.

-- Steve
