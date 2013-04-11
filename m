Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936560Ab3DKDqe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:46:34 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:35652 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934484Ab3DKDqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:46:32 -0400
Message-ID: <51663210.7070502@gmail.com>
Date: Thu, 11 Apr 2013 11:46:24 +0800
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
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com> <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com> <5163E194.3080600@gmail.com> <0000013def363b50-9a16dd09-72ad-494f-9c25-17269fc3aab3-000000@email.amazonses.com> <5164DA6A.5060607@gmail.com> <0000013df43a48e5-6addd57e-952b-4754-848e-6d454b0a906c-000000@email.amazonses.com>
In-Reply-To: <0000013df43a48e5-6addd57e-952b-4754-848e-6d454b0a906c-000000@email.amazonses.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,
On 04/10/2013 09:54 PM, Christoph Lameter wrote:
> On Wed, 10 Apr 2013, Simon Jeons wrote:
>
>> It seems that you misunderstand my question. I don't doubt slab/slub can use
>> high order pages. However, what I focus on is why slab/slub can use compound
>> page, PageCompound() just on behalf of hugetlbfs pages or thp pages which
>> should used by apps, isn't it?
> I am not entirely clear on what you are asking for. The following gives a
> couple of answers to what I guess the question was.
>
> THP pages and user pages are on the lru and are managed differently.
> The slab allocators cannot work with those pages.
>
> Slab allocators *can* allocate higher order pages therefore they could
> allocate a page of the same order as huge pages and manage it that way.
>
> However there is no way that these pages could be handled like THP pages
> since they cannot be broken up (unless we add the capability to move slab
> objects which I wanted to do for a long time).
>
>
> You can boot a Linux system that uses huge pages for slab allocation
> by specifying the following parameter on the kernel command line.
>
> 	slub_min_order=9
>
> The slub allocator will start using huge pages for all its storage
> needs. You need a large number of huge pages to do this. Lots of memory
> is going to be lost due to fragmentation but its going to be fast since
> the slowpaths are rarely used. OOMs due to reclaim failure become much
> more likely ;-).
>

It seems that I need to simple my question.
All pages which order >=1 are compound pages?


