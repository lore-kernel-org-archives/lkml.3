Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751695AbaJ0RPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 13:15:07 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:38470 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaJ0RPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 13:15:02 -0400
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
Subject: Re: [PATCH v4 2/4] mm/page_alloc: add freepage on isolate pageblock to correct buddy list
In-Reply-To: <1414051821-12769-3-git-send-email-iamjoonsoo.kim@lge.com>
Organization: http://mina86.com/
References: <1414051821-12769-1-git-send-email-iamjoonsoo.kim@lge.com> <1414051821-12769-3-git-send-email-iamjoonsoo.kim@lge.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:141027:t.stanislaws@samsung.com::FgW1m/YuWX+SE0ni:00000000000000000000000000000000000000Bm0
X-Hashcash: 1:20:141027:vbabka@suse.cz::wT7gUD+rt1NfXp3N:00007qj
X-Hashcash: 1:20:141027:minchan@kernel.org::QW9H37YQlb3SFJAj:00000000000000000000000000000000000000000000Jff
X-Hashcash: 1:20:141027:stable@vger.kernel.org::rzcdy4BsAdXWidcz:0000000000000000000000000000000000000000Ir4
X-Hashcash: 1:20:141027:tangchen@cn.fujitsu.com::UuaMBZD01a0amUHW:000000000000000000000000000000000000000TZV
X-Hashcash: 1:20:141027:peterz@infradead.org::ze7+GYS/hn354HqN:000000000000000000000000000000000000000000MFd
X-Hashcash: 1:20:141027:riel@redhat.com::fhc1vX7h1gaL1E2+:000luu
X-Hashcash: 1:20:141027:ritesh.list@gmail.com::NSSvfcPr4DJ1dVfT:00000000000000000000000000000000000000000pGU
X-Hashcash: 1:20:141027:heesub.shin@samsung.com::cv4PG9ivO+YDFxRX:000000000000000000000000000000000000000/au
X-Hashcash: 1:20:141027:lauraa@codeaurora.org::AXKZF5KQcdLuedO2:00000000000000000000000000000000000000000xhM
X-Hashcash: 1:20:141027:akpm@linux-foundation.org::m4p1JkOPNy1/En20:0000000000000000000000000000000000001EOS
X-Hashcash: 1:20:141027:isimatu.yasuaki@jp.fujitsu.com::PcmIM8NO+qEPE1CS:00000000000000000000000000000001lk1
X-Hashcash: 1:20:141027:kirill.shutemov@linux.intel.com::D53K2VLEU30MvPTR:0000000000000000000000000000001uRs
X-Hashcash: 1:20:141027:zhangyanfei@cn.fujitsu.com::lqffmmVMjVqvIQVJ:000000000000000000000000000000000002MCF
X-Hashcash: 1:20:141027:mgorman@suse.de::bKB0S/NnBwO+TNtX:002igL
X-Hashcash: 1:20:141027:gioh.kim@lge.com::EsM7XowIi7/QsbCJ:02rlN
X-Hashcash: 1:20:141027:b.zolnierkie@samsung.com::q1PQCfms7xtl/p6u:00000000000000000000000000000000000002bRx
X-Hashcash: 1:20:141027:hannes@cmpxchg.org::E2JEImOIKM8YlmVw:00000000000000000000000000000000000000000003E16
X-Hashcash: 1:20:141027:m.szyprowski@samsung.com::FOAK4u37PIfwN2iv:00000000000000000000000000000000000003T4B
X-Hashcash: 1:20:141027:aneesh.kumar@linux.vnet.ibm.com::TCIVHGDDwkj/egi7:0000000000000000000000000000003Zx6
X-Hashcash: 1:20:141027:iamjoonsoo.kim@lge.com::WkzaE1KRt5i+iaRa:0000000000000000000000000000000000000004nGk
X-Hashcash: 1:20:141027:linux-mm@kvack.org::oyzi2gsdIaQUJ3kQ:00000000000000000000000000000000000000000005LMN
X-Hashcash: 1:20:141027:iamjoonsoo.kim@lge.com::uUl+5dR3PMN+PEWt:0000000000000000000000000000000000000005Lx3
X-Hashcash: 1:20:141027:linux-kernel@vger.kernel.org::bFzFKyvOq/oUdGGv:0000000000000000000000000000000005fJ3
X-Hashcash: 1:20:141027:n-horiguchi@ah.jp.nec.com::MYJsUwJkXAmVQ7iZ:0000000000000000000000000000000000007dGI
X-Hashcash: 1:20:141027:wency@cn.fujitsu.com::HCD/jdv9d1W4vYDz:000000000000000000000000000000000000000009UWg
Date: Mon, 27 Oct 2014 18:14:55 +0100
Message-ID: <xa1tlho1o2nk.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23 2014, Joonsoo Kim wrote:
> In free_pcppages_bulk(), we use cached migratetype of freepage
> to determine type of buddy list where freepage will be added.
> This information is stored when freepage is added to pcp list, so
> if isolation of pageblock of this freepage begins after storing,
> this cached information could be stale. In other words, it has
> original migratetype rather than MIGRATE_ISOLATE.
>
> There are two problems caused by this stale information. One is that
> we can't keep these freepages from being allocated. Although this
> pageblock is isolated, freepage will be added to normal buddy list
> so that it could be allocated without any restriction. And the other
> problem is incorrect freepage accounting. Freepages on isolate pageblock
> should not be counted for number of freepage.
>
> Following is the code snippet in free_pcppages_bulk().
>
> /* MIGRATE_MOVABLE list may include MIGRATE_RESERVEs */
> __free_one_page(page, page_to_pfn(page), zone, 0, mt);
> trace_mm_page_pcpu_drain(page, 0, mt);
> if (likely(!is_migrate_isolate_page(page))) {
> 	__mod_zone_page_state(zone, NR_FREE_PAGES, 1);
> 	if (is_migrate_cma(mt))
> 		__mod_zone_page_state(zone, NR_FREE_CMA_PAGES, 1);
> }
>
> As you can see above snippet, current code already handle second problem,
> incorrect freepage accounting, by re-fetching pageblock migratetype
> through is_migrate_isolate_page(page). But, because this re-fetched
> information isn't used for __free_one_page(), first problem would not be
> solved. This patch try to solve this situation to re-fetch pageblock
> migratetype before __free_one_page() and to use it for __free_one_page().
>
> In addition to move up position of this re-fetch, this patch use
> optimization technique, re-fetching migratetype only if there is
> isolate pageblock. Pageblock isolation is rare event, so we can
> avoid re-fetching in common case with this optimization.
>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Acked-by: Michal Nazarewicz <mina86@mina86.com>

> ---
>  mm/page_alloc.c |   13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
