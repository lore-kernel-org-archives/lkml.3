Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328AbaGISKb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:10:31 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:54969 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755274AbaGISKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:10:30 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:966:968:973:979:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1543:1593:1594:1711:1712:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:2828:29
X-HE-Tag: bomb30_3d4d6ba14a45d
X-Filterd-Recvd-Size: 4797
Message-ID: <1404929419.932.136.camel@joe-AO725>
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, oleg@redhat.com,
        sbw@mit.edu
Date: Wed, 09 Jul 2014 11:10:19 -0700
In-Reply-To: <20140709174231.GC23881@localhost.localdomain>
References: <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20140708080908.GN19379@twins.programming.kicks-ass.net>
	 <1404842784.932.22.camel@joe-AO725>
	 <20140708204124.GW4603@linux.vnet.ibm.com>
	 <1404853264.932.52.camel@joe-AO725>
	 <20140708215229.GA4603@linux.vnet.ibm.com>
	 <1404857116.932.68.camel@joe-AO725>
	 <20140708222557.GF4603@linux.vnet.ibm.com>
	 <1404878965.932.87.camel@joe-AO725>
	 <20140709174231.GC23881@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-07-09 at 19:42 +0200, Frederic Weisbecker wrote:
> On Tue, Jul 08, 2014 at 09:09:25PM -0700, Joe Perches wrote:
> > On Tue, 2014-07-08 at 15:25 -0700, Paul E. McKenney wrote:
> > > On Tue, Jul 08, 2014 at 03:05:16PM -0700, Joe Perches wrote:
> > []
> > > > I still think the concept is pretty useless and it's
> > > > just a duplication of "M:", which isn't anything other
> > > > than a list of who should be sent patches.
> > []
> > > It will be interesting to see how things go.
> > 
> > Yes, it might work out fine and maybe might cause some
> > other beneficial changes.
> > 
> > > There did seem to be
> > > some people who were comfortable being listed as RCU reviewers, but
> > > not as RCU maintainers.  Perhaps the same thing happens elsewhere.
> > 
> > Maybe so.
> > 
> > I wrote a script to find which maintainer addresses that
> > haven't signed or authored a commit in the last 2 years.
> > 
> > I got ~250 entries.  That's about 1/4 of all maintainer
> > email addresses.
> > 
> > Maybe a dozen of these are false positives though because
> > some maintainers prefer to receive email at one address
> > but ack from another.
> > 
> > These are all lowercase for better matching.
> 
> Aren't we all falling in the typical pessimism trap, evil of the century!
> Why do we always want to consider the lack of activity from a maintainer as a bad symptom?

> What if it were actually a positive sign resulting of a finished, completed, and perfect
> clean bug-free subsystem?

You mean "free of known defects".

> diff --git a/MAINTAINERS b/MAINTAINERS
[]
> @@ -76,6 +76,9 @@ Descriptions of section entries:
>  	T: SCM tree type and location.
>  	   Type is one of: git, hg, quilt, stgit, topgit
>  	S: Status, one of the following:
> +          Finished:	The code is finished. The maintainer has fixed all
> +			the bugs and adressed all missing features. No further
> +			patch is needed.

Yeah, some'um like that.

But very few people are capable of writing bug-free,
"finished" code akin to Donald Knuth.

Maybe finding a bug in a section marked like that
should be worth something to the patch submitter.

Maybe:
	virtual credit << bugs found

Most of those entries were for the people that
submitted the original code.  Most of those too
are no longer active in linux development.

So either put them in the CREDITS file and remove
them altogether from MAINTAINERS or maybe mark them
as reviewers instead of maintainers.

btw:  Here's a slightly cleaned up version of the
      script I used

$ cat find_active_maintainers.sh
#!/bin/bash

git log --since=2-years-ago | tr [:upper:] [:lower:] > git.commit.log
git grep -E "^M:" MAINTAINERS | tr [:upper:] [:lower:] | cut -d: -f3- | \
    sort | uniq | sed  -r 's/^\s+//' > maintainer.addresses
cat maintainer.addresses |
while read entry ; do
    email=$(echo $entry | sed -r -e 's/^[^<]*<//' -e 's/>.*//')
    echo "---> $entry	email --> $email"
    grep -P "^\s*(?:author:|[\w\-]+by:).*\b$email\b" git.commit.log | \
	sed -r -e 's/^\s+//' -e 's/>.*/>/' -e 's/\s+/ /g' | \
	sort | uniq -c
done


