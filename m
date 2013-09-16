Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab3IPOgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 10:36:40 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41984 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab3IPOgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 10:36:39 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Alex Thorlton <athorlton@sgi.com>, Mel Gorman <mgorman@suse.de>,
        Andi Kleen <andi@firstfloor.org>, Michal Hocko <mhocko@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] hugetlbfs: support split page table lock
In-Reply-To: <1379117362-gwv3vrog-mutt-n-horiguchi@ah.jp.nec.com>
References: <1379117362-gwv3vrog-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Notmuch/0.16+32~g01f5508 (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 16 Sep 2013 20:06:30 +0530
Message-ID: <878uywbzpt.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091614-3864-0000-0000-00000A186E51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> writes:

> Hi,
>
> Kirill posted split_ptl patchset for thp today, so in this version
> I post only hugetlbfs part. I added Kconfig variables in following
> Kirill's patches (although without CONFIG_SPLIT_*_PTLOCK_CPUS.)
>
> This patch changes many lines, but all are in hugetlbfs specific code,
> so I think we can apply this independent of thp patches.
> -----
> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Fri, 13 Sep 2013 18:12:30 -0400
> Subject: [PATCH v4] hugetlbfs: support split page table lock
>
> Currently all of page table handling by hugetlbfs code are done under
> mm->page_table_lock. So when a process have many threads and they heavily
> access to the memory, lock contention happens and impacts the performance.
>
> This patch makes hugepage support split page table lock so that we use
> page->ptl of the leaf node of page table tree which is pte for normal pages
> but can be pmd and/or pud for hugepages of some architectures.
>
> ChangeLog v4:
>  - introduce arch dependent macro ARCH_ENABLE_SPLIT_HUGETLB_PTLOCK
>    (only defined for x86 for now)
>  - rename USE_SPLIT_PTLOCKS_HUGETLB to USE_SPLIT_HUGETLB_PTLOCKS

Can we have separate locking for THP and hugetlb ? Doesn't both require us to
use same locking when updating pmd ?


-aneesh

