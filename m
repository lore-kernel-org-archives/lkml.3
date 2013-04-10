Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935347Ab3DJByR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 21:54:17 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:54875 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765173Ab3DJByQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 21:54:16 -0400
MIME-Version: 1.0
In-Reply-To: <1365544834-c6v2jpoo-mutt-n-horiguchi@ah.jp.nec.com>
References: <1365014138-19589-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1365014138-19589-4-git-send-email-n-horiguchi@ah.jp.nec.com>
 <515F1F1F.6060900@gmail.com> <1365449252-9pc7knd5-mutt-n-horiguchi@ah.jp.nec.com>
 <CAHGf_=ruv9itn7fhcL=Ar7z_6wQ5Ga_4kj7Ui3EfDUe_cV7D0w@mail.gmail.com> <1365544834-c6v2jpoo-mutt-n-horiguchi@ah.jp.nec.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Tue, 9 Apr 2013 21:53:55 -0400
Message-ID: <CAHGf_=pDuFb4s3hg4M+AKphthgkCgFWMPKb9od7opcvDop4haQ@mail.gmail.com>
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

> I rewrite the comment here, how about this?
>
> -               if (absent ||
> +               /*
> +                * We need call hugetlb_fault for both hugepages under migration
> +                * (in which case hugetlb_fault waits for the migration,) and
> +                * hwpoisoned hugepages (in which case we need to prevent the
> +                * caller from accessing to them.) In order to do this, we use
> +                * here is_swap_pte instead of is_hugetlb_entry_migration and
> +                * is_hugetlb_entry_hwpoisoned. This is because it simply covers
> +                * both cases, and because we can't follow correct pages directly
> +                * from any kind of swap entries.
> +                */
> +               if (absent || is_swap_pte(huge_ptep_get(pte)) ||
>                     ((flags & FOLL_WRITE) && !pte_write(huge_ptep_get(pte)))) {
>                         int ret;

Looks ok to me.
