Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3HLNbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 09:31:35 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:24548 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3HLNbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 09:31:34 -0400
Message-ID: <1376314277.3364.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2 04/20] mm, hugetlb: remove useless check about
 mapping type
From: Davidlohr Bueso <davidlohr@hp.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>
Date: Mon, 12 Aug 2013 06:31:17 -0700
In-Reply-To: <1376040398-11212-5-git-send-email-iamjoonsoo.kim@lge.com>
References: <1376040398-11212-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1376040398-11212-5-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-09 at 18:26 +0900, Joonsoo Kim wrote:
> is_vma_resv_set(vma, HPAGE_RESV_OWNER) implys that this mapping is
> for private. So we don't need to check whether this mapping is for
> shared or not.
> 
> This patch is just for clean-up.
> 
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

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


