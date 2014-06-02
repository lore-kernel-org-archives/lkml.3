Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaFBHNe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:13:34 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:43510 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbaFBHNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:13:33 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <538C240F.60501@lge.com>
Date: Mon, 02 Jun 2014 16:13:19 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Mel Gorman <mgorman@suse.de>,
        Laura Abbott <lauraa@codeaurora.org>, Minchan Kim <minchan@kernel.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH v2 2/3] CMA: aggressively allocate the pages on cma reserved
 memory when not used
References: <1401260672-28339-1-git-send-email-iamjoonsoo.kim@lge.com> <1401260672-28339-3-git-send-email-iamjoonsoo.kim@lge.com> <53883902.8020701@lge.com> <CAAmzW4Nyic0VC9W16ZbjsZtNGGBet4HBDomQfMi-OvMGMKv9iw@mail.gmail.com> <538C1196.9000608@lge.com> <20140602062344.GB7713@js1304-P5Q-DELUXE>
In-Reply-To: <20140602062344.GB7713@js1304-P5Q-DELUXE>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not sure what I'm doing wrong.
These are my code.

  770 #ifdef CONFIG_CMA
  771 void adjust_managed_cma_page_count(struct zone *zone, long count)
  772 {
  773         unsigned long flags;
  774         long total, cma, movable;
  775
  776         spin_lock_irqsave(&zone->lock, flags);
  777
  778         zone->managed_cma_pages += count;
  779
  780         total = zone->managed_pages;
  781         cma = zone->managed_cma_pages;
  782         movable = total - cma - high_wmark_pages(zone);
  783
  784         printk("count=%ld total=%ld cma=%ld movable=%ld\n",
  785                count, total, cma, movable);
  786


2014-06-02 오후 3:23, Joonsoo Kim 쓴 글:
> On Mon, Jun 02, 2014 at 02:54:30PM +0900, Gioh Kim wrote:
>> I found 2 problems at my platform.
>>
>> 1st is occured when I set CMA size 528MB and total memory is 960MB.
>> I print some values in adjust_managed_cma_page_count(),
>> the total value becomes 105439 and cma value 131072.
>> Finally movable value becomes negative value.
>>
>> The total value 105439 means 411MB.
>> Is the zone->managed_pages value pages amount except the CMA?
>> I think zone->managed_pages value is including CMA size but it's value is strange.
>
> Hmm...
> zone->managed_pages includes nr of CMA pages.
> Is there any mistake about your printk?
>
>>
>> 2nd is a kernel panic at __netdev_alloc_skb().
>> I'm not sure it is caused by the CMA.
>> I'm checking it again and going to send you another report with detail call-stacks.
>
> Okay.
>
> Thanks.
>
>
