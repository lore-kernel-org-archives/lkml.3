Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162772Ab3DEUdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:33:36 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:60456 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162735Ab3DEUdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:33:35 -0400
Message-ID: <515F351C.403@gmail.com>
Date: Fri, 05 Apr 2013 16:33:32 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 01/10] migrate: add migrate_entry_wait_huge()
References: <1363983835-20184-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1363983835-20184-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1363983835-20184-2-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git v3.9-rc3.orig/mm/hugetlb.c v3.9-rc3/mm/hugetlb.c
> index 0a0be33..98a478e 100644
> --- v3.9-rc3.orig/mm/hugetlb.c
> +++ v3.9-rc3/mm/hugetlb.c
> @@ -2819,7 +2819,7 @@ int hugetlb_fault(struct mm_struct *mm, struct vm_area_struct *vma,
>  	if (ptep) {
>  		entry = huge_ptep_get(ptep);
>  		if (unlikely(is_hugetlb_entry_migration(entry))) {
> -			migration_entry_wait(mm, (pmd_t *)ptep, address);
> +			migration_entry_wait_huge(mm, (pmd_t *)ptep, address);

Hm.

How do you test this? From x86 point of view, this patch seems unnecessary because
hugetlb_fault call "address &= hugetlb_mask()" at first and then migration_entry_wait()
could grab right pte lock. And from !x86 point of view, this funciton still doesn't work
because huge page != pmd on some arch.

I might be missing though.
