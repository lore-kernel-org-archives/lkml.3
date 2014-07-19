Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaGSNvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 09:51:21 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:42662 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754915AbaGSNvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 09:51:19 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Gioh Kim <gioh.kim@lge.com>, Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?J+q5gOykgOyImCc=?= <iamjoonsoo.kim@lge.com>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mel@csn.ul.ie>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        "'Chanho Min'" <chanho.min@lge.com>
Subject: Re: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration
In-Reply-To: <53C8D970.4000908@lge.com>
Organization: http://mina86.com/
References: <53C8C290.90503@lge.com> <53C8D1CA.9070102@samsung.com> <53C8D970.4000908@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140719:linux-mm@kvack.org::BOONuPgWQGdOkost:00000000000000000000000000000000000000000001515
X-Hashcash: 1:20:140719:gioh.kim@lge.com::kuqk2uUIv3E2F5LE:021rd
X-Hashcash: 1:20:140719:lauraa@codeaurora.org::CmBp2+4jzLW7KtRh:00000000000000000000000000000000000000001y2f
X-Hashcash: 1:20:140719:akpm@linux-foundation.org::rP4SZCDU/VwFXEpY:0000000000000000000000000000000000002Q3Z
X-Hashcash: 1:20:140719:linux-kernel@vger.kernel.org::fGUh11pRw1t+6hOg:0000000000000000000000000000000002nQR
X-Hashcash: 1:20:140719:mel@csn.ul.ie::rn9UTzhonejf1VH9:0000469q
X-Hashcash: 1:20:140719:viro@zeniv.linux.org.uk::XjzJdajbI/gAu/lz:000000000000000000000000000000000000004Qwv
X-Hashcash: 1:20:140719:iamjoonsoo.kim@lge.com::rkaVZfKYORk76kLQ:0000000000000000000000000000000000000005EQB
X-Hashcash: 1:20:140719:gunho.lee@lge.com::KJPcD4iLAMfSxJWs:000000000000000000000000000000000000000000006P3g
X-Hashcash: 1:20:140719:m.szyprowski@samsung.com::hGSI4obCp1f7batM:000000000000000000000000000000000000074vN
X-Hashcash: 1:20:140719:hannes@cmpxchg.org::pWTTaaSevbeMMy9F:00000000000000000000000000000000000000000008hB4
X-Hashcash: 1:20:140719:minchan@kernel.org::WAAJuJz9zpwWHT4a:00000000000000000000000000000000000000000007rKR
X-Hashcash: 1:20:140719:chanho.min@lge.com::u4tX4gFpbCTjpPDI:0000000000000000000000000000000000000000000BJe4
Date: Sat, 19 Jul 2014 15:51:13 +0200
Message-ID: <xa1tmwc578z2.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On 2014-07-18 08:45, Gioh Kim wrote:
>>> From: Gioh Kim <gioh.kim@lge.com>
>>> Date: Fri, 18 Jul 2014 13:40:01 +0900
>>> Subject: [PATCH] CMA/HOTPLUG: clear buffer-head lru before page migration
>>>
>>> The bh must be free to migrate a page at which bh is mapped.
>>> The reference count of bh is increased when it is installed
>>> into lru so that the bh of lru must be freed before migrating the page.
>>>
>>> This frees every bh of lru. We could free only bh of migrating page.
>>> But searching lru costs more than invalidating entire lru.
>>>
>>> Signed-off-by: Gioh Kim <gioh.kim@lge.com>
>>> Acked-by: Laura Abbott <lauraa@codeaurora.org>

With the if removed:

Acked-by: Michal Nazarewicz <mina86@mina86.com>

>>> ---
>>>   mm/page_alloc.c |    3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>> index b99643d4..3b474e0 100644
>>> --- a/mm/page_alloc.c
>>> +++ b/mm/page_alloc.c
>>> @@ -6369,6 +6369,9 @@ int alloc_contig_range(unsigned long start, unsigned long end,
>>>          if (ret)
>>>                  return ret;
>>>
>>> +       if (migratetype == MIGRATE_CMA || migratetype == MIGRATE_MOVABLE)

On Fri, Jul 18 2014, Gioh Kim <gioh.kim@lge.com> wrote:
> I agree. I cannot understand why alloc_contig_range has an argument of
> migratetype.  Can the alloc_contig_range is called for other migrate
> type than CMA/MOVABLE?

It has migratetype argument precisely because it can be CMA or MOVABLE.
If alloc_contig_range was called always with the same migrate type, the
argument would not be necessary, but because it isn't, it is.

> What do you think about removing the argument of migratetype and
> checking migratetype (if (migratetype == MIGRATE_CMA || migratetype ==
> MIGRATE_MOVABLE))?

If you remove the argument, the function would have to read migrate type
of the pageblock and that's just waste of time, since the migrate type
can be passed to the function from its caller, so the argument should
remain.

>>> +               invalidate_bh_lrus();
>>> +
>>>          ret = __alloc_contig_migrate_range(&cc, start, end);
>>>          if (ret)
>>>                  goto done;

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
