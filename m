Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaATVmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 16:42:50 -0500
Received: from netrider.rowland.org ([192.131.102.5]:39231 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752586AbaATVmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 16:42:46 -0500
Date: Mon, 20 Jan 2014 16:42:45 -0500 (EST)
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
In-Reply-To: <20140120185401.GA27651@redhat.com>
Message-ID: <Pine.LNX.4.44L0.1401201640090.28417-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014, Oleg Nesterov wrote:

> > > At first glance, can't __ATTR_IGNORE_LOCKDEP() use no_validate too ?
> > > (ignoring the fact checkpatch.pl won't be happy). This can simplify
> > > the code, it seems.
> >
> > Well, the macro itself doesn't specify the lockdep class.  That happens
> > implicitly in sysfs_get_active(), in the call to rwsem_acquire_read().
> > However, it ought to be possible to change the code so that when
> > ignore_lockdep(sd) returns nonzero, we end up using no_validate.
> 
> sysfs_dirent_init_lockdep() can check ->ignore_lockdep and do
> lockdep_set_novalidate_class(). This way sysfs_ignore_lockdep() can
> go away.
> 
> I guess we could even change __ATTR_IGNORE_LOCKDEP() to initialize
> ->key = __lockdep_no_validate__ and kill ->ignore_lockdep.

It's clear that you have a more thorough understanding of how sysfs and
lockdep work than I do.  :-)

This suggestion sounds quite reasonable.

Alan Stern

