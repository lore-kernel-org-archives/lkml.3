Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbaJXXnO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 19:43:14 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49823 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932421AbaJXXnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 19:43:13 -0400
Date: Fri, 24 Oct 2014 16:39:22 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, dhowells@redhat.com, linux@horizon.com,
        joseph@codesourcery.com, law@redhat.com, matz@suse.de,
        peterz@infradead.org, will.deacon@arm.com, corbet@lwn.net
Subject: Further adventures of rcu_dereference() and the C standard
Message-ID: <20141024233922.GA19107@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102423-0029-0000-0000-000000E3693F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

Just a follow-up on the spirited LKML thread last February
(http://lwn.net/Articles/586838/, https://lwn.net/Articles/588300/).

Although we don't yet have anything resembling full solution, there has
been some good progress, which is documented in SC22/WG21 document N4215.
The official copy is at:

	http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n4215.pdf

If you have trouble accessing it, here is a copy on my web site:

	http://www2.rdrop.com/users/paulmck/RCU/consume.2014.10.11a.pdf

The table on page 23 shows the current state.  To satisfy the key players,
we need "dep" in the "Dependency Type" column, either blank or "k" in
the "End-of-Chain Handling" column, and blank everywhere else.  As you
can see, none of the current proposals make the cut.  On the other hand,
we do at least have a variety of proposals.

The key players are as follows:

1.	The Linux kernel community.
2.	The compiler writers.
3.	The standards committee.
4.	Selected theorists (we need them for analysis tools).

We should also spare a thought for other communities using or that might
use RCU.

My current focus is to see if there is something that can be done to make
"sdep" rather than "dep" acceptable to the theorists.  The "dep" is a
simple syntactic dependency, similar to "carries a dependency" in C11.
In contrast, "sdep" is a semantic dependency, which requires that there
be some values at the head of the dependency chain that cause different
values to appear at the tail of that same chain.  This motivates a detour
through the "out of thin air" (OOTA) problem, which the Java guys have
been beating their heads against for more than ten years and which was
the subject of a meeting in Cambridge UK at the end of last month.
Several of us think we might have a way to make this work, but also
requires semantic rather than simple syntactic dependencies.  For the
sufficiently masochistic, the current state of OOTA is here:

	http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2014/n4216.html

If you have trouble accessing it, here is a copy on my web site:

	http://www.rdrop.com/users/paulmck/scalability/paper/OOTA.2014.10.10a.html

So no solution yet, but hopefully getting there.  Next step is the C++
standards committee meeting at UIUC the first full week of November.

							Thanx, Paul

