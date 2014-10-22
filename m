Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933460AbaJVMC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 08:02:28 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:56752 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933056AbaJVMC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 08:02:26 -0400
X-Greylist: delayed 60989 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Oct 2014 08:02:26 EDT
Message-ID: <54479CB2.5040408@hurleysoftware.com>
Date: Wed, 22 Oct 2014 08:01:54 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Laura Abbott <lauraa@codeaurora.org>, Hui Zhu <zhuhui@xiaomi.com>,
        m.szyprowski@samsung.com, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, hughd@google.com, akinobu.mita@gmail.com
CC: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz, mina86@mina86.com,
        aneesh.kumar@linux.vnet.ibm.com, iamjoonsoo.kim@lge.com,
        hannes@cmpxchg.org, minchan@kernel.org, nasa4836@gmail.com,
        ddstreet@ieee.org, mingo@kernel.org, rientjes@google.com,
        peterz@infradead.org, keescook@chromium.org, atomlin@redhat.com,
        raistlin@linux.it, axboe@fb.com, paulmck@linux.vnet.ibm.com,
        kirill.shutemov@linux.intel.com, n-horiguchi@ah.jp.nec.com,
        k.khlebnikov@samsung.com, msalter@redhat.com, deller@gmx.de,
        tangchen@cn.fujitsu.com, ben@decadent.org.uk, vbabka@suse.cz,
        sasha.levin@oracle.com, vdavydov@parallels.com, suleiman@google.com,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive
 about allocation
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com> <543F8812.2020002@codeaurora.org>
In-Reply-To: <543F8812.2020002@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 04:55 AM, Laura Abbott wrote:
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
> It's good to see another proposal to fix CMA utilization. Do you have
> any data about the success rate of CMA contiguous allocation after
> this patch series? I played around with a similar approach of using
> CMA for MIGRATE_MOVABLE allocations and found that although utilization
> did increase, contiguous allocations failed at a higher rate and were
> much slower. I see what this series is trying to do with avoiding
> allocation from CMA pages when a contiguous allocation is progress.
> My concern is that there would still be problems with contiguous
> allocation after all the MIGRATE_MOVABLE fallback has happened.

What impact does this series have on x86 platforms now that CMA is the
backup allocator for all iommu dma allocations?

Regards,
Peter Hurley
