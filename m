Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936103Ab3DHU6P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:58:15 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:41537 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935624Ab3DHU6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:58:07 -0400
MIME-Version: 1.0
In-Reply-To: <1365449252-9pc7knd5-mutt-n-horiguchi@ah.jp.nec.com>
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1365014138-19589-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F1F1F.6060900@gmail.com> <1365449252-9pc7knd5-mutt-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 8 Apr 2013 16:57:44 -0400
Message-ID: <CAHGf_=ruv9itn7fhcL=Ar7z_6wQ5Ga_4kj7Ui3EfDUe_cV7D0w@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] hugetlbfs: add swap entry check in follow_hugetlb_page()
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -               if (absent ||
> +               /*
> +                * is_swap_pte test covers both is_hugetlb_entry_hwpoisoned
> +                * and hugepages under migration in which case
> +                * hugetlb_fault waits for the migration and bails out
> +                * properly for HWPosined pages.
> +                */
> +               if (absent || is_swap_pte(huge_ptep_get(pte)) ||
>                     ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
>                         int ret;

Your comment describe what the code is. However we want the comment describe
why. In migration case, calling hugetlb_fault() is natural. but in
hwpoison case, it is
needed more explanation. Why can't we call is_hugetlb_hwpoisoned() directly?
