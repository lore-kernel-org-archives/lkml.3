Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030248AbaGDMxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 08:53:17 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:58692 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030204AbaGDMxM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:53:12 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: Re: [PATCH 01/10] mm/page_alloc: remove unlikely macro on free_one_page()
In-Reply-To: <1404460675-24456-2-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1404460675-24456-1-git-send-email-iamjoonsoo.kim@lge.com> <1404460675-24456-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140704:n-horiguchi@ah.jp.nec.com::FbdRth0u4QEnAeTG:00000000000000000000000000000000000003Fq
X-Hashcash: 1:20:140704:hannes@cmpxchg.org::8zitFiKNdfklWfxQ:0000000000000000000000000000000000000000000096a
X-Hashcash: 1:20:140704:iamjoonsoo.kim@lge.com::cWBq0+PYz7LP/HvX:0000000000000000000000000000000000000000Lhe
X-Hashcash: 1:20:140704:aneesh.kumar@linux.vnet.ibm.com::Qj19yXPCys05PVcQ:0000000000000000000000000000000IyH
X-Hashcash: 1:20:140704:iamjoonsoo.kim@lge.com::RIGF24AM79PcTmTb:0000000000000000000000000000000000000000s3Q
X-Hashcash: 1:20:140704:akpm@linux-foundation.org::DkP9lFrdjuaFFbUi:0000000000000000000000000000000000000txy
X-Hashcash: 1:20:140704:t.stanislaws@samsung.com::a0AzEaylHVDeEXbT:00000000000000000000000000000000000000+mZ
X-Hashcash: 1:20:140704:kirill.shutemov@linux.intel.com::FByNksGAXk4Cngv7:00000000000000000000000000000010/T
X-Hashcash: 1:20:140704:m.szyprowski@samsung.com::rffs6bW8Kqgp9s3D:00000000000000000000000000000000000001027
X-Hashcash: 1:20:140704:minchan@kernel.org::NIZPUkur3/jhCbal:00000000000000000000000000000000000000000001A7w
X-Hashcash: 1:20:140704:srivatsa.bhat@linux.vnet.ibm.com::Xi+WeFSpA8mGDMYu:000000000000000000000000000001Ue0
X-Hashcash: 1:20:140704:ritesh.list@gmail.com::VkpVlOEG9xtxBQpt:00000000000000000000000000000000000000001n0t
X-Hashcash: 1:20:140704:linux-kernel@vger.kernel.org::9oWbSQOcd3moSv+o:0000000000000000000000000000000001hHK
X-Hashcash: 1:20:140704:linux-mm@kvack.org::humJ+A9MP9op3gpj:00000000000000000000000000000000000000000001hrl
X-Hashcash: 1:20:140704:heesub.shin@samsung.com::NCH58YTQXUMnPlg4:000000000000000000000000000000000000001gO0
X-Hashcash: 1:20:140704:tangchen@cn.fujitsu.com::/W41FuCfMNN3Nbf6:000000000000000000000000000000000000001tSX
X-Hashcash: 1:20:140704:lauraa@codeaurora.org::vw8Ao3uOD6Gc2T0T:00000000000000000000000000000000000000002AaC
X-Hashcash: 1:20:140704:wency@cn.fujitsu.com::UwdP9OF8+JEVUjmv:000000000000000000000000000000000000000002Sft
X-Hashcash: 1:20:140704:b.zolnierkie@samsung.com::ChqnFYB8jX2wK9oE:00000000000000000000000000000000000002cEn
X-Hashcash: 1:20:140704:peterz@infradead.org::6BV3or6DtuNq6+j1:00000000000000000000000000000000000000000318A
X-Hashcash: 1:20:140704:gioh.kim@lge.com::XhiRKAFkyVCj8JL0:04OY/
X-Hashcash: 1:20:140704:zhangyanfei@cn.fujitsu.com::UuVyD4Ri9nT2VIIN:000000000000000000000000000000000006fVE
X-Hashcash: 1:20:140704:mgorman@suse.de::iwws+d0Uz+UHAw9+:008QER
X-Hashcash: 1:20:140704:isimatu.yasuaki@jp.fujitsu.com::3VIAuv8RkpH7YacD:00000000000000000000000000000009RXZ
X-Hashcash: 1:20:140704:riel@redhat.com::HHY9tyGUOkGdWaQ8:00FF+5
Date: Fri, 04 Jul 2014 14:53:05 +0200
Message-ID: <xa1t1tu1qo9a.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04 2014, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> Isolation is really rare case so !is_migrate_isolate() is
> likely case. Remove unlikely macro.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/page_alloc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 8dac0f0..0d4cf7a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -735,7 +735,7 @@ static void free_one_page(struct zone *zone,
>  	zone->pages_scanned = 0;
>  
>  	__free_one_page(page, pfn, zone, order, migratetype);
> -	if (unlikely(!is_migrate_isolate(migratetype)))
> +	if (!is_migrate_isolate(migratetype))
>  		__mod_zone_freepage_state(zone, 1 << order, migratetype);
>  	spin_unlock(&zone->lock);
>  }

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
