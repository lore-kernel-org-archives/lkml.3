Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab3IPMMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:12:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:47041 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757359Ab3IPMMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:12:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,914,1371106800"; 
   d="scan'208";a="378836482"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
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
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Robin Holt <robinmholt@gmail.com>, Sedat Dilek <sedat.dilek@gmail.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
In-Reply-To: <20130916114404.GC9326@twins.programming.kicks-ass.net>
References: <1379330740-5602-1-git-send-email-kirill.shutemov@linux.intel.com>
 <20130916114404.GC9326@twins.programming.kicks-ass.net>
Subject: Re: [PATCHv2 0/9] split page table lock for PMD tables
Content-Transfer-Encoding: 7bit
Message-Id: <20130916121154.3525EE0090@blue.fi.intel.com>
Date: Mon, 16 Sep 2013 15:11:54 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> >   - reuse CONFIG_SPLIT_PTLOCK_CPUS for PMD split lock;
> 
> So why is there still CONFIG_SPLIT_PTE_PTLOCK and
> CONFIG_SPLIT_PMD_PTLOCK in the series?

There is not.

We have USE_SPLIT_{PTE,PMD}_PTLOCK. We can't use split pmd lock everywhere
split pte lock is available: it requires separate enabling on arch side
and will not work on all hardware (i.e. with 2-level page table
configuration).

-- 
 Kirill A. Shutemov
