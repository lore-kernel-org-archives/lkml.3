Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab3G2JaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:30:20 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:43362 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab3G2JaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:30:18 -0400
MIME-Version: 1.0
In-Reply-To: <1375075701-5998-6-git-send-email-iamjoonsoo.kim@lge.com>
References: <1375075701-5998-1-git-send-email-iamjoonsoo.kim@lge.com>
	<1375075701-5998-6-git-send-email-iamjoonsoo.kim@lge.com>
Date: Mon, 29 Jul 2013 17:30:17 +0800
Message-ID: <CAJd=RBC5XwDp9p1b48EgkfRAQ=zVj0=TG_qFQrQ325RsFM5zsQ@mail.gmail.com>
Subject: Re: [PATCH v3 5/9] mm, hugetlb: remove redundant list_empty check in gather_surplus_pages()
From: Hillf Danton <dhillf@gmail.com>
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
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 1:28 PM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> If list is empty, list_for_each_entry_safe() doesn't do anything.
> So, this check is redundant. Remove it.
>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
Acked-by: Hillf Danton <dhillf@gmail.com>

> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 87d7637..2e52afea 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1020,11 +1020,8 @@ free:
>         spin_unlock(&hugetlb_lock);
>
>         /* Free unnecessary surplus pages to the buddy allocator */
> -       if (!list_empty(&surplus_list)) {
> -               list_for_each_entry_safe(page, tmp, &surplus_list, lru) {
> -                       put_page(page);
> -               }
> -       }
> +       list_for_each_entry_safe(page, tmp, &surplus_list, lru)
> +               put_page(page);
>         spin_lock(&hugetlb_lock);
>
>         return ret;
> --
> 1.7.9.5
>
