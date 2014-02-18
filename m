Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBRBSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:18:32 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:49859 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaBRBSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:18:30 -0500
Date: Mon, 17 Feb 2014 17:18:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/55] Torture-test changes for 3.15
Message-ID: <20140218011824.GY4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <20140218004145.GJ19929@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218004145.GJ19929@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021801-3532-0000-0000-000005C01D8A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:41:46PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 02:12:31PM -0800, Paul E. McKenney wrote:
> > Hello!
> > 
> > This series contains rcutorture changes, including adding a simple
> > locktorture.  Creating this locktorture while sharing the rcutorture
> > infrastructure was the main point of this patch, but this effort
> > uncovered a number of shortcomings in rcutorture, which this series
> > also fixes.
> > 
> > 1-6.	Usability improvements in rcutorture scripting.
> > 
> > 7-13.	Enable concurrent rcutorture runs on systems with sufficient
> > 	numbers of CPUs.

Checking this list first, then will check the patches themselves.

This one contains 12.

> > 14.	Print the results directory at the end of the test.
> > 
> > 15,17-25,27-28,30,32,37-41,46-48.
> > 	Abstract facilities from rcutorture module and scripting for later
> > 	use by locktorture.

18 is here.  So is 38 and 39

> > 16.	Don't create a results directory for dryruns.

Here is 16.

> > 26.	Print date and time of each phase of torturing.

Here is 26.

> > 29.	Issue a diagnostic if something does a system shutdown while
> > 	rcutorture is running.
> > 
> > 31.	Apply ACCESS_ONCE() to racy fullstop accesses.
> > 
> > 33.	Clean up rcu_torture_init() error handling.
> > 
> > 34.	Announce kthread creation.
> > 
> > 35.	Clean up a number of rcutorture shutdown races, unifying the
> > 	required shutdown actions into a new torture_kthread_stopping()
> > 	function.
> > 
> > 36.	Add a missing return statement in rcu_torture_barrier_init().
> > 
> > 42.	Create a minimal locktorture module.
> > 
> > 43-44.	Add an on-purpose buggy RCU implementation to rcutorture to help
> > 	test the tests.

Here is 43.

> > 45.	Create a file for Kconfig parameters that are commmon across all
> > 	rcutorture tests.
> > 
> > 49.	Add beginning set of config files for locktorture.
> > 
> > 50.	Avoid SEGV when cleanup-hooks function pointer is NULL.
> > 
> > 51.	Add locktorture plugin for kvm_recheck.sh.
> > 
> > 52.	Rename TREE_RCU-Kconfig.txt to avoid confusing scripts that
> > 	look for Kconfig files, courtesy of Paul Bolle.
> > 
> > 53.	Retain output from kvm-test-1-run.sh script.

Here is 53.

> > 54.	Add an on-purpose buggy lock implementation to locktorture to
> > 	help test the tests.
> > 
> > 55.	Save kvm.sh progress messages to log so that they can be used
> > 	for later timing analysis.
> 
> I replied with comments on 15, 17, 19, 21, 35, and 37.

Thank you, will respond/apply.

> This series also appears to be missing patches numbered 12, 16, 18, 26,
> 38, 39, 43, and 53.  (In some cases those patch numbers appear above but
> the corresponding patches don't appear in subsequent mails; in other
> cases those numbers appear missing above as well.)

I see them all above, and I received all of them.  Here are URLs for them:

12: https://lkml.org/lkml/2014/2/17/616
16: http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg590070.html
18: http://www.spinics.net/lists/kernel/msg1689535.html
26: http://comments.gmane.org/gmane.linux.kernel/1649714
38: http://www.spinics.net/lists/kernel/msg1689519.html
39: http://www.spinics.net/lists/kernel/msg1689526.html
43: https://lkml.org/lkml/2014/2/17/617
53: http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg590028.html
	(along with a very entertaining ad...)

I tried lkml.org first, so you are not the only one missing out on some
of them.  Hmmm...

I bounced them to you as well, so hopefully they will get there this time.
Then again, you were --cc'ed on them to start with, so who knows?

> For the remaining patches:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Thank you for your review and comments!

							Thanx, Paul

