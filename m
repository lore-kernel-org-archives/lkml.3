Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaATSyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbaATSyM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:54:12 -0500
Date: Mon, 20 Jan 2014 19:54:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH 0/5] lockdep: (Was: check && lockdep_no_validate)
Message-ID: <20140120185401.GA27651@redhat.com>
References: <20140120181942.GA20783@redhat.com> <Pine.LNX.4.44L0.1401201328330.24630-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401201328330.24630-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20, Alan Stern wrote:
>
> On Mon, 20 Jan 2014, Oleg Nesterov wrote:
>
> > On 01/17, Alan Stern wrote:
> > >
> > > Also, take a look at commit 356c05d58af0.  It's a similar situation
> > > (not exactly the same).
> >
> > At first glance, can't __ATTR_IGNORE_LOCKDEP() use no_validate too ?
> > (ignoring the fact checkpatch.pl won't be happy). This can simplify
> > the code, it seems.
>
> Well, the macro itself doesn't specify the lockdep class.  That happens
> implicitly in sysfs_get_active(), in the call to rwsem_acquire_read().
> However, it ought to be possible to change the code so that when
> ignore_lockdep(sd) returns nonzero, we end up using no_validate.

sysfs_dirent_init_lockdep() can check ->ignore_lockdep and do
lockdep_set_novalidate_class(). This way sysfs_ignore_lockdep() can
go away.

I guess we could even change __ATTR_IGNORE_LOCKDEP() to initialize
->key = __lockdep_no_validate__ and kill ->ignore_lockdep.

Oleg.

