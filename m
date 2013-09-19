Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3ISRQ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 13:16:58 -0400
Received: from relay1.sgi.com ([192.48.179.29]:41947 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab3ISRQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 13:16:57 -0400
Date: Thu, 19 Sep 2013 12:17:27 -0500
From: Alex Thorlton <athorlton@sgi.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
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
Subject: Re: [PATCHv2 0/9] split page table lock for PMD tables
Message-ID: <20130919171727.GC6802@sgi.com>
References: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 02:25:31PM +0300, Kirill A. Shutemov wrote:
> Alex Thorlton noticed that some massivly threaded workloads work poorly,
> if THP enabled. This patchset fixes this by introducing split page table
> lock for PMD tables. hugetlbfs is not covered yet.
> 
> This patchset is based on work by Naoya Horiguchi.
> 
> Changes:
>  v2:
>   - reuse CONFIG_SPLIT_PTLOCK_CPUS for PMD split lock;
>   - s/huge_pmd_lock/pmd_lock/g;
>   - assume pgtable_pmd_page_ctor() can fail;
>   - fix format line in task_mem() for VmPTE;
> 
> Benchmark (from Alex): ftp://shell.sgi.com/collect/appsx_test/pthread_test.tar.gz
> Run on 4 socket Westmere with 128 GiB of RAM.

Kirill,

I'm hitting some performance issues with these patches on our larger
machines (>=128 cores/256 threads).  I've managed to livelock larger
systems with one of our tests (I'll publish this one soon), and I'm
actually seeing a performance hit on some of the smaller ones.  I'm
currently collecting some results to show the problems I'm hitting,
and trying to research what's causing the livelock.  For now I just
wanted to let you know that I'm seeing some issues.  I'll be in touch
with more details.

Sorry for the delayed response, I wanted to be really sure that I was
seeing problems before I put up a red flag.

- Alex
