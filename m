Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab3G3QvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 12:51:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54302 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231Ab3G3QvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 12:51:00 -0400
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
Subject: Re: [PATCH 02/18] mm, hugetlb: change variable name reservations to resv
In-Reply-To: <1375075929-6119-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075929-6119-1-git-send-email-iamjoonsoo.kim@lge.com> <1375075929-6119-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Tue, 30 Jul 2013 22:20:51 +0530
Message-ID: <87zjt4outw.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13073016-4790-0000-0000-000009899E3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> 'reservations' is so long name as a variable and we use 'resv_map'
> to represent 'struct resv_map' in other place. To reduce confusion and
> unreadability, change it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar <aneesh.kumar@linux.vnet.ibm.com>

>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index d971233..12b6581 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1095,9 +1095,9 @@ static long vma_needs_reservation(struct hstate *h,
>  	} else  {
>  		long err;
>  		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
> -		struct resv_map *reservations = vma_resv_map(vma);
> +		struct resv_map *resv = vma_resv_map(vma);
>
> -		err = region_chg(&reservations->regions, idx, idx + 1);
> +		err = region_chg(&resv->regions, idx, idx + 1);
>  		if (err < 0)
>  			return err;
>  		return 0;
> @@ -1115,10 +1115,10 @@ static void vma_commit_reservation(struct hstate *h,
>
>  	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
>  		pgoff_t idx = vma_hugecache_offset(h, vma, addr);
> -		struct resv_map *reservations = vma_resv_map(vma);
> +		struct resv_map *resv = vma_resv_map(vma);
>
>  		/* Mark this page used in the map. */
> -		region_add(&reservations->regions, idx, idx + 1);
> +		region_add(&resv->regions, idx, idx + 1);
>  	}
>  }
>
> @@ -2168,7 +2168,7 @@ out:
>
>  static void hugetlb_vm_op_open(struct vm_area_struct *vma)
>  {
> -	struct resv_map *reservations = vma_resv_map(vma);
> +	struct resv_map *resv = vma_resv_map(vma);
>
>  	/*
>  	 * This new VMA should share its siblings reservation map if present.
> @@ -2178,34 +2178,34 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
>  	 * after this open call completes.  It is therefore safe to take a
>  	 * new reference here without additional locking.
>  	 */
> -	if (reservations)
> -		kref_get(&reservations->refs);
> +	if (resv)
> +		kref_get(&resv->refs);
>  }
>
>  static void resv_map_put(struct vm_area_struct *vma)
>  {
> -	struct resv_map *reservations = vma_resv_map(vma);
> +	struct resv_map *resv = vma_resv_map(vma);
>
> -	if (!reservations)
> +	if (!resv)
>  		return;
> -	kref_put(&reservations->refs, resv_map_release);
> +	kref_put(&resv->refs, resv_map_release);
>  }
>
>  static void hugetlb_vm_op_close(struct vm_area_struct *vma)
>  {
>  	struct hstate *h = hstate_vma(vma);
> -	struct resv_map *reservations = vma_resv_map(vma);
> +	struct resv_map *resv = vma_resv_map(vma);
>  	struct hugepage_subpool *spool = subpool_vma(vma);
>  	unsigned long reserve;
>  	unsigned long start;
>  	unsigned long end;
>
> -	if (reservations) {
> +	if (resv) {
>  		start = vma_hugecache_offset(h, vma, vma->vm_start);
>  		end = vma_hugecache_offset(h, vma, vma->vm_end);
>
>  		reserve = (end - start) -
> -			region_count(&reservations->regions, start, end);
> +			region_count(&resv->regions, start, end);
>
>  		resv_map_put(vma);
>
> -- 
> 1.7.9.5

