Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696AbaEJAvc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 20:51:32 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:47680 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757190AbaEJAvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 20:51:31 -0400
Date: Fri, 9 May 2014 17:51:24 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 39/45] rcutorture: Note diffs from git
 commits
Message-ID: <20140510005124.GI8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140429002455.GA15461@linux.vnet.ibm.com>
 <1398731133-18925-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1398731133-18925-39-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140507221742.GQ27924@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140507221742.GQ27924@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051000-7164-0000-0000-000001A53C43
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 03:17:42PM -0700, josh@joshtriplett.org wrote:
> On Mon, Apr 28, 2014 at 05:25:27PM -0700, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The current scripting only keeps track of the git SHA-1 of the current
> > HEAD.  This can cause confusion in cases where testing ran in a git
> > tree where changes had not yet been checked in.  This commit therefore
> > also records the output of "git diff HEAD" to provide the information
> > needed to reconstruct the source tree that was tested.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Nit below.
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > ---
> >  tools/testing/selftests/rcutorture/bin/kvm.sh | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/tools/testing/selftests/rcutorture/bin/kvm.sh b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > index 4eed2a4f42c7..91661845fdec 100644
> > --- a/tools/testing/selftests/rcutorture/bin/kvm.sh
> > +++ b/tools/testing/selftests/rcutorture/bin/kvm.sh
> > @@ -277,6 +277,11 @@ if test -d .git
> >  then
> >  	git status >> $resdir/$ds/testid.txt
> >  	git rev-parse HEAD >> $resdir/$ds/testid.txt
> > +	git diff HEAD > $T/git-diff 2>&1
> > +	if test -s $T/git-diff
> 
> You don't need test here; you can use the return value of git diff.

Oddly enough, the "git diff" man page does not say anything about the
exit value.  At least not that I could find...

							Thanx, Paul

> > +	then
> > +		cp $T/git-diff $resdir/$ds
> > +	fi
> >  fi
> >  ___EOF___
> >  awk < $T/cfgcpu.pack \
> > -- 
> > 1.8.1.5
> > 
> 

