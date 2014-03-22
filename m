Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaCVXMT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2014 19:12:19 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:47297 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbaCVXMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2014 19:12:17 -0400
Message-ID: <532E18EE.3090008@gmail.com>
Date: Sun, 23 Mar 2014 07:12:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
CC: =?ISO-8859-1?Q?H=E5vard_Skinnemoen?= <hskinnemoen@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/avr32/mm/cache.c: export symbol flush_icache_range()
 for module using
References: <531B8D32.6000000@gmail.com> <531B8FD8.6040704@gmail.com> <20140308221721.GA30934@samfundet.no> <531C8683.2010908@gmail.com> <5324C3B2.1000802@gmail.com>
In-Reply-To: <5324C3B2.1000802@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Is this patch OK?

If it is necessary to continue analysing more details, please let me
know, and I will/should continue.

Thanks.

On 03/16/2014 05:18 AM, Chen Gang wrote:
> On 03/09/2014 11:19 PM, Chen Gang wrote:
>> On 03/09/2014 06:17 AM, Hans-Christian Egtvedt wrote:
>>> Around Sun 09 Mar 2014 05:47:04 +0800 or thereabout, Chen Gang wrote:
>>>>
>>>> After this patch, our linux kernel can pass "avr32-linux-" allmodconfig
>>>> (it contents quite a few of warnings, but after check, I guess they are
>>>> not kernel's issue).
>>>
>>> That sounds great, I am a bit surprised however that the lkdtm module need
>>> flush_icache_range. Would have been interesting to look into what causes this
>>> dependency.
>>>
> 
> After read a little more details for lkdtm, I guess "after overwrite an
> executable area by do_nothing(), it needs flush_icache_range() to be
> sure the new instructions/data must have effect with all cpu".
> 
> Welcome any additional information for it.
> 
> Thanks.
> 
>>
>> "driver/misc/lkdtm.c" will use this flush_icache_range().
>>
>> And some architectures export it to modules.
>>
>>   [root@gchen arch]# grep -rn flush_icache_range * | grep EXPORT
>>   arm64/mm/flush.c:105:EXPORT_SYMBOL(flush_icache_range);
>>   avr32/mm/cache.c:114:EXPORT_SYMBOL(flush_icache_range);
>>   m68k/mm/cache.c:106:EXPORT_SYMBOL(flush_icache_range);
>>   mn10300/mm/cache-inv-icache.c:129:EXPORT_SYMBOL(flush_icache_range);
>>   mn10300/mm/cache-flush-icache.c:155:EXPORT_SYMBOL(flush_icache_range);
>>   sparc/mm/init_64.c:435:EXPORT_SYMBOL(flush_icache_range);
>>
>>
>> Welcome any more details information by any other members, thanks.
>>
>>
> 
> Thanks.
> 


-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
