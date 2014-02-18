Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753801AbaBRAsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:48:15 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:57534 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbaBRAsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:48:12 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 16:48:00 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 0/55] Torture-test changes for 3.15
Message-ID: <20140218004800.GA20538@thin>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <20140218004145.GJ19929@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218004145.GJ19929@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:41:45PM -0800, Josh Triplett wrote:
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
> > 
> > 14.	Print the results directory at the end of the test.
> > 
> > 15,17-25,27-28,30,32,37-41,46-48.
> > 	Abstract facilities from rcutorture module and scripting for later
> > 	use by locktorture.
> > 
> > 16.	Don't create a results directory for dryruns.
> > 
> > 26.	Print date and time of each phase of torturing.
> > 
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
> > 
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
> > 
> > 54.	Add an on-purpose buggy lock implementation to locktorture to
> > 	help test the tests.
> > 
> > 55.	Save kvm.sh progress messages to log so that they can be used
> > 	for later timing analysis.
> 
> I replied with comments on 15, 17, 19, 21, 35, and 37.
> 
> This series also appears to be missing patches numbered 12, 16, 18, 26,
> 38, 39, 43, and 53.  (In some cases those patch numbers appear above but
> the corresponding patches don't appear in subsequent mails; in other
> cases those numbers appear missing above as well.)
> 
> For the remaining patches:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

It appears that the patches that appeared "missing" showed up after all,
but for some reason those mails were delayed.
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
for those as well.
