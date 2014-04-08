Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932096AbaDHCBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 22:01:46 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45547 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755384AbaDHCBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 22:01:43 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v2.0.1
X-SHieldMailCheckerPolicyVersion: FJ-ISEC-20120718-3
Message-ID: <5343585D.1020206@jp.fujitsu.com>
Date: Tue, 8 Apr 2014 11:01:01 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Luiz Capitulino <lcapitulino@redhat.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <mtosatti@redhat.com>, <aarcange@redhat.com>, <mgorman@suse.de>,
        <akpm@linux-foundation.org>, <andi@firstfloor.org>, <davidlohr@hp.com>,
        <rientjes@google.com>, <yinghai@kernel.org>, <riel@redhat.com>
Subject: Re: [PATCH 2/4] hugetlb: update_and_free_page(): don't clear PG_reserved
 bit
References: <1396462128-32626-1-git-send-email-lcapitulino@redhat.com> <1396462128-32626-3-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1396462128-32626-3-git-send-email-lcapitulino@redhat.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-SecurityPolicyCheck-GC: OK by FENCE-Mail
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/03 3:08), Luiz Capitulino wrote:
> Hugepages pages never get the PG_reserved bit set, so don't clear it. But
> add a warning just in case.
> 
> Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
> ---

Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks,
Yasuaki Ishimatsu

>   mm/hugetlb.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 8c50547..7e07e47 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -581,8 +581,9 @@ static void update_and_free_page(struct hstate *h, struct page *page)
>   	for (i = 0; i < pages_per_huge_page(h); i++) {
>   		page[i].flags &= ~(1 << PG_locked | 1 << PG_error |
>   				1 << PG_referenced | 1 << PG_dirty |
> -				1 << PG_active | 1 << PG_reserved |
> -				1 << PG_private | 1 << PG_writeback);
> +				1 << PG_active | 1 << PG_private |
> +				1 << PG_writeback);
> +		WARN_ON(PageReserved(&page[i]));
>   	}
>   	VM_BUG_ON_PAGE(hugetlb_cgroup_from_page(page), page);
>   	set_compound_page_dtor(page, NULL);
> 


