Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934953AbaEaALQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 20:11:16 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:52128 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934638AbaEaALO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 20:11:14 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Mel Gorman <mgorman@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma reserved memory when not used
In-Reply-To: <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com> <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140531:hannes@cmpxchg.org::QXJopkXVHUkNCowY:00000000000000000000000000000000000000000000WSj
X-Hashcash: 1:20:140531:m.szyprowski@samsung.com::qXmIFo8BMUQVvvbb:00000000000000000000000000000000000002AwG
X-Hashcash: 1:20:140531:aneesh.kumar@linux.vnet.ibm.com::llwmMoStR8xgD420:0000000000000000000000000000001wWa
X-Hashcash: 1:20:140531:mgorman@suse.de::SKohIgP05R8mquGp:002g4x
X-Hashcash: 1:20:140531:riel@redhat.com::vL8WlBNTX/PxAIRY:002v0v
X-Hashcash: 1:20:140531:linux-mm@kvack.org::O4tTwZcIV5ojQtzp:00000000000000000000000000000000000000000004vjX
X-Hashcash: 1:20:140531:heesub.shin@samsung.com::W0eXuQLF/L6XAlze:000000000000000000000000000000000000004D9T
X-Hashcash: 1:20:140531:linux-kernel@vger.kernel.org::GBZ7zQlNJU0J8NZp:0000000000000000000000000000000005I7s
X-Hashcash: 1:20:140531:akpm@linux-foundation.org::7JMib4RBwWd7HfHs:0000000000000000000000000000000000005omb
X-Hashcash: 1:20:140531:minchan@kernel.org::Vnxw2wSp3rjOye8u:00000000000000000000000000000000000000000006f/r
X-Hashcash: 1:20:140531:iamjoonsoo.kim@lge.com::fKGnfWw9C89P89PO:000000000000000000000000000000000000000CGdv
X-Hashcash: 1:20:140531:lauraa@codeaurora.org::k7qIk7Z9VGgNbsOJ:0000000000000000000000000000000000000000CKWZ
X-Hashcash: 1:20:140531:iamjoonsoo.kim@lge.com::MseT7l11WjQw6xIL:000000000000000000000000000000000000000P2ra
Date: Sat, 31 May 2014 09:11:07 +0900
Message-ID: <xa1tegzahko4.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> @@ -1143,10 +1223,15 @@ __rmqueue_fallback(struct zone *zone, int order, int start_migratetype)
>  static struct page *__rmqueue(struct zone *zone, unsigned int order,
>  						int migratetype)
>  {
> -	struct page *page;
> +	struct page *page = NULL;
> +
> +	if (IS_ENABLED(CONFIG_CMA) &&
> +		migratetype == MIGRATE_MOVABLE && zone->managed_cma_pages)
> +		page = __rmqueue_cma(zone, order);

Come to think of it, I would consider:

	if (…) {
		page = __rmqueue_cma(zone, order);
		if (page)
			goto done
	}

	…

done:
	trace_mm_page_alloc_zone_locked(page, order, migratetype);
	return page;

>  
>  retry_reserve:
> -	page = __rmqueue_smallest(zone, order, migratetype);
> +	if (!page)
> +		page = __rmqueue_smallest(zone, order, migratetype);
>  

The above would allow this if statement to go away.

>  	if (unlikely(!page) && migratetype != MIGRATE_RESERVE) {
>  		page = __rmqueue_fallback(zone, order, migratetype);

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
