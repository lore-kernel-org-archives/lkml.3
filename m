Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab3ICGjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 02:39:09 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56610 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab3ICGjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 02:39:07 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <522583DE.709@jp.fujitsu.com>
Date: Tue, 3 Sep 2013 15:38:22 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
CC: <akpm@linux-foundation.org>, <mgorman@suse.de>, <hannes@cmpxchg.org>,
        <tony.luck@intel.com>, <matthew.garrett@nebula.com>, <dave@sr71.net>,
        <riel@redhat.com>, <arjan@linux.intel.com>,
        <srinivas.pandruvada@linux.intel.com>, <willy@linux.intel.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <lenb@kernel.org>, <rjw@sisk.pl>,
        <gargankita@gmail.com>, <paulmck@linux.vnet.ibm.com>,
        <svaidy@linux.vnet.ibm.com>, <andi@firstfloor.org>,
        <santosh.shilimkar@ti.com>, <kosaki.motohiro@gmail.com>,
        <linux-pm@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v3 09/35] mm: Track the freepage migratetype of pages
 accurately
References: <20130830131221.4947.99764.stgit@srivatsabhat.in.ibm.com> <20130830131635.4947.81565.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130830131635.4947.81565.stgit@srivatsabhat.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/30 22:16), Srivatsa S. Bhat wrote:
> Due to the region-wise ordering of the pages in the buddy allocator's
> free lists, whenever we want to delete a free pageblock from a free list
> (for ex: when moving blocks of pages from one list to the other), we need
> to be able to tell the buddy allocator exactly which migratetype it belongs
> to. For that purpose, we can use the page's freepage migratetype (which is
> maintained in the page's ->index field).
>
> So, while splitting up higher order pages into smaller ones as part of buddy
> operations, keep the new head pages updated with the correct freepage
> migratetype information (because we depend on tracking this info accurately,
> as outlined above).
>
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> ---
>
>   mm/page_alloc.c |    7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 398b62c..b4b1275 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -947,6 +947,13 @@ static inline void expand(struct zone *zone, struct page *page,
>   		add_to_freelist(&page[size], &area->free_list[migratetype]);
>   		area->nr_free++;
>   		set_page_order(&page[size], high);
> +
> +		/*
> +		 * Freepage migratetype is tracked using the index field of the
> +		 * first page of the block. So we need to update the new first
> +		 * page, when changing the page order.
> +		 */
> +		set_freepage_migratetype(&page[size], migratetype);
>   	}
>   }
>
>

It this patch a bug fix patch?
If so, I want you to split the patch from the patch-set.

Thanks,
Yasuaki Ishimatsu


