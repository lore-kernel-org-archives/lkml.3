Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265Ab3IMPUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:20:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:63451 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757129Ab3IMPUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:20:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,898,1371106800"; 
   d="scan'208";a="402893485"
Message-ID: <52332D32.8070302@intel.com>
Date: Fri, 13 Sep 2013 08:20:18 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Alex Thorlton <athorlton@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Dave Jones <davej@redhat.com>,
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
Subject: Re: [PATCH 1/9] mm: rename SPLIT_PTLOCKS to SPLIT_PTE_PTLOCKS
References: <20130910074748.GA2971@gmail.com> <1379077576-2472-1-git-send-email-kirill.shutemov@linux.intel.com> <1379077576-2472-2-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1379077576-2472-2-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 06:06 AM, Kirill A. Shutemov wrote:
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -207,7 +207,7 @@ config PAGEFLAGS_EXTENDED
>  # PA-RISC 7xxx's spinlock_t would enlarge struct page from 32 to 44 bytes.
>  # DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC spinlock_t also enlarge struct page.
>  #
> -config SPLIT_PTLOCK_CPUS
> +config SPLIT_PTE_PTLOCK_CPUS
>  	int
>  	default "999999" if ARM && !CPU_CACHE_VIPT
>  	default "999999" if PARISC && !PA20

If someone has a config where this is set to some non-default value,
won't changing the name cause this to revert back to the defaults?

I don't know how big of a deal it is to other folks, but you can always
do this:

config SPLIT_PTE_PTLOCK_CPUS
  	int
	default SPLIT_PTLOCK_CPUS if SPLIT_PTLOCK_CPUS

