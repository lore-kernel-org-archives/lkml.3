Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaEWVta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 17:49:30 -0400
Received: from mail-ig0-f176.google.com ([209.85.213.176]:62289 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbaEWVt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 17:49:28 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1405231353080.13205@chino.kir.corp.google.com>
References: <1400847135-22291-1-git-send-email-dh.herrmann@gmail.com>
	<alpine.DEB.2.02.1405231353080.13205@chino.kir.corp.google.com>
Date: Fri, 23 May 2014 23:49:28 +0200
Message-ID: <CANq1E4SfL=c_ZgGwRkQWoEHEWF4q8-DVB+RsQfo6CqGQc9MoZA@mail.gmail.com>
Subject: Re: [PATCH] mm/madvise: fix WILLNEED on SHM/ANON to actually do something
From: David Herrmann <dh.herrmann@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Vladimir Cernov <gg.kaspersky@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Fri, May 23, 2014 at 10:55 PM, David Rientjes <rientjes@google.com> wrote:
> On Fri, 23 May 2014, David Herrmann wrote:
>
>> diff --git a/mm/madvise.c b/mm/madvise.c
>> index 539eeb9..a402f8f 100644
>> --- a/mm/madvise.c
>> +++ b/mm/madvise.c
>> @@ -195,7 +195,7 @@ static void force_shm_swapin_readahead(struct vm_area_struct *vma,
>>       for (; start < end; start += PAGE_SIZE) {
>>               index = ((start - vma->vm_start) >> PAGE_SHIFT) + vma->vm_pgoff;
>>
>> -             page = find_get_page(mapping, index);
>> +             page = find_get_entry(mapping, index);
>>               if (!radix_tree_exceptional_entry(page)) {
>>                       if (page)
>>                               page_cache_release(page);
>
> This is already in -mm from Johannes, see
> http://marc.info/?l=linux-kernel&m=139998616712729.  Check out
> http://www.ozlabs.org/~akpm/mmotm/ for this kernel.

Didn't check -mm, sorry. Thanks for the links!
David
