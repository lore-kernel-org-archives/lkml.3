Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951AbaFRPHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:07:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:33245 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbaFRPH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:07:28 -0400
Date: Wed, 18 Jun 2014 08:07:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
Message-ID: <20140618150721.GI4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz>
 <20140529000909.GC6507@localhost.localdomain>
 <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz>
 <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com>
 <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz>
 <20140618143612.GC4669@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1406181638360.2303@pobox.suse.cz>
 <20140618144457.GF4669@linux.vnet.ibm.com>
 <alpine.LNX.2.00.1406181649190.2303@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1406181649190.2303@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061815-0928-0000-0000-000002C8A1A5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 04:53:14PM +0200, Jiri Kosina wrote:
> On Wed, 18 Jun 2014, Paul E. McKenney wrote:
> 
> > > > > - both RCU stall detector and 'echo l > sysrq-trigger' can (and we've 
> > > > >   seen it happening for real) cause a complete, undebuggable, silent hang 
> > > > >   of machine (deadlock in NMI context)
> > > > 
> > > > I could easily add an option to RCU to allow people to tell it not to
> > > > use NMIs to dump the stack.  Would that help?
> > > 
> > > Well, that would make unfortunately the information provided by RCU stall 
> > > detector rather useless ... workqueue-based stack dumping is very unlikely 
> > > to point its finger to the real offender, as it'd be coming way too late.
> > 
> > I would not use workqueues, but rather have the CPU detecting the
> > stall grovel through the other CPUs' stacks, which is what I do now for
> > architectures that don't support NMI-based stack dumps.  Would that be
> > a reasonable approach?
> 
> That would indeed solve lockups induced by RCU stall detector (and we 
> should convert sysrq stack dumping code to use the same mechanism 
> afterwards).
> 
> But then, the kernel is still polluted by quite a few instances of
> 
> 	WARN_ON(in_nmi())
> 
> 	BUG_IN(in_nmi())
> 
> 	if (in_nmi())
> 		printk(....)
> 
> which need to be fixed separately afterwards anyway.

True enough!

							Thanx, Paul

