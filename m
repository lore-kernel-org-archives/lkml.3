Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaBRBXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 20:23:33 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:51923 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaBRBXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 20:23:32 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 17 Feb 2014 17:23:18 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 19/55] rcutorture: Abstract TOROUT_STRING()
 and friends
Message-ID: <20140218012318.GA8794@thin>
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-19-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140218002606.GE19929@thin>
 <20140218005802.GW4250@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218005802.GW4250@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:58:02PM -0800, Paul E. McKenney wrote:
> On Mon, Feb 17, 2014 at 04:26:06PM -0800, Josh Triplett wrote:
> > On Mon, Feb 17, 2014 at 02:12:23PM -0800, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > These diagnostic macros are not confined to torturing RCU, so this commit
> > > makes them available to other torture tests.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > This removes the do {} while (0) around the first of the macros, without
> > any explanation in the commit message.
> 
> checkpatch.pl yelled at me about it.  ;-)

That's a fine reason, but the change needs documenting in the commit
message.

> > Also, to what extent could these be made redundant with pr_fmt?
> > if(verbose) seems like it really ought to become a priority level or
> > dynamic debugging (and it's really awful to further propagate macros
> > that reference an out-of-macro variable).  Ideally all of these could go
> > away in favor of pr_fmt, and then the individual calls to them would
> > become pr_alert, pr_debug, pr_error, or similar.
> 
> I don't immediately see how to get the "!!!" to be there or not with
> pr_fmt(), since the same pr_fmt() would apply to all the macros.

Replace VERBOSE_TOROUT_ERRSTRING with something like pr_emerg, or leave
it as pr_alert and drop the priority of the other variations to
something less; then instead of "!!!" you have the existing message
priority mechanism.

Also, if it helps, note that you can add parameters in pr_fmt, as long
as they're the initial parameters and you add corresponding format
specifiers before the passed format string.  (Many modules do this to
add __func__, for instance.)

> I am also not all that excited about including "verbose" or similar
> into the argument list of all calls to these guys.

verbose could go away entirely in favor of dynamic debug; you could then
turn debug on or off for the relevant torture test module instead of
setting verbose.

- Josh Triplett
