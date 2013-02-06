Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3BFBK6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 20:10:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:19126 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756313Ab3BFBK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 20:10:56 -0500
X-IronPort-AV: E=Sophos;i="4.84,612,1355068800"; 
   d="scan'208";a="6693221"
Message-ID: <5111AC7D.9070505@cn.fujitsu.com>
Date: Wed, 06 Feb 2013 09:06:05 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.8) Gecko/20121012 Thunderbird/10.0.8
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>,
        Zhang Yanfei <zhangyanfei.yes@gmail.com>,
        Linux MM <linux-mm@kvack.org>, mgorman@suse.de, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, m.szyprowski@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: rename confusing function names
References: <51113CE3.5090000@gmail.com> <20130205192640.GC6481@cmpxchg.org> <20130205141332.04fcceac.akpm@linux-foundation.org>
In-Reply-To: <20130205141332.04fcceac.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 09:06:21,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/06 09:06:27
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年02月06日 06:13, Andrew Morton 写道:
> On Tue, 5 Feb 2013 14:26:40 -0500
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
>> On Wed, Feb 06, 2013 at 01:09:55AM +0800, Zhang Yanfei wrote:
>>> Function nr_free_zone_pages, nr_free_buffer_pages and nr_free_pagecache_pages
>>> are horribly badly named, they count present_pages - pages_high within zones
>>> instead of free pages, so why not rename them to reasonable names, not cofusing
>>> people.
>>>
>>> patch2 and patch3 are based on patch1. So please apply patch1 first.
>>>
>>> Zhang Yanfei (3):
>>>   mm: rename nr_free_zone_pages to nr_free_zone_high_pages
>>>   mm: rename nr_free_buffer_pages to nr_free_buffer_high_pages
>>>   mm: rename nr_free_pagecache_pages to nr_free_pagecache_high_pages
>>
>> I don't feel that this is an improvement.
>>
>> As you said, the "free" is already misleading, because those pages
>> might all be allocated.  "High" makes me think not just of highmem,
>> but drug abuse in general.
>>
>> nr_available_*_pages?  I don't know, but if we go through with all
>> that churn, it had better improve something.
> 
> Yes, those names are ghastly.
> 
> Here's an idea: accurately document the functions with code comments. 
> Once this is done, that documentation may well suggest a good name ;)
> 

As Johannes said, free is already misleading, so I think we should
rename "free" at first. to "available"? I think it is ok.

"high" here means those pages are above high watermark of a zone,
not highmem or something else.

So could I rename the functions to the names like
nr_available_buffer_high_pages
And accurately document them with code comments just as you suggested.

is this ok?

> 
> While we're there, please note that nr_free_buffer_pages() has a *lot*
> of callers.  Generally it's code which is trying to work out what is an
> appropriate size for preallocated caching space, lookup tables, etc. 
> 
> That's a rather hopeless objective, given memory hotplug, mlock, etc. 
> But please do take a look at *why* these callers are calling
> nr_free_buffer_pages() and let's ensure that both the implementation
> and name are appropriate to their requirements.

Yeah, it does have a lot callers and I think some of the callers are
misusing the function from the comments. They always want to call the
function to get lowmem pages.

Thanks
Zhang Yanfei


