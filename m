Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759671Ab3GaLtO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:49:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51109 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab3GaLtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:49:10 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-77-51f8f9b5d54c
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, liuj97@gmail.com,
        kosaki.motohiro@gmail.com, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: Re: [PATCH] Revert
 "mm/memory-hotplug: fix lowmem count overflow when offline pages"
Date: Wed, 31 Jul 2013 13:48:51 +0200
Message-id: <3049413.HnxJdeugZK@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-45-generic; KDE/4.8.5; i686; ; )
In-reply-to: <1572085.gN7iX7IvMe@amdc1032>
References: <1375260602-2462-1-git-send-email-jy0922.shim@samsung.com>
 <1572085.gN7iX7IvMe@amdc1032>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=ISO-8859-1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jAd2tP38EGlxtFrOYs34Nm8WLexdZ
	LJ5t4ba4vGsOm8W9Nf9ZLZqPbGSy2HZ4B5MDu8fOWXfZPTZ9msTucWLGbxaPB4c2s3j0bVnF
	6PF5k1wAWxSXTUpqTmZZapG+XQJXxpHnU9gK9glU9F43amBcydvFyMEhIWAiseqUbxcjJ5Ap
	JnHh3nq2LkYuDiGBRYwSb3r+sEA4LUwS67r/sINUsQlYSUxsX8UI0iwioCOx4SQ7SA2zwApG
	iU/XJjKB1AgLxEvcfX0CzGYRUJU49mw2G4jNK6Ap0fv+PTOILSrgKnFu0Q8WkDmcAloS0xby
	goSFBNIktq08xwpRLijxY/I9FhCbWUBeYt/+qawQto7E/tZpbBMYBWYhKZuFpGwWkrIFjMyr
	GEVTC5ILipPSc430ihNzi0vz0vWS83M3MYID/Zn0DsZVDRaHGAU4GJV4eGdc+h4oxJpYVlyZ
	e4hRgoNZSYRXPuhHoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXHeg63WgUIC6YklqdmpqQWpRTBZ
	Jg5OqQZGVmc5Ta5fTG7zNudX781mufPy90neMqNzyuJrp7Vz3xZK3/PDn6F/W8SaVZfudx7Y
	dfEfT/IcsxsXmSf/+9OpmPE5JUl0jvDPWVLrjM6IWj90OqF+Y/qe+pfv5Wq0G+OPG8VqsK0W
	VtkTV7XS6tOFhPsVdzee+vrtfzp/0PaCb2XbBOdaCz4xVmIpzkg01GIuKk4EAMvFdp1wAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 31, 2013 01:17:46 PM Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Wednesday, July 31, 2013 05:50:02 PM Joonyoung Shim wrote:
> > This reverts commit cea27eb2a202959783f81254c48c250ddd80e129.
> 
> Could you please also include commit descriptions, i.e.
> commit cea27eb2a202959783f81254c48c250ddd80e129 ("mm/memory-hotplug: fix
> lowmem count overflow when offline pages")?
> 
> > Fixed to adjust totalhigh_pages when hot-removing memory by commit
> > 3dcc0571cd64816309765b7c7e4691a4cadf2ee7, so that commit occurs
> > duplicated decreasing of totalhigh_pages.
> 
> Could you please describe it a bit more (because it is non-obvious) how
> the commit cea27eb effectively does the same totalhigh_pages adjustment
> that is present in the commit 3dcc057?

Err, the other way around. How the commit 3dcc057 ("mm: correctly update
zone->managed_pages") does what cea27eb ("mm/memory-hotplug: fix lowmem
count overflow when offline pages") did.

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung R&D Institute Poland
Samsung Electronics

> > Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> > ---
> > The commit cea27eb2a202959783f81254c48c250ddd80e129 is only for stable,
> > is it right?
> 
> It is in Linus' tree now but you're probably right that it should be
> limited to stable tree.
> 
> Best regards,
> --
> Bartlomiej Zolnierkiewicz
> Samsung R&D Institute Poland
> Samsung Electronics
> 
> >  mm/page_alloc.c | 4 ----
> >  1 file changed, 4 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index b100255..2b28216 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -6274,10 +6274,6 @@ __offline_isolated_pages(unsigned long start_pfn, unsigned long end_pfn)
> >  		list_del(&page->lru);
> >  		rmv_page_order(page);
> >  		zone->free_area[order].nr_free--;
> > -#ifdef CONFIG_HIGHMEM
> > -		if (PageHighMem(page))
> > -			totalhigh_pages -= 1 << order;
> > -#endif
> >  		for (i = 0; i < (1 << order); i++)
> >  			SetPageReserved((page+i));
> >  		pfn += (1 << order);

