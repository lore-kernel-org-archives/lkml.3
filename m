Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019AbaHLQG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 12:06:29 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:38227 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaHLQG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 12:06:28 -0400
Date: Tue, 12 Aug 2014 09:06:21 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amit Shah <amit.shah@redhat.com>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/2] rcu: Parallelize and economize NOCB
 kthread wakeups
Message-ID: <20140812160621.GC4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140808214347.GH5821@linux.vnet.ibm.com>
 <20140808214648.GA19058@linux.vnet.ibm.com>
 <20140811071308.GA4184@grmbl.mre>
 <20140811162807.GW5821@linux.vnet.ibm.com>
 <20140811194126.GF4184@grmbl.mre>
 <20140811201102.GD5821@linux.vnet.ibm.com>
 <20140811201845.GG4184@grmbl.mre>
 <20140811203421.GE5821@linux.vnet.ibm.com>
 <20140812034531.GA13801@linux.vnet.ibm.com>
 <20140812053321.GK4184@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140812053321.GK4184@grmbl.mre>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081216-8236-0000-0000-0000048C01E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 11:03:21AM +0530, Amit Shah wrote:
> On (Mon) 11 Aug 2014 [20:45:31], Paul E. McKenney wrote:

[ . . . ]

> > > That is a bit surprising.  Is it possible that the system is OOMing
> > > quickly due to grace periods not proceeding?  If so, maybe giving the
> > > VM more memory would help.
> > 
> > Oh, and it is necessary to build the kernel with CONFIG_RCU_TRACE=y
> > for the rcu_nocb_wake trace events to be enabled in the first place.
> > I am assuming that your kernel was built with CONFIG_MAGIC_SYSRQ=y.
> 
> Yes, it is :-)  I checked the rcu_nocb_poll cmdline option does indeed
> dump all the ftrace buffers to dmesg.

Good.  ;-)

> > If all of that is in place and no joy, is it possible to extract the
> > ftrace buffer from the running/hung guest?  It should be in there
> > somewhere!  ;-)
> 
> I know of only virtio-console doing this (via userspace only,
> though).

As in userspace within the guest?  That would not work.  The userspace
that the qemu is running in might.  There is a way to extract ftrace info
from crash dumps, so one approach would be "sendkey alt-sysrq-c", then
pull the buffer from the resulting dump.  For all I know, there might also
be some script that uses the qemu "x" command to get at the ftrace buffer.

Again, I cannot reproduce this, and I have been through the code several
times over the past few days, and am not seeing it.  I could start
sending you random diagnostic patches, but it would be much better if
we could get the trace data from the failure.

							Thanx, Paul

