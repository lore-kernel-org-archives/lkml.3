Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702Ab3ITMcD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 08:32:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:50346 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754467Ab3ITMcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 08:32:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,944,1371106800"; 
   d="scan'208";a="406389069"
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
In-Reply-To: <20130919171727.GC6802@sgi.com>
References: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130919171727.GC6802@sgi.com>
Subject: Re: [PATCHv2 0/9] split page table lock for PMD tables
Content-Transfer-Encoding: 7bit
Message-Id: <20130920123137.BE2F7E0090@blue.fi.intel.com>
Date: Fri, 20 Sep 2013 15:31:37 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Thorlton wrote:
> On Mon, Sep 16, 2013 at 02:25:31PM +0300, Kirill A. Shutemov wrote:
> > Alex Thorlton noticed that some massivly threaded workloads work poorly,
> > if THP enabled. This patchset fixes this by introducing split page table
> > lock for PMD tables. hugetlbfs is not covered yet.
> > 
> > This patchset is based on work by Naoya Horiguchi.
> > 
> > Changes:
> >  v2:
> >   - reuse CONFIG_SPLIT_PTLOCK_CPUS for PMD split lock;
> >   - s/huge_pmd_lock/pmd_lock/g;
> >   - assume pgtable_pmd_page_ctor() can fail;
> >   - fix format line in task_mem() for VmPTE;
> > 
> > Benchmark (from Alex): ftp://shell.sgi.com/collect/appsx_test/pthread_test.tar.gz
> > Run on 4 socket Westmere with 128 GiB of RAM.
> 
> Kirill,
> 
> I'm hitting some performance issues with these patches on our larger
> machines (>=128 cores/256 threads).  I've managed to livelock larger
> systems with one of our tests (I'll publish this one soon), and I'm
> actually seeing a performance hit on some of the smaller ones.

Does "performance hit" mean performance degradation?

> I'm currently collecting some results to show the problems I'm hitting, and
> trying to research what's causing the livelock.  For now I just wanted to let
> you know that I'm seeing some issues.  I'll be in touch with more details.

Looking forward for more details. Thanks for testing.

I'll try to find a bigger machine myself.

-- 
 Kirill A. Shutemov
