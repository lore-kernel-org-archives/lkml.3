Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3HFPIN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:08:13 -0400
Received: from relay3.sgi.com ([192.48.152.1]:50128 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754992Ab3HFPIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:08:12 -0400
Date: Tue, 6 Aug 2013 10:08:07 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
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
Subject: Re: [PATCHv2] Add per-process flag to control thp
Message-ID: <20130806150807.GA2456@sgi.com>
References: <20130802205735.GS26476@sgi.com>
 <20130805160306.a620c88ba9098b98a0f93665@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805160306.a620c88ba9098b98a0f93665@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What everyone else said, plus...
> 
> I worry about the inherit-across-fork thing.  A scenario we should
> think about is where the user doesn't build his own executables.  So he
> writes a little wrapper which runs prctl(PR_SET_THP_DISABLED, 0) then
> execs the third-party-app.  But what happens if that app execs children
> who *do* want THP?  He has to hunt down and wrap those as well?
> 
> It all seems a bit unwieldy.  I wonder if controlling it via the ELF
> header would be more practical.

Thanks, Andrew.  I'm doing some more testing and looking into using a
different method for controlling this.  At this point, I think it's fair
to say that we don't want to control this using the method that I've
proposed here, no matter how we look at it.

I've gotten my hands on some of the benchmarks/code that were used to
originally uncover the performance issues we're seeing.  I'm currently
trying to separate out the performance issues that are being caused by
the kernel code from issues involving hardware - the cost of remote
memory accesses is a bit higher on our systems with node controllers vs.
glueless QPI/Hypertransport-based systems.  

At this point, it's difficult to say whether or not the issue can be
solved by "fixing the performance issues with thp," as several have
suggested.  Don't get me wrong I like the idea of that solution as well;
we're just not sure, right now, if that's going to solve all of our
problems.

I'll be back when I've dug up a bit more info on the issue.  Thanks for
the input, everyone!
