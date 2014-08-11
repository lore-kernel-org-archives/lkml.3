Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856AbaHKTnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 15:43:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaHKTnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 15:43:02 -0400
Date: Tue, 12 Aug 2014 01:11:26 +0530
From: Amit Shah <amit.shah@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140811194126.GF4184@grmbl.mre>
References: <1405085703-14822-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <53E48D18.8080007@redhat.com>
 <20140808162502.GX5821@linux.vnet.ibm.com>
 <20140808173710.GA13483@grmbl.mre>
 <20140808181835.GD5821@linux.vnet.ibm.com>
 <20140808183424.GB13483@grmbl.mre>
 <20140808214347.GH5821@linux.vnet.ibm.com>
 <20140808214648.GA19058@linux.vnet.ibm.com>
 <20140811071308.GA4184@grmbl.mre>
 <20140811162807.GW5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140811162807.GW5821@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Mon) 11 Aug 2014 [09:28:07], Paul E. McKenney wrote:
> On Mon, Aug 11, 2014 at 12:43:08PM +0530, Amit Shah wrote:
> > On (Fri) 08 Aug 2014 [14:46:48], Paul E. McKenney wrote:
> > > On Fri, Aug 08, 2014 at 02:43:47PM -0700, Paul E. McKenney wrote:
> > > > On Sat, Aug 09, 2014 at 12:04:24AM +0530, Amit Shah wrote:
> > > > > On (Fri) 08 Aug 2014 [11:18:35], Paul E. McKenney wrote:
> > > > 
> > > > [ . . . ]
> > > > 
> > > > > > Hmmm... What happens if you boot a7d7a143d0b4cb1914705884ca5c25e322dba693
> > > > > > with the kernel parameter "acpi=off"?
> > > > > 
> > > > > That doesn't change anything - still hangs.
> > > > > 
> > > > > I intend to look at this more on Monday, though - turning in for
> > > > > today.  In the meantime, if there's anything else you'd like me to
> > > > > try, please let me know.
> > > > 
> > > > OK, given that I still cannot reproduce it, I do need your help with
> > > > the diagnostics.  And so what sorts of diagnostics work for you in
> > > > the hung state?  Are you able to dump ftrace buffers?
> > > > 
> > > > If you are able to dump ftrace buffers, please enable rcu:rcu_nocb_wake
> > > > and send me the resulting trace.
> > > 
> > > And another random kernel boot parameter to try is rcu_nocb_poll.
> > 
> > Right, this gets the boot going again:
> 
> OK, that likely indicates a lost wakeup.  The event tracing enabled by
> "rcu:rcu_nocb_wake" should help track those down.  Last time, it was qemu
> losing the wakeups, but maybe it is RCU this time.  ;-)

The guest goes dead pretty early; is there a trick to enabling and
getting these traces out of the guest that I don't know of that
doesn't involve being booted into userspace?  I can perhaps try
getting the trace output out from a virtio-serial channel; but even
that driver isn't probed yet when the lockup happens.

		Amit
