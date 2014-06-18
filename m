Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843AbaFROlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 10:41:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45568 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbaFROlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 10:41:12 -0400
Date: Wed, 18 Jun 2014 16:41:09 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Petr Mladek <pmladek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Dave Anderson <anderson@redhat.com>, Kay Sievers <kay@vrfy.org>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 00/11] printk: safe printing in NMI context
In-Reply-To: <20140618143612.GC4669@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.00.1406181638360.2303@pobox.suse.cz>
References: <1399626665-29817-1-git-send-email-pmladek@suse.cz> <alpine.LNX.2.00.1405290000350.17241@pobox.suse.cz> <20140529000909.GC6507@localhost.localdomain> <alpine.LNX.2.00.1405290959270.17241@pobox.suse.cz> <20140610164641.GD1951@localhost.localdomain>
 <CA+55aFzseOqF-EpKMvwKpfhBJZQSLqKpJ3shzVee9s0+mvyCuA@mail.gmail.com> <alpine.LNX.2.00.1406181245230.2303@pobox.suse.cz> <20140618143612.GC4669@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Paul E. McKenney wrote:

> > - both RCU stall detector and 'echo l > sysrq-trigger' can (and we've 
> >   seen it happening for real) cause a complete, undebuggable, silent hang 
> >   of machine (deadlock in NMI context)
> 
> I could easily add an option to RCU to allow people to tell it not to
> use NMIs to dump the stack.  Would that help?

Well, that would make unfortunately the information provided by RCU stall 
detector rather useless ... workqueue-based stack dumping is very unlikely 
to point its finger to the real offender, as it'd be coming way too late.

Thanks,

-- 
Jiri Kosina
SUSE Labs
