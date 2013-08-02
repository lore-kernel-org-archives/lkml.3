Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab3HBUek (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:34:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:46357 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752621Ab3HBUej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:34:39 -0400
Date: Fri, 2 Aug 2013 15:34:57 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH] Add per-process flag to control thp
Message-ID: <20130802203457.GR26476@sgi.com>
References: <20130802194659.GP26476@sgi.com>
 <20130802201301.A872BE0090@blue.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802201301.A872BE0090@blue.fi.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What kind of workloads are you talking about?

Our benchmarking team has a list of several of the SPEC OMP benchmarks
that perform significantly better when THP is disabled. I tried to get
the list but one of our servers is acting up and I can't get to it
right now :/

> What's wrong with madvise? Could you elaborate?

The main issue with using madvise is that it's not an option with static
binaries, but there are also some users who have legacy Fortran code
that they're not willing/able to change.

> And I think thp_disabled should be reset to 0 on exec.

The main purpose for this getting carried down from the parent process
is that we'd like to be able to have a userland program set this flag on
itself, and then spawn off children who will also carry the flag.
This allows us to set the flag for programs where we're unable to modify
the code, thus resolving the issues detailed above.
