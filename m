Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524Ab3HPOsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 10:48:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49049 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3HPOsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 10:48:04 -0400
Date: Fri, 16 Aug 2013 16:47:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Thorlton <athorlton@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>, Robin Holt <holt@sgi.com>
Subject: Re: [PATCH 0/8] Re: [PATCH] Add per-process flag to control thp
Message-ID: <20130816144742.GZ24092@twins.programming.kicks-ass.net>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
 <1376663644-153546-1-git-send-email-athorlton@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376663644-153546-1-git-send-email-athorlton@sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 09:33:56AM -0500, Alex Thorlton wrote:

> This first set of tests was run on the latest community kernel, with the
> vclear patches:
> 
> Kernel string: Kernel 3.11.0-rc5-medusa-00021-g1a15a96-dirty
> harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# cat /sys/kernel/mm/transparent_hugepage/enabled
> [always] madvise never
> harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# time ./run.sh
> ...
> Done. Terminating the simulation.
> 
> real    25m34.052s
> user    10769m7.948s
> sys     37m46.524s
> 
> harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# echo never > /sys/kernel/mm/transparent_hugepage/enabled
> harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# cat /sys/kernel/mm/transparent_hugepage/enabled
> always madvise [never]
> harp31-sys:/home/estes04/athorlton/Testing/progs/thp_benchmarks/321.equake_l# time ./run.sh
> ...
> Done. Terminating the simulation.
> 
> real    5m0.377s
> user    2202m0.684s
> sys     108m31.816s
> 

This 321.equake_l thing is not public, right? Do you have anything that
is public that shows the same problem?

Do you have any idea where all the extra time is spend? 
