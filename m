Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751542Ab3HTBNs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 21:13:48 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48278 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751297Ab3HTBNq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 21:13:46 -0400
Message-ID: <5212C24F.9050702@oracle.com>
Date: Tue, 20 Aug 2013 09:11:43 +0800
From: Bob Liu <bob.liu@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
CC: Bob Liu <lliubbo@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, eternaleye@gmail.com, minchan@kernel.org,
        mgorman@suse.de, gregkh@linuxfoundation.org, akpm@linux-foundation.org,
        axboe@kernel.dk, ngupta@vflare.org, semenzato@google.com,
        penberg@iki.fi, sonnyrao@google.com, smbarber@google.com,
        konrad.wilk@oracle.com, riel@redhat.com, kmpark@infradead.org
Subject: Re: [PATCH 3/4] mm: zswap: add supporting for zsmalloc
References: <1376815249-6611-1-git-send-email-bob.liu@oracle.com> <1376815249-6611-4-git-send-email-bob.liu@oracle.com> <20130819165948.GA5703@variantweb.net>
In-Reply-To: <20130819165948.GA5703@variantweb.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 08/20/2013 12:59 AM, Seth Jennings wrote:
> On Sun, Aug 18, 2013 at 04:40:48PM +0800, Bob Liu wrote:
>> Make zswap can use zsmalloc as its allocater.
>> But note that zsmalloc don't reclaim any zswap pool pages mandatory, if zswap
>> pool gets full, frontswap_store will be refused unless frontswap_get happened
>> and freed some space.
>>
>> The reason of don't implement reclaiming zsmalloc pages from zswap pool is there
>> is no requiremnet currently.
>> If we want to do mandatory reclaim, we have to write those pages to real backend
>> swap devices. But most of current users of zsmalloc are from embeded world,
>> there is even no real backend swap device.
>> This action is also the same as privous zram!
>>
>> For several area, zsmalloc has unpredictable performance characteristics when
>> reclaiming a single page, then CONFIG_ZBUD are suggested.
> 
> Looking at this patch on its own, it does show how simple it could be
> for zswap to support zsmalloc.  So thanks!
> 
> However, I don't like all the ifdefs scattered everywhere.  I'd like to
> have a ops structure (e.g. struct zswap_alloc_ops) instead and just
> switch ops based on the CONFIG flag.  Or better yet, have it boot-time
> selectable instead of build-time.
> 

I don't like the ifdefs neither. But I didn't find a better way to
replace them since the data structures and API of zbud and zsmalloc are
different. I can take a try using zswap_alloc_ops.

-- 
Regards,
-Bob
