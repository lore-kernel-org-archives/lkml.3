Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3GOObg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:31:36 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:53898 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757583Ab3GOObe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:31:34 -0400
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
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 5/9] mm, hugetlb: remove redundant list_empty check in gather_surplus_pages()
In-Reply-To: <1373881967-16153-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1373881967-16153-1-git-send-email-iamjoonsoo.kim@lge.com> <1373881967-16153-6-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.15.2+167~g5306b2b (http://notmuchmail.org) Emacs/24.3.50.1 (x86_64-unknown-linux-gnu)
Date: Mon, 15 Jul 2013 20:01:24 +0530
Message-ID: <87vc4bj3nn.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071514-1396-0000-0000-00000342B9C2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joonsoo Kim <iamjoonsoo.kim@lge.com> writes:

> If list is empty, list_for_each_entry_safe() doesn't do anything.
> So, this check is redundant. Remove it.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index a838e6b..d4a1695 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1019,10 +1019,8 @@ free:
>  	spin_unlock(&hugetlb_lock);
>
>  	/* Free unnecessary surplus pages to the buddy allocator */
> -	if (!list_empty(&surplus_list)) {
> -		list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> -			put_page(page);
> -		}
> +	list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> +		put_page(page);
>  	}

You can now remove '{' 


>  	spin_lock(&hugetlb_lock);
>
> -- 
> 1.7.9.5

