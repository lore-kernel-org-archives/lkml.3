Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965759Ab3GSFkl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 01:40:41 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:62756 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965646Ab3GSFkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 01:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <1374183272-10153-8-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1374183272-10153-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1374183272-10153-8-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Fri, 19 Jul 2013 13:40:38 +0800
Message-ID: <CAJd=RBBs7R1e4BaGDORcO+X3trQWcgmEm4UX2EpwXQyDqw2m9w@mail.gmail.com>
Subject: Re: [PATCH 7/8] memory-hotplug: enable memory hotplug to handle hugepage
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Michal Hocko <mhocko@suse.cz>,
        Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 5:34 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
> @@ -518,9 +519,11 @@ static struct page *dequeue_huge_page_node(struct hstate *h, int nid)
>  {
>         struct page *page;
>
> -       if (list_empty(&h->hugepage_freelists[nid]))
> +       list_for_each_entry(page, &h->hugepage_freelists[nid], lru)
> +               if (!is_migrate_isolate_page(page))
> +                       break;
> +       if (&h->hugepage_freelists[nid] == &page->lru)

For what is this check?

>                 return NULL;
> -       page = list_entry(h->hugepage_freelists[nid].next, struct page, lru);
>         list_move(&page->lru, &h->hugepage_activelist);
>         set_page_refcounted(page);
>         h->free_huge_pages--;
