Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaHSEB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 00:01:59 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:36637 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaHSEB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 00:01:57 -0400
Date: Mon, 18 Aug 2014 21:01:49 -0700
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
Message-ID: <20140819040149.GJ4752@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140812034531.GA13801@linux.vnet.ibm.com>
 <20140812053321.GK4184@grmbl.mre>
 <20140812160621.GC4752@linux.vnet.ibm.com>
 <20140812213936.GA3106@linux.vnet.ibm.com>
 <20140812214151.GB3106@linux.vnet.ibm.com>
 <20140813054439.GA29913@grmbl.mre>
 <20140813130049.GS4752@linux.vnet.ibm.com>
 <20140815052411.GF1934@grmbl.mre>
 <20140815150402.GD4752@linux.vnet.ibm.com>
 <20140818175345.GD31856@grmbl.mre>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140818175345.GD31856@grmbl.mre>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081904-3532-0000-0000-000003F2B7DF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 11:23:45PM +0530, Amit Shah wrote:
> On (Fri) 15 Aug 2014 [08:04:05], Paul E. McKenney wrote:
> > On Fri, Aug 15, 2014 at 10:54:11AM +0530, Amit Shah wrote:
> > > On (Wed) 13 Aug 2014 [06:00:49], Paul E. McKenney wrote:
> > > > On Wed, Aug 13, 2014 at 11:14:39AM +0530, Amit Shah wrote:
> > > > > On (Tue) 12 Aug 2014 [14:41:51], Paul E. McKenney wrote:
> > > > > > On Tue, Aug 12, 2014 at 02:39:36PM -0700, Paul E. McKenney wrote:
> > > > > > > On Tue, Aug 12, 2014 at 09:06:21AM -0700, Paul E. McKenney wrote:
> > > > > > > > On Tue, Aug 12, 2014 at 11:03:21AM +0530, Amit Shah wrote:
> > > > > > > 
> > > > > > > [ . . . ]
> > > > > > > 
> > > > > > > > > I know of only virtio-console doing this (via userspace only,
> > > > > > > > > though).
> > > > > > > > 
> > > > > > > > As in userspace within the guest?  That would not work.  The userspace
> > > > > > > > that the qemu is running in might.  There is a way to extract ftrace info
> > > > > > > > from crash dumps, so one approach would be "sendkey alt-sysrq-c", then
> > > > > > > > pull the buffer from the resulting dump.  For all I know, there might also
> > > > > > > > be some script that uses the qemu "x" command to get at the ftrace buffer.
> > > > > > > > 
> > > > > > > > Again, I cannot reproduce this, and I have been through the code several
> > > > > > > > times over the past few days, and am not seeing it.  I could start
> > > > > > > > sending you random diagnostic patches, but it would be much better if
> > > > > > > > we could get the trace data from the failure.
> > > > > 
> > > > > I think the only recourse I now have is to dump the guest state from
> > > > > qemu, and attempt to find the ftrace buffers by poking pages and
> > > > > finding some ftrace-like struct... and then dumping the buffers.
> > > > 
> > > > The data exists in the qemu guest state, so it would be good to have
> > > > it one way or another.  My current (perhaps self-serving) guess is that
> > > > you have come up with a way to trick qemu into dropping IPIs.
> > > 
> > > I didn't get around to doing this yet; will get to it next week.
> > > 
> > > In the meantime, I tried this on RHEL6 (with RHEL6 qemu and gcc and
> > > seabios), and that exhibits the problem similarly with my .config.
> > 
> > And I am running my tests successfully on an x86_64 system running
> > Ubuntu 12.04.  Some testing on 14.04 seems to require booting with
> > acpi=off, leading to my perhaps self-serving guess above.
> 
> It looks like Ubuntu 12.04 has a choice of multiple kernels.  Which
> one are you running?

3.2.0-67-generic-pae and 3.13.0-30-generic for the host.

> Also, is there a chance you could try this on a RHEL6 box?

The odds are low over the next few days.  I am adding nastier rcutorture
testing, however.  It would still be very good to get debug information
from your setup.  One approach would be to convert the trace function
calls into printk(), if that would help.

							Thanx, Paul

