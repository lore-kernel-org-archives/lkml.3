Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881Ab3KOAsd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 19:48:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28874 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab3KOAs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 19:48:27 -0500
Message-ID: <52856F3D.4090500@oracle.com>
Date: Fri, 15 Nov 2013 08:47:57 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Seth Jennings <sjennings@variantweb.net>
CC: Hugh Dickins <hughd@google.com>, Minchan Kim <minchan@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, lliubbo@gmail.com,
        jmarchan@redhat.com, mgorman@suse.de, riel@redhat.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Luigi Semenzato <semenzato@google.com>
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
References: <20131107070451.GA10645@bbox> <20131112154137.GA3330@gmail.com> <alpine.LNX.2.00.1311131811030.1120@eggly.anvils> <20131114162103.GA4370@cerebellum.variantweb.net>
In-Reply-To: <20131114162103.GA4370@cerebellum.variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 11/15/2013 12:21 AM, Seth Jennings wrote:
> On Wed, Nov 13, 2013 at 08:00:34PM -0800, Hugh Dickins wrote:
>> On Wed, 13 Nov 2013, Minchan Kim wrote:
>> ...
>>>
>>> Hello Andrew,
>>>
>>> I'd like to listen your opinion.
>>>
>>> The zram promotion trial started since Aug 2012 and I already have get many
>>> Acked/Reviewed feedback and positive feedback from Rik and Bob in this thread.
>>> (ex, Jens Axboe[1], Konrad Rzeszutek Wilk[2], Nitin Gupta[3], Pekka Enberg[4])
>>> In Linuxcon, Hugh gave positive feedback about zram(Hugh, If I misunderstood,
>>> please correct me!). And there are lots of users already in embedded industry
>>> ex, (most of TV in the world, Chromebook, CyanogenMod, Android Kitkat.)
>>> They are not idiot. Zram is really effective for embedded world.
>>
>> Sorry for taking so long to respond, Minchan: no, you do not misrepresent
>> me at all.  Promotion of zram and zsmalloc from staging is way overdue:
>> they long ago proved their worth, look tidy, and have an active maintainer.
>>
>> Putting them into drivers/staging was always a mistake, and I quite
>> understand Greg's impatience with them by now; but please let's move
>> them to where they belong instead of removing them.
>>
>> I would not have lent support to zswap if I'd thought that was going to
>> block zram.  And I was not the only one surprised when zswap replaced its
>> use of zsmalloc by zbud: we had rather expected a zbud option to be added,
>> and I still assume that zsmalloc support will be added back to zswap later.
> 
> Yes, it is still the plan to reintroduce zsmalloc as an option (possibly
> _the_ option) for zswap.
> 
> An idea being tossed around is making zswap writethrough instead of
> delayed writeback.
>
> Doing this would be mean that zswap would no longer reduce swap out
> traffic, but would continue to reduce swap in latency by reading out of
> the compressed cache instead of the swap device.
> 
> For that loss, we gain a benefit: the compressed pages in the cache are
> clean, meaning we can reclaim them at any time with no writeback
> cost.  This addresses Mel's initial concern (the one that led to zswap
> moving to zbud) about writeback latency when the zswap pool is full.
> 

Agree!

> If there is no writeback cost for reclaiming space in the compressed
> pool, then we can use higher density packing like zsmalloc.
> 

But zsmalloc will compact several 0-order pages together as a zpage
which cause it not easy to reclaim one 0-order page directly from it.
Especially if we want to make zswap pool can be dynamically managed in
future.

> Making zswap writethough would also make the difference between zswap
> and zram, both in terms of operation and application, more apparent,
> demonstrating the need for both.
> 

-- 
Regards,
-Bob
