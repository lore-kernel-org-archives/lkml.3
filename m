Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaJQHpW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:45:22 -0400
Received: from [42.62.48.242] ([42.62.48.242]:63453 "EHLO manager.mioffice.cn"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751403AbaJQHpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:45:20 -0400
From: =?gb2312?B?1uy71A==?= <zhuhui@xiaomi.com>
To: Laura Abbott <lauraa@codeaurora.org>,
        "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "mina86@mina86.com" <mina86@mina86.com>,
        "aneesh.kumar@linux.vnet.ibm.com" <aneesh.kumar@linux.vnet.ibm.com>,
        "iamjoonsoo.kim@lge.com" <iamjoonsoo.kim@lge.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        "riel@redhat.com" <riel@redhat.com>,
        "mgorman@suse.de" <mgorman@suse.de>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "nasa4836@gmail.com" <nasa4836@gmail.com>,
        "ddstreet@ieee.org" <ddstreet@ieee.org>,
        "hughd@google.com" <hughd@google.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "atomlin@redhat.com" <atomlin@redhat.com>,
        "raistlin@linux.it" <raistlin@linux.it>, "axboe@fb.com" <axboe@fb.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "n-horiguchi@ah.jp.nec.com" <n-horiguchi@ah.jp.nec.com>,
        "k.khlebnikov@samsung.com" <k.khlebnikov@samsung.com>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "deller@gmx.de" <deller@gmx.de>,
        "tangchen@cn.fujitsu.com" <tangchen@cn.fujitsu.com>,
        "ben@decadent.org.uk" <ben@decadent.org.uk>,
        "akinobu.mita@gmail.com" <akinobu.mita@gmail.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "sasha.levin@oracle.com" <sasha.levin@oracle.com>,
        "vdavydov@parallels.com" <vdavydov@parallels.com>,
        "suleiman@google.com" <suleiman@google.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive
 about allocation
Thread-Topic: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more
 aggressive about allocation
Thread-Index: AQHP6PJVOSZsZeZKBkSR9KhOfKwh0g==
Date: Fri, 17 Oct 2014 07:44:26 +0000
Message-ID: <cf4a9f99f7b24b4fb688cb3bcccefb0e@cnbox4.mioffice.cn>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
 <543F8812.2020002@codeaurora.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [106.37.216.50]
x-esetresult: clean, is OK
x-esetid: 16754838BAB46B0E423415
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s9H7jRFs009866



On 10/16/14 16:56, Laura Abbott wrote:
> On 10/15/2014 8:35 PM, Hui Zhu wrote:
>> In fallbacks of page_alloc.c, MIGRATE_CMA is the fallback of
>> MIGRATE_MOVABLE.
>> MIGRATE_MOVABLE will use MIGRATE_CMA when it doesn't have a page in
>> order that Linux kernel want.
>>
>> If a system that has a lot of user space program is running, for
>> instance, an Android board, most of memory is in MIGRATE_MOVABLE and
>> allocated.  Before function __rmqueue_fallback get memory from
>> MIGRATE_CMA, the oom_killer will kill a task to release memory when
>> kernel want get MIGRATE_UNMOVABLE memory because fallbacks of
>> MIGRATE_UNMOVABLE are MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE.
>> This status is odd.  The MIGRATE_CMA has a lot free memory but Linux
>> kernel kill some tasks to release memory.
>>
>> This patch series adds a new function CMA_AGGRESSIVE to make CMA memory
>> be more aggressive about allocation.
>> If function CMA_AGGRESSIVE is available, when Linux kernel call function
>> __rmqueue try to get pages from MIGRATE_MOVABLE and conditions allow,
>> MIGRATE_CMA will be allocated as MIGRATE_MOVABLE first.  If MIGRATE_CMA
>> doesn't have enough pages for allocation, go back to allocate memory from
>> MIGRATE_MOVABLE.
>> Then the memory of MIGRATE_MOVABLE can be kept for MIGRATE_UNMOVABLE and
>> MIGRATE_RECLAIMABLE which doesn't have fallback MIGRATE_CMA.
>>
>
> It's good to see another proposal to fix CMA utilization.

Thanks Laura.

Do you have
> any data about the success rate of CMA contiguous allocation after
> this patch series?   I played around with a similar approach of using
> CMA for MIGRATE_MOVABLE allocations and found that although utilization
> did increase, contiguous allocations failed at a higher rate and were
> much slower. I see what this series is trying to do with avoiding
> allocation from CMA pages when a contiguous allocation is progress.
> My concern is that there would still be problems with contiguous
> allocation after all the MIGRATE_MOVABLE fallback has happened.

I did some test with the cma_alloc_counter and cma-aggressive-shrink in 
a android board that has 1g memory.  Run some apps to make free CMA 
close to the value of cma_aggressive_free_min(500 pages).  A driver 
Begin to request CMA more than 10 times. Each time, it will request more 
than 3000 pages.

I don't have established number for that because it is really hard to 
get a fail.  I think the success rate is over 95% at least.

And I think maybe the isolate fail has relation with page alloc and free 
code.  Maybe let zone->lock protect more code can handle this issue.

Thanks,
Hui

>
> Thanks,
> Laura
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
