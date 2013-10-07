Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab3JGJs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 05:48:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:46137 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755256Ab3JGJs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 05:48:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1049,1371106800"; 
   d="scan'208";a="406482368"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Kees Cook <keescook@chromium.org>, Mel Gorman <mgorman@suse.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Rik van Riel <riel@redhat.com>, Robin Holt <robinmholt@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20131004203147.GE32110@sgi.com>
References: <1380287787-30252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20131004201213.GB32110@sgi.com>
 <20131004202602.2D389E0090@blue.fi.intel.com>
 <20131004203147.GE32110@sgi.com>
Subject: Re: [PATCHv4 00/10] split page table lock for PMD tables
Content-Transfer-Encoding: 7bit
Message-Id: <20131007094820.13A0CE0090@blue.fi.intel.com>
Date: Mon,  7 Oct 2013 12:48:20 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton wrote:
> > > Sorry for the delay on these results.  I hit some strange issues with
> > > running thp_memscale on systems with either of the following
> > > combinations of configuration options set:
> > > 
> > > [thp off]
> > > HUGETLBFS=y
> > > HUGETLB_PAGE=y
> > > NUMA_BALANCING=y
> > > NUMA_BALANCING_DEFAULT_ENABLED=y
> > > 
> > > [thp on or off]
> > > HUGETLBFS=n
> > > HUGETLB_PAGE=n
> > > NUMA_BALANCING=y
> > > NUMA_BALANCING_DEFAULT_ENABLED=y
> > > 
> > > I'm getting segfaults intermittently, as well as some weird RCU sched
> > > errors.  This happens in vanilla 3.12-rc2, so it doesn't have anything
> > > to do with your patches, but I thought I'd let you know.  There didn't
> > > used to be any issues with this test, so I think there's a subtle kernel
> > > bug here.  That's, of course, an entirely separate issue though.
> > 
> > I'll take a look next week, if nobody does it before.
> 
> I'm starting a bisect now.  Not sure how long it'll take, but I'll keep
> you posted.

I don't see the issue. Could you share your kernel config?

-- 
 Kirill A. Shutemov
