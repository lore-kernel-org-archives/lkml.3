Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaHLJpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:45:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59700 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbaHLJpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:45:39 -0400
Message-ID: <53E9E23C.6030709@suse.cz>
Date: Tue, 12 Aug 2014 11:45:32 +0200
From: Vlastimil Babka <vbabka@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Heesub Shin <heesub.shin@samsung.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Ritesh Harjani <ritesh.list@gmail.com>, t.stanislaws@samsung.com,
        Gioh Kim <gioh.kim@lge.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/8] mm/isolation: close the two race problems related
 to pageblock isolation
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com> <1407309517-3270-8-git-send-email-iamjoonsoo.kim@lge.com> <20140812051745.GC23418@gmail.com>
In-Reply-To: <20140812051745.GC23418@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 07:17 AM, Minchan Kim wrote:
> On Wed, Aug 06, 2014 at 04:18:33PM +0900, Joonsoo Kim wrote:
>>
>> One solution to this problem is checking pageblock migratetype with
>> holding zone lock in __free_one_page() and I posted it before, but,
>> it didn't get welcome since it needs the hook in zone lock critical
>> section on freepath.
>
> I didn't review your v1 but IMHO, this patchset is rather complex.

It is, but the complexity is in the isolation code, and not fast paths, 
so that's justifiable IMHO.

> Normally, we don't like adding more overhead in fast path but we did
> several time on hotplug/cma, esp so I don't know a few more thing is
> really hesitant.

This actually undoes most of the overhead, so I'm all for it. Better 
than keep doing stuff the same way just because it was done previously.

> In addition, you proved by this patchset how this
> isolation code looks ugly and fragile for race problem so I vote
> adding more overhead in fast path if it can make code really simple.

Well, I recommend you to check out the v1 then :) That wasn't really 
simple, that was even more hooks rechecking migratetypes at various 
places of the fast paths, when merging buddies etc. This is much better. 
The complexity is mostly in the isolation code, and the overhead happens 
only during isolation.

> Vlastimil?

Well, I was the main opponent of v1 and suggested to do v2 like this, so 
here you go :)

> To Joonsoo,
>
> you want to send this patchset for stable since review is done?
> IIRC, you want to fix freepage couting bug and send it to stable but
> as I see this patchset, no make sense to send to stable. :(

Yeah that's one disadvantage. But I wouldn't like the v1 for stable even 
more.


