Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab3JaFAv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 01:00:51 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:56110 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750845Ab3JaFAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 01:00:50 -0400
Message-ID: <5271E3F8.80108@gmail.com>
Date: Thu, 31 Oct 2013 01:00:40 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: kosaki.motohiro@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH] mm: __rmqueue_fallback() should respect pageblock type
References: <1383193489-27331-1-git-send-email-kosaki.motohiro@gmail.com> <20131030213537.f346d751.akpm@linux-foundation.org>
In-Reply-To: <20131030213537.f346d751.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(10/31/13 12:35 AM), Andrew Morton wrote:
> On Thu, 31 Oct 2013 00:24:49 -0400 kosaki.motohiro@gmail.com wrote:
>
>> When __rmqueue_fallback() don't find out a free block with the same size
>> of required, it splits a larger page and puts back rest peiece of the page
>> to free list.
>>
>> But it has one serious mistake. When putting back, __rmqueue_fallback()
>> always use start_migratetype if type is not CMA. However, __rmqueue_fallback()
>> is only called when all of start_migratetype queue are empty. That said,
>> __rmqueue_fallback always put back memory to wrong queue except
>> try_to_steal_freepages() changed pageblock type (i.e. requested size is
>> smaller than half of page block). Finally, antifragmentation framework
>> increase fragmenation instead of decrease.
>>
>> Mel's original anti fragmentation do the right thing. But commit 47118af076
>> (mm: mmzone: MIGRATE_CMA migration type added) broke it.
>>
>> This patch restores sane and old behavior.
>
> What are the user-visible runtime effects of this change?

Memory fragmentation may increase compaction rate. (And then system get unnecessary
slow down)


