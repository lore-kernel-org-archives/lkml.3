Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab3C2N5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 09:57:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57074 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab3C2N5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 09:57:32 -0400
Date: Fri, 29 Mar 2013 14:57:30 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        stable@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hugetlbfs: add swap entry check in
 follow_hugetlb_page()
Message-ID: <20130329135730.GB21879@dhcp22.suse.cz>
References: <1364485358-8745-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1364485358-8745-3-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364485358-8745-3-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-03-13 11:42:38, Naoya Horiguchi wrote:
[...]
> @@ -2968,7 +2968,8 @@ long follow_hugetlb_page(struct mm_struct *mm, struct vm_area_struct *vma,
>  		 * first, for the page indexing below to work.
>  		 */
>  		pte = huge_pte_offset(mm, vaddr & huge_page_mask(h));
> -		absent = !pte || huge_pte_none(huge_ptep_get(pte));
> +		absent = !pte || huge_pte_none(huge_ptep_get(pte)) ||
> +			is_swap_pte(huge_ptep_get(pte));

is_swap_pte doesn't seem right. Shouldn't you use is_hugetlb_entry_hwpoisoned
instead?

-- 
Michal Hocko
SUSE Labs
