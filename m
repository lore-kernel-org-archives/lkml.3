Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933893AbaFCUxz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:53:55 -0400
Received: from imap.thunk.org ([74.207.234.97]:48721 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933770AbaFCUxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:53:53 -0400
Date: Tue, 3 Jun 2014 16:52:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Chinner <david@fromorbit.com>, josh@joshtriplett.org,
        Joe Perches <joe@perches.com>, paulmck@linux.vnet.ibm.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH RFC 1/2] MAINTAINERS: Add "R:" designated-reviewers tag
Message-ID: <20140603205253.GC25483@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Dave Chinner <david@fromorbit.com>, josh@joshtriplett.org,
	Joe Perches <joe@perches.com>, paulmck@linux.vnet.ibm.com,
	linux-kernel@vger.kernel.org, mingo@kernel.org,
	laijs@cn.fujitsu.com, dipankar@in.ibm.com,
	akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
	niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
	dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
	fweisbec@gmail.com, oleg@redhat.com, sbw@mit.edu
References: <20140602185504.GA13569@cloud>
 <1401735917.7323.23.camel@joe-AO725>
 <20140602190951.GA13648@cloud>
 <1401736666.7323.25.camel@joe-AO725>
 <20140602231949.GV14410@dastard>
 <20140602235915.GB14801@cloud>
 <20140603011125.GW14410@dastard>
 <20140602213045.26219ddb@gandalf.local.home>
 <20140603071654.GC14410@dastard>
 <20140603134347.6e39f946@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603134347.6e39f946@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 03, 2014 at 01:43:47PM -0400, Steven Rostedt wrote:
> > I know from experience that a "quick" 15 minute run on xfstests on a
> > ramdisk will catch 99% of typical problems a filesystem patch might
> > introduce. Code coverage reporting (done recently by RH QE
> > engineers) tells me that this covers between 50-70% of the
> > filesystem, VFS and MM subsystems (numbers vary with fs being
> > tested), and so that's a pretty good, fast smoke test that I can run
> > on any patch or patchset that is sent for review.
> 
> Testing is fine, but I think you are undervaluing true review. Seems to
> me, all you ask for others to do is to run their test suite on the code
> to give a reviewed-by. I ask for people to look at the logic and spend
> a lot more time on seeing if something strange is there. I found people
> find things that tests usually don't. That's because before I post code
> for review, I usually run it under a lot of tests myself that weeds out
> most of those bugs.

I'm not sure why you guys are arguing so much about this ditinction
between testing versus review as if it were an either/or sort of
situation.  Both are important; there are problems that will be caught
by the review that won't get caught using smoke tests, and often smoke
tests (assuming you have a good collection of tests for a particular
subsystem, which is not something which is a given for all subsystems)
can find problems that a desk check of the code can miss.

As far as who should run the tests, the way we do things in the ext4
world is that ideally the developer who is submitting the patch as
well as the maintainer should be running the tests, and I don't worry
so much about whether the reviewer is running the tests.  If I find
problems in my testing, I'll often point out this fact out to the
developer, and to try to gently push them to do tests before pushing
code out for review.  The fact that I can point them at kvm-xfstests
which is a turnkey smoke test system which requires nothing running a
script and waiting 30 minutes (or 16 hours or so for a full test run
with the full set of configurations, which I will ask developers who
are making substantive changes to do instead of just the quick smoke
test).

The way I see it, if the developer and the maintainer is running
tests, it's not so clear to me that making the reviewer run the tests
as well adds enough value that it's worth requiring it.

The important thing to note here is that we do not have consensus
across all subsystems what Reviewed-by: means, and I think that's OK.
The Reviewed-by: is mostly of interest to the maintainer before the
patch is submitted to mainline.  The value of keeping it in the git
commit logs after the fact seems to be a bit variable, although if
there are companies blindly using it as a performance metric and this
is driving down the quality of reviews, perhaps one could even argue
that including these tags in the git commit logs is actually adding
negative value.  But I don't really care about that issue, because
like most maintainers, I know the reviewers by reputation, and whether
someone actually says "you can add my Reviewed-by" is actually not so
important as their comments on the patch, one way or another.

Regards,

					- Ted
