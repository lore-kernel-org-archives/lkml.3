Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509AbaJXFYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 01:24:52 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:46156 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230AbaJXFYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 01:24:50 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Fri, 24 Oct 2014 14:25:53 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Hui Zhu <zhuhui@xiaomi.com>
Cc: rjw@rjwysocki.net, len.brown@intel.com, pavel@ucw.cz,
        m.szyprowski@samsung.com, akpm@linux-foundation.org, mina86@mina86.com,
        aneesh.kumar@linux.vnet.ibm.com, hannes@cmpxchg.org, riel@redhat.com,
        mgorman@suse.de, minchan@kernel.org, nasa4836@gmail.com,
        ddstreet@ieee.org, hughd@google.com, mingo@kernel.org,
        rientjes@google.com, peterz@infradead.org, keescook@chromium.org,
        atomlin@redhat.com, raistlin@linux.it, axboe@fb.com,
        paulmck@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com,
        n-horiguchi@ah.jp.nec.com, k.khlebnikov@samsung.com,
        msalter@redhat.com, deller@gmx.de, tangchen@cn.fujitsu.com,
        ben@decadent.org.uk, akinobu.mita@gmail.com, lauraa@codeaurora.org,
        vbabka@suse.cz, sasha.levin@oracle.com, vdavydov@parallels.com,
        suleiman@google.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/4] (CMA_AGGRESSIVE) Make CMA memory be more aggressive
 about allocation
Message-ID: <20141024052553.GE15243@js1304-P5Q-DELUXE>
References: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413430551-22392-1-git-send-email-zhuhui@xiaomi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 11:35:47AM +0800, Hui Zhu wrote:
> In fallbacks of page_alloc.c, MIGRATE_CMA is the fallback of
> MIGRATE_MOVABLE.
> MIGRATE_MOVABLE will use MIGRATE_CMA when it doesn't have a page in
> order that Linux kernel want.
> 
> If a system that has a lot of user space program is running, for
> instance, an Android board, most of memory is in MIGRATE_MOVABLE and
> allocated.  Before function __rmqueue_fallback get memory from
> MIGRATE_CMA, the oom_killer will kill a task to release memory when
> kernel want get MIGRATE_UNMOVABLE memory because fallbacks of
> MIGRATE_UNMOVABLE are MIGRATE_RECLAIMABLE and MIGRATE_MOVABLE.
> This status is odd.  The MIGRATE_CMA has a lot free memory but Linux
> kernel kill some tasks to release memory.
> 
> This patch series adds a new function CMA_AGGRESSIVE to make CMA memory
> be more aggressive about allocation.
> If function CMA_AGGRESSIVE is available, when Linux kernel call function
> __rmqueue try to get pages from MIGRATE_MOVABLE and conditions allow,
> MIGRATE_CMA will be allocated as MIGRATE_MOVABLE first.  If MIGRATE_CMA
> doesn't have enough pages for allocation, go back to allocate memory from
> MIGRATE_MOVABLE.
> Then the memory of MIGRATE_MOVABLE can be kept for MIGRATE_UNMOVABLE and
> MIGRATE_RECLAIMABLE which doesn't have fallback MIGRATE_CMA.

Hello,

I did some work similar to this.
Please reference following links.

https://lkml.org/lkml/2014/5/28/64
https://lkml.org/lkml/2014/5/28/57

And, aggressive allocation should be postponed until freepage counting
bug is fixed, because aggressive allocation enlarge the possiblity
of problem occurence. I tried to fix that bug, too. See following link.

https://lkml.org/lkml/2014/10/23/90

Thanks.
