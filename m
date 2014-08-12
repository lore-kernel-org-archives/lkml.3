Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126AbaHLK6o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:58:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:32936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412AbaHLK6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:58:43 -0400
Message-ID: <53E9F35D.7050902@suse.cz>
Date: Tue, 12 Aug 2014 12:58:37 +0200
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
Subject: Re: [PATCH v2 5/8] mm/isolation: change pageblock isolation logic
 to fix freepage counting bugs
References: <1407309517-3270-1-git-send-email-iamjoonsoo.kim@lge.com> <1407309517-3270-9-git-send-email-iamjoonsoo.kim@lge.com> <20140812064312.GD23418@gmail.com>
In-Reply-To: <20140812064312.GD23418@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2014 08:43 AM, Minchan Kim wrote:
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -571,7 +571,7 @@ static inline int page_is_buddy(struct page *page, struct page *buddy,
>>    * -- nyc
>>    */
>>
>> -static inline void __free_one_page(struct page *page,
>> +void __free_one_page(struct page *page,
>
> no inline any more. :(

That could be hopefully done differently without killing this property.

> Personally, it is becoming increasingly clear that it would be better
> to add some hooks for isolateed pages to be sure to fix theses problems
> without adding more complicated logic.

Might be a valid argument but please do read the v1 discussions and then 
say if you still hold the opinion. Or maybe you will get a better 
picture afterwards and see a more elegant solution :)

Vlastimil
