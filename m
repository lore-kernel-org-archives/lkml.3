Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763229Ab3DCUEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759768Ab3DCUEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:04:49 -0400
Message-ID: <515C8AB1.7060003@redhat.com>
Date: Wed, 03 Apr 2013 16:01:53 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] hugetlbfs: add swap entry check in follow_hugetlb_page()
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1365014138-19589-4-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1365014138-19589-4-git-send-email-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2013 02:35 PM, Naoya Horiguchi wrote:
> With applying the previous patch "hugetlbfs: stop setting VM_DONTDUMP in
> initializing vma(VM_HUGETLB)" to reenable hugepage coredump, if a memory
> error happens on a hugepage and the affected processes try to access
> the error hugepage, we hit VM_BUG_ON(atomic_read(&page->_count) <= 0)
> in get_page().
>
> The reason for this bug is that coredump-related code doesn't recognise
> "hugepage hwpoison entry" with which a pmd entry is replaced when a memory
> error occurs on a hugepage.
> In other words, physical address information is stored in different bit layout
> between hugepage hwpoison entry and pmd entry, so follow_hugetlb_page()
> which is called in get_dump_page() returns a wrong page from a given address.
>
> We need to filter out only hwpoison hugepages to have data on healthy
> hugepages in coredump. So this patch makes follow_hugetlb_page() avoid
> trying to get page when a pmd is in swap entry like format.
>
> ChangeLog v3:
>   - add comment about using is_swap_pte()
>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>
> Acked-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: stable@vger.kernel.org

Reviewed-by: Rik van Riel <riel@redhat.com>

