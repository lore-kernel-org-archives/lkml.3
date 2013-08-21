Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751880Ab3HUJae (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:30:34 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:38982 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab3HUJad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:30:33 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH v2 04/20] mm, hugetlb: remove useless check about mapping type
In-Reply-To: <1376040398-11212-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com> <1376040398-11212-5-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Wed, 21 Aug 2013 15:00:24 +0530
Message-ID: <87siy3gzm7.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082109-9574-0000-0000-000009456014
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> is_vma_resv_set(vma, HPAGE_RESV_OWNER) implys that this mapping is
> for private. So we don't need to check whether this mapping is for
> shared or not.
>
> This patch is just for clean-up.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index ea1ae0a..c017c52 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2544,8 +2544,7 @@ retry_avoidcopy:
>  	 * at the time of fork() could consume its reserves on COW instead
>  	 * of the full address range.
>  	 */
> -	if (!(vma->vm_flags & VM_MAYSHARE) &&
> -			is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
> +	if (is_vma_resv_set(vma, HPAGE_RESV_OWNER) &&
>  			old_page != pagecache_page)
>  		outside_reserve = 1;
>
> -- 
> 1.7.9.5

