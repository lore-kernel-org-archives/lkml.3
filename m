Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbaGHVwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:52:37 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:53867 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaGHVwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:52:36 -0400
Date: Tue, 8 Jul 2014 14:52:29 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Message-ID: <20140708215229.GA4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140707224146.GA9118@linux.vnet.ibm.com>
 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140708080908.GN19379@twins.programming.kicks-ass.net>
 <1404842784.932.22.camel@joe-AO725>
 <20140708204124.GW4603@linux.vnet.ibm.com>
 <1404853264.932.52.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404853264.932.52.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070821-3532-0000-0000-00000301689B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2014 at 02:01:04PM -0700, Joe Perches wrote:
> On Tue, 2014-07-08 at 13:41 -0700, Paul E. McKenney wrote:
> > On Tue, Jul 08, 2014 at 11:06:24AM -0700, Joe Perches wrote:
> > > On Tue, 2014-07-08 at 10:09 +0200, Peter Zijlstra wrote:
> > > > On Mon, Jul 07, 2014 at 03:42:03PM -0700, Paul E. McKenney wrote:
> > > > >  MAINTAINERS | 8 ++++++++
> > > > >  1 file changed, 8 insertions(+)
> > > > > 
> > > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > > index 1814075c0e74..92f2bf91eec1 100644
> > > > > --- a/MAINTAINERS
> > > > > +++ b/MAINTAINERS
> > > > > @@ -7405,6 +7405,9 @@ F:	kernel/rcu/torture.c
> > > > >  
> > > > >  RCUTORTURE TEST FRAMEWORK
> > > > >  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > > > +R:	Steven Rostedt <rostedt@goodmis.org>
> > > > > +R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > > +R:	Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > >  L:	linux-kernel@vger.kernel.org
> > > > >  S:	Supported
> > > > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
> > > > 
> > > > OK,.. so if we're going to do this can we talk about the syntax here.
> > > > 
> > > > I would like to also use this for SCHED and PERF, but since both are
> > > > rather big I would like to be able to subdivide things. Now I could of
> > > > course go create many MAINTAINER sections, but that feels artificial.
> > > > 
> > > > So I would like to be able to write:
> > > > 
> > > > SCHEDULER:
> > > > ...
> > > > R:   Steven Rostedt <rostedt@goodmis.org> (kernel/sched/rt.c)
> > > > R:   Juri Lelli <juri.lelli@gmail.com>    (kernel/sched/deadline.c)
> > > > 
> > > > or something like that. And here I've already done concessions in that
> > > > the above is machine readable. Ideally I'd be able to say things like:
> > > > 'for sched and numa related things' add 'rik and mel'.
> > > > 
> > > > Hmm, maybe we can look at the patch subject tag like: sched/numa or
> > > > sched/rt or sched/deadline etc.. instead of the files touched.
> > > 
> > > I think it's best to use separate sections.
> > > 
> > > The parsing logic in get_maintainers is already ugly enough.
> > 
> > OK, here is a basic change.  Hey, I figure that if you weren't desperately
> > in need of entertainment, you would not have asked me to hack a perl script!
> > 
> > 							Thanx, Paul
> > 
> > ------------------------------------------------------------------------
> > 
> > scripts: Teach get_maintainer.pl about the new "R:" tag

[ . . . ]

> Paul, I already sent you a better version over a month ago.

That would explain why I had already forgotten about it.  ;-)

> https://lkml.org/lkml/2014/6/2/585

Unless you tell me otherwise, I assume that this means that you are
OK with my adding your Signed-off-by to that patch.  (The lack thereof
being another reason I would not have queued it.)  Please see below for
the proposed commit log and Signed-off-by.

If you don't tell me otherwise, I will submit this to the next merge
window.

								Thanx, Paul

------------------------------------------------------------------------

scripts: Teach get_maintainer.pl about the new "R:" tag

We can now designate reviewers in the MAINTAINERS file with the new
"R:" tag, so this commit teaches get_maintainers.pl to add their
email addresses.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 41987885bd31..d7016279ec2b 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -21,6 +21,7 @@ my $lk_path = "./";
 my $email = 1;
 my $email_usename = 1;
 my $email_maintainer = 1;
+my $email_reviewer = 1;
 my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
@@ -202,6 +203,7 @@ if (!GetOptions(
 		'remove-duplicates!' => \$email_remove_duplicates,
 		'mailmap!' => \$email_use_mailmap,
 		'm!' => \$email_maintainer,
+		'r!' => \$email_reviewer,
 		'n!' => \$email_usename,
 		'l!' => \$email_list,
 		's!' => \$email_subscriber_list,
@@ -260,7 +262,8 @@ if ($sections) {
 }
 
 if ($email &&
-    ($email_maintainer + $email_list + $email_subscriber_list +
+    ($email_maintainer + $email_reviewer +
+     $email_list + $email_subscriber_list +
      $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
     die "$P: Please select at least 1 email option\n";
 }
@@ -750,6 +753,7 @@ MAINTAINER field selection options:
     --hg-since => hg history to use (default: $email_hg_since)
     --interactive => display a menu (mostly useful if used with the --git option)
     --m => include maintainer(s) if any
+    --r => include reviewer(s) if any
     --n => include name 'Full Name <addr\@domain.tld>'
     --l => include list(s) if any
     --s => include subscriber only list(s) if any
@@ -1064,6 +1068,22 @@ sub add_categories {
 		    my $role = get_maintainer_role($i);
 		    push_email_addresses($pvalue, $role);
 		}
+	    } elsif ($ptype eq "R") {
+		my ($name, $address) = parse_email($pvalue);
+		if ($name eq "") {
+		    if ($i > 0) {
+			my $tv = $typevalue[$i - 1];
+			if ($tv =~ m/^(\C):\s*(.*)/) {
+			    if ($1 eq "P") {
+				$name = $2;
+				$pvalue = format_email($name, $address, $email_usename);
+			    }
+			}
+		    }
+		}
+		if ($email_reviewer) {
+		    push_email_addresses($pvalue, 'reviewer');
+		}
 	    } elsif ($ptype eq "T") {
 		push(@scm, $pvalue);
 	    } elsif ($ptype eq "W") {

