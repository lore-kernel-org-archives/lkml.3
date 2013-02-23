Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3BWHFc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 02:05:32 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:32811 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab3BWHFb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 02:05:31 -0500
MIME-Version: 1.0
In-Reply-To: <1361475708-25991-9-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1361475708-25991-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1361475708-25991-9-git-send-email-n-horiguchi@ah.jp.nec.com>
Date: Sat, 23 Feb 2013 15:05:30 +0800
Message-ID: <CAJd=RBDvqFYUgy+d=DJTBZoaafXoDP+QodAh2CzV2XpDMjaw7Q@mail.gmail.com>
Subject: Re: [PATCH 8/9] memory-hotplug: enable memory hotplug to handle hugepage
From: Hillf Danton <dhillf@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        Hillf Danton <dhillf@gmail.com>, Michal Hocko <mhocko@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Naoya

[add Michal in cc list]

On Fri, Feb 22, 2013 at 3:41 AM, Naoya Horiguchi
<n-horiguchi@ah.jp.nec.com> wrote:
>
> +/* Returns true for head pages of in-use hugepages, otherwise returns false. */
> +int is_hugepage_movable(struct page *hpage)
s/int/bool/  can we?
> +{
> +       struct page *page;
> +       struct page *tmp;
> +       struct hstate *h = page_hstate(hpage);
Make sense to compute hstate for a tail page?
> +       int ret = 0;
> +
> +       VM_BUG_ON(!PageHuge(hpage));
> +       if (PageTail(hpage))
> +               return 0;
VM_BUG_ON(!PageHuge(hpage) || PageTail(hpage)), can we?
> +       spin_lock(&hugetlb_lock);
> +       list_for_each_entry_safe(page, tmp, &h->hugepage_activelist, lru)
s/_safe//  can we?
> +               if (page == hpage)
> +                       ret = 1;
Can we bail out with ret set to be true?
> +       spin_unlock(&hugetlb_lock);
> +       return ret;
> +}
