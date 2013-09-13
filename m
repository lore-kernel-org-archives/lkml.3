Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab3IMT6P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 15:58:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:8370 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754168Ab3IMT6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 15:58:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,900,1371106800"; 
   d="scan'208";a="403043841"
Message-ID: <52336E41.40307@intel.com>
Date: Fri, 13 Sep 2013 12:57:53 -0700
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
Subject: Re: [PATCH 8/9] mm: implement split page table lock for PMD level
References: <20130910074748.GA2971@gmail.com> <1379077576-2472-1-git-send-email-kirill.shutemov@linux.intel.com> <1379077576-2472-9-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1379077576-2472-9-git-send-email-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 06:06 AM, Kirill A. Shutemov wrote:
> +config ARCH_ENABLE_SPLIT_PMD_PTLOCK
> +	boolean
> +
> +config SPLIT_PMD_PTLOCK_CPUS
> +	int
> +	# hugetlb hasn't converted to split locking yet
> +	default "999999" if HUGETLB_PAGE
> +	default "32" if ARCH_ENABLE_SPLIT_PMD_PTLOCK
> +	default "999999"

Is there a reason we should have separate config knobs for this from
SPLIT_PTLOCK_CPUS?  Seem a bit silly.
