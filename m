Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016AbaATSh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:37:56 -0500
Received: from netrider.rowland.org ([192.131.102.5]:43466 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750993AbaATShy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:37:54 -0500
Date: Mon, 20 Jan 2014 13:37:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oleg Nesterov <oleg@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/5] lockdep: (Was: check && lockdep_no_validate)
In-Reply-To: <20140120181942.GA20783@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1401201328330.24630-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Oleg Nesterov wrote:

> On 01/17, Alan Stern wrote:
> >
> > On Fri, 17 Jan 2014, Oleg Nesterov wrote:
> >
> > > Yes, sure. This change assumes that the only problem in drivers/base is
> > > dev->parent->mutex / dev->mutex dependency. If the locking is even more
> > > "broken" (wrt lockdep), we can't replace lockdep_set_novalidate_class()
> > > with lockdep_set_auto_nested().
> >
> > I suspect it is even more "broken".  But I can't point to specific
> > examples.
> >
> > ...
> >
> > My guess is that if your change is deployed widely, there will be
> > reports of violations.  That's only a guess.
> 
> OK, lets (try to) do this later. Let me send the changes which I hope
> should be fine in any case.
> 
> > Still, you could go ahead and try it, just to see what happens.
> 
> Yes, perhaps it makes sense at least to test this change and see what
> happens... We will see.
> 
> > Also, take a look at commit 356c05d58af0.  It's a similar situation
> > (not exactly the same).
> 
> At first glance, can't __ATTR_IGNORE_LOCKDEP() use no_validate too ?
> (ignoring the fact checkpatch.pl won't be happy). This can simplify
> the code, it seems.

Well, the macro itself doesn't specify the lockdep class.  That happens 
implicitly in sysfs_get_active(), in the call to rwsem_acquire_read().
However, it ought to be possible to change the code so that when 
ignore_lockdep(sd) returns nonzero, we end up using no_validate.

Alan Stern

