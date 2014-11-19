Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaKSIOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:14:36 -0500
Received: from TYO202.gate.nec.co.jp ([210.143.35.52]:63856 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbaKSIOe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:14:34 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>, Christoph Lameter <cl@gentwo.org>,
        Steve Capper <steve.capper@linaro.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 16/19] thp: update documentation
Thread-Topic: [PATCH 16/19] thp: update documentation
Thread-Index: AQHP+QfRldTrY5YrLUiSr9ajSolY4JxnFxAA
Date: Wed, 19 Nov 2014 08:07:59 +0000
Message-ID: <20141119080828.GA11447@hori1.linux.bs1.fc.nec.co.jp>
References: <1415198994-15252-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1415198994-15252-17-git-send-email-kirill.shutemov@linux.intel.com>
In-Reply-To: <1415198994-15252-17-git-send-email-kirill.shutemov@linux.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.128.101.22]
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <86738F71C2FE06408B3F0D1A192CBF99@gisp.nec.co.jp>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 04:49:51PM +0200, Kirill A. Shutemov wrote:
> The patch updates Documentation/vm/transhuge.txt to reflect changes in
> THP design.
> 
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  Documentation/vm/transhuge.txt | 84 +++++++++++++++++++-----------------------
>  1 file changed, 38 insertions(+), 46 deletions(-)
> 
> diff --git a/Documentation/vm/transhuge.txt b/Documentation/vm/transhuge.txt
> index df1794a9071f..33465e7b0d9b 100644
> --- a/Documentation/vm/transhuge.txt
> +++ b/Documentation/vm/transhuge.txt
> @@ -200,9 +200,18 @@ thp_collapse_alloc_failed is incremented if khugepaged found a range
>  	of pages that should be collapsed into one huge page but failed
>  	the allocation.
>  
> -thp_split is incremented every time a huge page is split into base
> +thp_split_page is incremented every time a huge page is split into base
>  	pages. This can happen for a variety of reasons but a common
>  	reason is that a huge page is old and is being reclaimed.
> +	This action implies splitting all PMD the page mapped with.
> +
> +thp_split_page_failed is is incremented if kernel fails to split huge

'is' appears twice.

> +	page. This can happen if the page was pinned by somebody.
> +
> +thp_split_pmd is incremented every time a PMD split into table of PTEs.
> +	This can happen, for instance, when application calls mprotect() or
> +	munmap() on part of huge page. It doesn't split huge page, only
> +	page table entry.
>  
>  thp_zero_page_alloc is incremented every time a huge zero page is
>  	successfully allocated. It includes allocations which where

There is a sentense related to the adjustment on futex code you just
removed in patch 15/19 in "get_user_pages and follow_page" section.

  ...
  split_huge_page() to avoid the head and tail pages to disappear from
  under it, see the futex code to see an example of that, hugetlbfs also
  needed special handling in futex code for similar reasons).

this seems obsolete, so we need some change on this?

Thanks,
Naoya Horiguchi