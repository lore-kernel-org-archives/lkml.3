Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936596Ab3DJIHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 04:07:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425Ab3DJIHJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 04:07:09 -0400
Date: Wed, 10 Apr 2013 10:07:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/3] hugetlbfs: add swap entry check in
 follow_hugetlb_page()
Message-ID: <20130410080706.GA20998@dhcp22.suse.cz>
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1365014138-19589-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F1F1F.6060900@gmail.com>
 <1365449252-9pc7knd5-mutt-n-horiguchi@ah.jp.nec.com>
 <CAHGf_=ruv9itn7fhcL=Ar7z_6wQ5Ga_4kj7Ui3EfDUe_cV7D0w@mail.gmail.com>
 <1365544834-c6v2jpoo-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365544834-c6v2jpoo-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 09-04-13 18:00:34, Naoya Horiguchi wrote:
[...]
> I rewrite the comment here, how about this?
> 
> -		if (absent ||
> +		/*
> +		 * We need call hugetlb_fault for both hugepages under migration
> +		 * (in which case hugetlb_fault waits for the migration,) and
> +		 * hwpoisoned hugepages (in which case we need to prevent the
> +		 * caller from accessing to them.) In order to do this, we use
> +		 * here is_swap_pte instead of is_hugetlb_entry_migration and
> +		 * is_hugetlb_entry_hwpoisoned. This is because it simply covers
> +		 * both cases, and because we can't follow correct pages directly
> +		 * from any kind of swap entries.
> +		 */
> +		if (absent || is_swap_pte(huge_ptep_get(pte)) ||
>  		    ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
>  			int ret;

OK, thanks!

-- 
Michal Hocko
SUSE Labs
