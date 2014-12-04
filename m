Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152AbaLDH2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 02:28:48 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57698 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbaLDH2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 02:28:47 -0500
X-Original-SENDERIP: 10.177.220.140
X-Original-MAILFROM: seungho1.park@lge.com
Message-ID: <54800D44.6060509@lge.com>
Date: Thu, 04 Dec 2014 16:29:08 +0900
From: =?UTF-8?B?IuuwleyKue2YuC/ssYXsnoTsl7Dqtazsm5AvU1cgUGxhdGZvcm0o7JewKQ==?=
	 =?UTF-8?B?QU9U7YyAKHNldW5naG8xLnBhcmtAbGdlLmNvbSki?= 
	<seungho1.park@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Nitin Gupta <ngupta@vflare.org>,
        Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>, juno.choi@lge.com
Subject: Re: [RFC 0/6] zsmalloc support compaction
References: <1417488587-28609-1-git-send-email-minchan@kernel.org> <548003F1.2080004@lge.com> <20141204072053.GA11990@bbox>
In-Reply-To: <20141204072053.GA11990@bbox>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Minchan.

I got it. Thank u :).

Seungho.

2014-12-04 오후 4:20에 Minchan Kim 이(가) 쓴 글:
> Hey Seungho,
>
> On Thu, Dec 04, 2014 at 03:49:21PM +0900, "박승호/책임연구원/SW Platform(연)AOT팀(seungho1.park@lge.com)" wrote:
>> Hi, Minchan.
>>
>> I have a question.
>> The problem mentioned can't be resolved with compaction?
>> Is there any reason that zsmalloc pages can't be moved by compaction
>> operation in direct reclaim?
> Currently, zsmalloc doesn't request movable page to page allocator
> since compaction is not aware of zram pages(ie, PageZram(page)).
> IOW, compaction cannot migrate zram pages at the moment.
> As I described, it's final destination we should go but I think
> we need more thinking to generalize such special pages handling
> (ex, balloon, zswap, zram and so on for future) in compaction logic.
>
> Now, I want to merge basic primitive functions in zsmalloc to
> support zspage migration, which will be used as basic utility functions
> for supporting compaction-aware zspage migration.
>
> In addition, even we need manual opeartion logic to trigger
> compaction for zsmalloc like /proc/sys/vm/compact_memory.
>
>> 2014-12-02 오전 11:49에 Minchan Kim 이(가) 쓴 글:
>>> Recently, there was issue about zsmalloc fragmentation and
>>> I got a report from Juno that new fork failed although there
>>> are plenty of free pages in the system.
>>> His investigation revealed zram is one of the culprit to make
>>> heavy fragmentation so there was no more contiguous 16K page
>>> for pgd to fork in the ARM.
>>>
>>> This patchset implement *basic* zsmalloc compaction support
>>> and zram utilizes it so admin can do
>>> 	"echo 1 > /sys/block/zram0/compact"
>>>
>>> Actually, ideal is that mm migrate code is aware of zram pages and
>>> migrate them out automatically without admin's manual opeartion
>>> when system is out of contiguous page. Howver, we need more thinking
>>> before adding more hooks to migrate.c. Even though we implement it,
>>> we need manual trigger mode, too so I hope we could enhance
>>> zram migration stuff based on this primitive functions in future.
>>>
>>> I just tested it on only x86 so need more testing on other arches.
>>> Additionally, I should have a number for zsmalloc regression
>>> caused by indirect layering. Unfortunately, I don't have any
>>> ARM test machine on my desk. I will get it soon and test it.
>>> Anyway, before further work, I'd like to hear opinion.
>>>
>>> Pathset is based on v3.18-rc6-mmotm-2014-11-26-15-45.
>>>
>>> Thanks.
>>>
>>> Minchan Kim (6):
>>>    zsmalloc: expand size class to support sizeof(unsigned long)
>>>    zsmalloc: add indrection layer to decouple handle from object
>>>    zsmalloc: implement reverse mapping
>>>    zsmalloc: encode alloced mark in handle object
>>>    zsmalloc: support compaction
>>>    zram: support compaction
>>>
>>>   drivers/block/zram/zram_drv.c |  24 ++
>>>   drivers/block/zram/zram_drv.h |   1 +
>>>   include/linux/zsmalloc.h      |   1 +
>>>   mm/zsmalloc.c                 | 596 +++++++++++++++++++++++++++++++++++++-----
>>>   4 files changed, 552 insertions(+), 70 deletions(-)
>>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo@kvack.org.  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

