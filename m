Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964886AbaFSTYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 15:24:11 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:43749 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933168AbaFSTYJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 15:24:09 -0400
From: Michal Nazarewicz <mina86@mina86.com>
To: Mark Salter <msalter@redhat.com>
Cc: David Rientjes <rientjes@google.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm64: fix MAX_ORDER for 64K pagesize
In-Reply-To: <1403201524.32688.62.camel@deneb.redhat.com>
Organization: http://mina86.com/
References: <1402522435-13884-1-git-send-email-msalter@redhat.com> <alpine.DEB.2.02.1406111557030.27885@chino.kir.corp.google.com> <xa1t61jzwfo6.fsf@mina86.com> <1403201524.32688.62.camel@deneb.redhat.com>
User-Agent: Notmuch/0.17+15~gb65ca8e (http://notmuchmail.org) Emacs/24.4.50.1 (x86_64-unknown-linux-gnu)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-PGP: 50751FF4
X-PGP-FP: AC1F 5F5C D418 88F8 CC84 5858 2060 4012 5075 1FF4
X-Hashcash: 1:20:140619:m.szyprowski@samsung.com::FLVamT9QO2/499gN:00000000000000000000000000000000000000adK
X-Hashcash: 1:20:140619:catalin.marinas@arm.com::u7N9Rm6t64L80o1q:000000000000000000000000000000000000001GnP
X-Hashcash: 1:20:140619:msalter@redhat.com::4cfx0wWlXNGhnH8t:000000000000000000000000000000000000000000017xG
X-Hashcash: 1:20:140619:rientjes@google.com::p9dJ2RMKM3DNuE93:0000000000000000000000000000000000000000005qRJ
X-Hashcash: 1:20:140619:linux-kernel@vger.kernel.org::Pwlu3cWy5XOT43gV:000000000000000000000000000000000MJoK
X-Hashcash: 1:20:140619:linux-arm-kernel@lists.infradead.org::AssXBHNd0JEEvbs/:0000000000000000000000000E7t4
Date: Thu, 19 Jun 2014 21:24:04 +0200
Message-ID: <xa1tfvj01z57.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19 2014, Mark Salter <msalter@redhat.com> wrote:
> On Tue, 2014-06-17 at 20:32 +0200, Michal Nazarewicz wrote:
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 5dba293..6e657ce 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -801,7 +801,15 @@ void __init init_cma_reserved_pageblock(struct page *page)
>>  
>>  	set_page_refcounted(page);
>>  	set_pageblock_migratetype(page, MIGRATE_CMA);
>> -	__free_pages(page, pageblock_order);
>> +	if (pageblock_order > MAX_ORDER) {
>> +		struct page *subpage = p;
>> +		unsigned count = 1 << (pageblock_order - MAX_ORDER);
>> +		do {
>> +			__free_pages(subpage, pageblock_order);
>                                                ^^^^^^^
>                                                MAX_ORDER

D'oh!  I'll send a revised patch.

>> +		} while (subpage += MAX_ORDER_NR_PAGES, --count);
>> +	} else {
>> +		__free_pages(page, pageblock_order);
>> +	}
>>  	adjust_managed_page_count(page, pageblock_nr_pages);
>>  }
>>  #endif
>> --------- >8 ---------------------------------------------------------
>> 
>> Thoughts?  This has not been tested and I think it may cause performance
>> degradation in some cases since pageblock_order is not always
>> a constant, so the comparison may end up not being stripped away even on
>> systems where it's always false.

> This works with the above tweak. So it fixes the problm here, but I was
> not sure if we'd get bitten elsewhere by pageblock_order > MAX_ORDER.

This is always a possibility, but in such cases, it's a bug in CMA.
I've tried to keep in mind that pageblock_order may be greater than
MAX_ORDER when writing CMA, but I've never tested on such a system.

> It will be slower, but does it only gets called a few time at most at
> boot time, right?

Yes.  The performance degradation should be negligible since
init_cma_reserved is hardly a critical path and is called at most
MAX_CMA_AREAS times which by default is 8.  And I mean it will be slower
because it will have to perform a branch.


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +--<mpn@google.com>--<xmpp:mina86@jabber.org>--ooO--(_)--Ooo--
