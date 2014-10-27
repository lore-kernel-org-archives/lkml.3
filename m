Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaJ0ROp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:14:45 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:58838 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958AbaJ0ROn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:14:43 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Minchan Kim <minchan@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4 1/4] mm/page_alloc: fix incorrect isolation behavior by rechecking migratetype
In-Reply-To: <1414051821-12769-2-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1414051821-12769-1-git-send-email-iamjoonsoo.kim@lge.com> <1414051821-12769-2-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141027:m.szyprowski@samsung.com::nkG/s2jVQc0FnUMA:000000000000000000000000000000000000009eT
X-Hashcash: 1:20:141027:hannes@cmpxchg.org::xNlFHpwG/gsreVP0:0000000000000000000000000000000000000000000096z
X-Hashcash: 1:20:141027:iamjoonsoo.kim@lge.com::JhMJYxr8Fjfn5Hn0:0000000000000000000000000000000000000000lA7
X-Hashcash: 1:20:141027:linux-mm@kvack.org::9RS8HsbpI2FTYYEL:00000000000000000000000000000000000000000000Kab
X-Hashcash: 1:20:141027:lauraa@codeaurora.org::Wekt9oYUBndcN9kx:00000000000000000000000000000000000000000XLf
X-Hashcash: 1:20:141027:zhangyanfei@cn.fujitsu.com::Y6jh//DQ980i2y5y:000000000000000000000000000000000000hiL
X-Hashcash: 1:20:141027:riel@redhat.com::mytd92W65ODIqV/Q:000lFV
X-Hashcash: 1:20:141027:akpm@linux-foundation.org::SHbuu/Zs6HpcwCeK:0000000000000000000000000000000000000VTR
X-Hashcash: 1:20:141027:linux-kernel@vger.kernel.org::aMOOeppPi8feVuhB:0000000000000000000000000000000000kkX
X-Hashcash: 1:20:141027:gioh.kim@lge.com::fPrai9e/LUiHHpb1:00zDu
X-Hashcash: 1:20:141027:aneesh.kumar@linux.vnet.ibm.com::Gb5dV08cSY6D0jQT:00000000000000000000000000000012Ef
X-Hashcash: 1:20:141027:mgorman@suse.de::3HYeJXdBZbz+FCMm:001AHF
X-Hashcash: 1:20:141027:kirill.shutemov@linux.intel.com::bEIQdYuzsic2ZYCQ:00000000000000000000000000000015l3
X-Hashcash: 1:20:141027:minchan@kernel.org::NhW5OX6RmFA2+u6u:00000000000000000000000000000000000000000001QAT
X-Hashcash: 1:20:141027:heesub.shin@samsung.com::dtExV4cYu6y1+8IT:0000000000000000000000000000000000000014Sd
X-Hashcash: 1:20:141027:wency@cn.fujitsu.com::vEka2xulsGc3weQU:000000000000000000000000000000000000000001Cn7
X-Hashcash: 1:20:141027:n-horiguchi@ah.jp.nec.com::y8ZN1dCRZiYbNtOb:0000000000000000000000000000000000001LU8
X-Hashcash: 1:20:141027:tangchen@cn.fujitsu.com::jfRxuD6v8jg4eu4I:000000000000000000000000000000000000001DvX
X-Hashcash: 1:20:141027:stable@vger.kernel.org::hNpNwoanQUm1A4vR:0000000000000000000000000000000000000001dph
X-Hashcash: 1:20:141027:isimatu.yasuaki@jp.fujitsu.com::lUsdoFXkML6lwXRE:00000000000000000000000000000001svy
X-Hashcash: 1:20:141027:vbabka@suse.cz::7EDezDEC134lqnbw:0002CyE
X-Hashcash: 1:20:141027:t.stanislaws@samsung.com::g+aRwz4dTvEnNiV9:000000000000000000000000000000000000026fB
X-Hashcash: 1:20:141027:iamjoonsoo.kim@lge.com::L5d2lAqagy6bHxAU:0000000000000000000000000000000000000003owa
X-Hashcash: 1:20:141027:ritesh.list@gmail.com::eA6fejibem1ui81c:00000000000000000000000000000000000000004jfz
X-Hashcash: 1:20:141027:peterz@infradead.org::3i6dhDwV10QPs0ny:00000000000000000000000000000000000000000Afan
X-Hashcash: 1:20:141027:b.zolnierkie@samsung.com::iiolofQOzZRPZwgk:0000000000000000000000000000000000000CIF0
Date: Mon, 27 Oct 2014 18:14:36 +0100
Message-ID: <xa1toasxo2o3.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2014, Joonsoo Kim wrote:
> There are two paths to reach core free function of buddy allocator,
> __free_one_page(), one is free_one_page()->__free_one_page() and the
> other is free_hot_cold_page()->free_pcppages_bulk()->__free_one_page().
> Each paths has race condition causing serious problems. At first, this
> patch is focused on first type of freepath. And then, following patch
> will solve the problem in second type of freepath.
>
> In the first type of freepath, we got migratetype of freeing page without
> holding the zone lock, so it could be racy. There are two cases of this
> race.
>
> 1. pages are added to isolate buddy list after restoring orignal
> migratetype
>
> CPU1                                   CPU2
>
> get migratetype => return MIGRATE_ISOLATE
> call free_one_page() with MIGRATE_ISOLATE
>
> 				grab the zone lock
> 				unisolate pageblock
> 				release the zone lock
>
> grab the zone lock
> call __free_one_page() with MIGRATE_ISOLATE
> freepage go into isolate buddy list,
> although pageblock is already unisolated
>
> This may cause two problems. One is that we can't use this page anymore
> until next isolation attempt of this pageblock, because freepage is on
> isolate buddy list. The other is that freepage accouting could be wrong
> due to merging between different buddy list. Freepages on isolate buddy
> list aren't counted as freepage, but ones on normal buddy list are counted
> as freepage. If merge happens, buddy freepage on normal buddy list is
> inevitably moved to isolate buddy list without any consideration of
> freepage accouting so it could be incorrect.
>
> 2. pages are added to normal buddy list while pageblock is isolated.
> It is similar with above case.
>
> This also may cause two problems. One is that we can't keep these
> freepages from being allocated. Although this pageblock is isolated,
> freepage would be added to normal buddy list so that it could be
> allocated without any restriction. And the other problem is same as
> case 1, that it, incorrect freepage accouting.
>
> This race condition would be prevented by checking migratetype again
> with holding the zone lock. Because it is somewhat heavy operation
> and it isn't needed in common case, we want to avoid rechecking as much
> as possible. So this patch introduce new variable, nr_isolate_pageblock
> in struct zone to check if there is isolated pageblock.
> With this, we can avoid to re-check migratetype in common case and do
> it only if there is isolated pageblock or migratetype is MIGRATE_ISOLATE.
> This solve above mentioned problems.
>
> Changes from v3:
> Add one more check in free_one_page() that checks whether migratetype is
> MIGRATE_ISOLATE or not. Without this, abovementioned case 1 could happens.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  include/linux/mmzone.h         |    9 +++++++++
>  include/linux/page-isolation.h |    8 ++++++++
>  mm/page_alloc.c                |   11 +++++++++--
>  mm/page_isolation.c            |    2 ++
>  4 files changed, 28 insertions(+), 2 deletions(-)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
