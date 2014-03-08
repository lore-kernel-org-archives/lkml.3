Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbaCHWR3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 17:17:29 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:38634 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaCHWRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 17:17:24 -0500
Date: Sat, 8 Mar 2014 23:17:22 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: =?iso-8859-1?Q?H=E5vard?= Skinnemoen <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/avr32/mm/cache.c: export symbol
 flush_icache_range() for module using
Message-ID: <20140308221721.GA30934@samfundet.no>
References: <531B8D32.6000000@gmail.com>
 <531B8FD8.6040704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531B8FD8.6040704@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Sun 09 Mar 2014 05:47:04 +0800 or thereabout, Chen Gang wrote:
> 
> After this patch, our linux kernel can pass "avr32-linux-" allmodconfig
> (it contents quite a few of warnings, but after check, I guess they are
> not kernel's issue).

That sounds great, I am a bit surprised however that the lkdtm module need
flush_icache_range. Would have been interesting to look into what causes this
dependency.

I will pull this into my for-linus branch, and push during the next merge
window.

> On 03/09/2014 05:35 AM, Chen Gang wrote:
>> Need export symbol flush_icache_range() to modules, just like another
>> platforms have done, or can not pass compiling.
>> 
>> The related error (with allmodconfig under avr32):
>> 
>>   ERROR: "flush_icache_range" [drivers/misc/lkdtm.ko] undefined!
>>   make[1]: *** [__modpost] Error 1
>>   make: *** [modules] Error 2
>> 
>> 
>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

>> ---
>>  arch/avr32/mm/cache.c | 1 +
>>  1 file changed, 1 insertion(+)
>> 
>> diff --git a/arch/avr32/mm/cache.c b/arch/avr32/mm/cache.c
>> index 6a46ecd..85d635c 100644
>> --- a/arch/avr32/mm/cache.c
>> +++ b/arch/avr32/mm/cache.c
>> @@ -111,6 +111,7 @@ void flush_icache_range(unsigned long start, unsigned long end)
>>  	__flush_icache_range(start & ~(linesz - 1),
>>  			     (end + linesz - 1) & ~(linesz - 1));
>>  }
>> +EXPORT_SYMBOL(flush_icache_range);
>>  
>>  /*
>>   * This one is called from __do_fault() and do_swap_page().
-- 
mvh
Hans-Christian Egtvedt
