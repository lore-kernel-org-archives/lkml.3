Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab3HGA43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 20:56:29 -0400
Received: from mga02.intel.com ([134.134.136.20]:59625 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739Ab3HGA4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 20:56:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,829,1367996400"; 
   d="scan'208";a="358681243"
Subject: Re: Performance regression from switching lock to rw-sem for
 anon-vma tree
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Andrea Arcangeli <aarcange@redhat.com>,
        Mel Gorman <mgorman@suse.de>, "Shi, Alex" <alex.shi@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm <linux-mm@kvack.org>
In-Reply-To: <1375833325.2134.36.camel@buesod1.americas.hpqcorp.net>
References: <1372366385.22432.185.camel@schen9-DESK>
	 <1372375873.22432.200.camel@schen9-DESK> <20130628093809.GB29205@gmail.com>
	 <1372453461.22432.216.camel@schen9-DESK> <20130629071245.GA5084@gmail.com>
	 <1372710497.22432.224.camel@schen9-DESK> <20130702064538.GB3143@gmail.com>
	 <1373997195.22432.297.camel@schen9-DESK> <20130723094513.GA24522@gmail.com>
	 <20130723095124.GW27075@twins.programming.kicks-ass.net>
	 <20130723095306.GA26174@gmail.com> <1375143209.22432.419.camel@schen9-DESK>
	 <1375833325.2134.36.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Aug 2013 17:56:28 -0700
Message-ID: <1375836988.22432.435.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 16:55 -0700, Davidlohr Bueso wrote:

> I got good numbers, recovering the performance drop I noticed with the
> i_mmap_mutex to rwsem patches.

That's good.  I remembered that the earlier version of the patch not
only recovered the performance drop, but also provide some boost when
you switch from i_mmap_mutex to rwsem for aim7.  Do you see similar
boost with this version?

>  Looking forward to a more upstreamable
> patchset that deals with this work, including the previous patches.
> 
> One thing that's bugging me about this series though is the huge amount
> of duplicated code being introduced to rwsems from mutexes. We can share
> common functionality such as mcs locking (perhaps in a new file under
> lib/), can_spin_on_owner() and owner_running(), perhaps moving those
> functions into sheduler code, were AFAIK they were originally.

I think that MCS locking is worth breaking out as its
own library.  After we've done that, the rest of
the duplication are minimal. It is easier
to keep them separate as there are some rwsem 
specific logic that may require tweaking
to can_spin_on_owner and owner_running.  

Thanks.

Tim

