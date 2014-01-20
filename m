Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaATST7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:19:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61657 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbaATST5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:19:57 -0500
Date: Mon, 20 Jan 2014 19:19:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>
Subject: [PATCH 0/5] lockdep: (Was: check && lockdep_no_validate)
Message-ID: <20140120181942.GA20783@redhat.com>
References: <20140117163111.GA5764@redhat.com> <Pine.LNX.4.44L0.1401171253010.1162-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401171253010.1162-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17, Alan Stern wrote:
>
> On Fri, 17 Jan 2014, Oleg Nesterov wrote:
>
> > Yes, sure. This change assumes that the only problem in drivers/base is
> > dev->parent->mutex / dev->mutex dependency. If the locking is even more
> > "broken" (wrt lockdep), we can't replace lockdep_set_novalidate_class()
> > with lockdep_set_auto_nested().
>
> I suspect it is even more "broken".  But I can't point to specific
> examples.
>
> ...
>
> My guess is that if your change is deployed widely, there will be
> reports of violations.  That's only a guess.

OK, lets (try to) do this later. Let me send the changes which I hope
should be fine in any case.

> Still, you could go ahead and try it, just to see what happens.

Yes, perhaps it makes sense at least to test this change and see what
happens... We will see.

> Also, take a look at commit 356c05d58af0.  It's a similar situation
> (not exactly the same).

At first glance, can't __ATTR_IGNORE_LOCKDEP() use no_validate too ?
(ignoring the fact checkpatch.pl won't be happy). This can simplify
the code, it seems.

Oleg.

