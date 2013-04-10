Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933873Ab3DJDUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 23:20:19 -0400
Received: from mail-ia0-f171.google.com ([209.85.210.171]:45373 "EHLO
	mail-ia0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760631Ab3DJDUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 23:20:17 -0400
Message-ID: <5164DA6A.5060607@gmail.com>
Date: Wed, 10 Apr 2013 11:20:10 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's
 reclaimed_slab
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com> <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com> <5163E194.3080600@gmail.com> <0000013def363b50-9a16dd09-72ad-494f-9c25-17269fc3aab3-000000@email.amazonses.com>
In-Reply-To: <0000013def363b50-9a16dd09-72ad-494f-9c25-17269fc3aab3-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
On 04/09/2013 10:32 PM, Christoph Lameter wrote:
> On Tue, 9 Apr 2013, Simon Jeons wrote:
>
>>> +	int pages = 1 << compound_order(page);
>> One question irrelevant this patch. Why slab cache can use compound
>> page(hugetlbfs pages/thp pages)? They are just used by app to optimize tlb
>> miss, is it?
> Slab caches can use any order pages because these pages are never on
> the LRU and are not part of the page cache. Large continuous physical
> memory means that objects can be arranged in a more efficient way in the
> page. This is particularly useful for larger objects where we might use a
> lot of memory because objects do not fit well into a 4k page.
>
> It also reduces the slab page management if higher order pages are used.
> In the case of slub the page size also determines the number of objects
> that can be allocated/freed without the need for some form of
> synchronization.

It seems that you misunderstand my question. I don't doubt slab/slub can 
use high order pages. However, what I focus on is why slab/slub can use 
compound page, PageCompound() just on behalf of hugetlbfs pages or thp 
pages which should used by apps, isn't it?

>

