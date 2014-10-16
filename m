Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751001AbaJPFs3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 01:48:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33796 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaJPFs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 01:48:27 -0400
X-AuditID: cbfee691-f79b86d000004a5a-41-543f5c298550
Message-id: <543F5C3A.1070503@samsung.com>
Date: Thu, 16 Oct 2014 14:48:42 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Sunae Seo <sunae.seo@samsung.com>
Subject: Re: [PATCH] mm/zbud: init user ops only when it is needed
References: <1413367243-23524-1-git-send-email-heesub.shin@samsung.com>
 <20141015131710.ffd6c40996cd1ce6c16dbae8@linux-foundation.org>
In-reply-to: <20141015131710.ffd6c40996cd1ce6c16dbae8@linux-foundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBIsWRmVeSWpSXmKPExsVy+t8zTV3NGPsQg3eNbBZz1q9hs7jQtpvF
	4uDsJUwWl3fNYbO4t+Y/q8Wno4/YLBp3v2NzYPd4OuEgk8emT5PYPU7M+M3i0bdlFaPH9W9F
	Hp83yQWwRXHZpKTmZJalFunbJXBlfGw7yFjQxVvxZPYy1gbG01xdjJwcEgImElO/tjJB2GIS
	F+6tZ+ti5OIQEljGKLF73j0mmKKGrftZIRLTGSXO93eyQzhvGCUOr2oBynBw8ApoSay7zwbS
	wCKgKrFj9jw2kDCbgLbEoW3BIGFRgQiJA33PWEFsXgFBiR+T77GA2CICuhKrnu9iBhnJLLCC
	UeLjoVtgRcICThIre6cyQezqYJRY+nM5I0iCU8BbYuqaa2A2s4C1xMpJ26BseYnNa96CTZIQ
	uMYucbjtEjvERQIS3yYfYgG5SEJAVmLTAWaIzyQlDq64wTKBUWwWkqNmIRk7C8nYBYzMqxhF
	UwuSC4qT0otM9YoTc4tL89L1kvNzNzFCInDiDsb7B6wPMQpwMCrx8GoE24cIsSaWFVfmHmI0
	BbpiIrOUaHI+MM7zSuINjc2MLExNTI2NzC3NlMR5daR/BgsJpCeWpGanphakFsUXleakFh9i
	ZOLglGpg3P5A0eX6Crfk+30ex9uuLDY/JKZxTm+BY/OSM0JJGxt8Dwisf5OoXvr196W6cg+7
	C9HF0WXmHnxP52xZb9qf/WGqm5azUfaLW10uW/gu3LA/GBml+0FIpl+f7dctDgXd3Gw3pf3L
	5Q1m/bm2hjfOWol1d/33pS7Ldy+rlfSSnapwwEHkkpuCEktxRqKhFnNRcSIA7QBxILsCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrEIsWRmVeSWpSXmKPExsVy+t9jQV3NGPsQg3vfGS3mrF/DZnGhbTeL
	xcHZS5gsLu+aw2Zxb81/VotPRx+xWTTufsfmwO7xdMJBJo9Nnyaxe5yY8ZvFo2/LKkaP69+K
	PD5vkgtgi2pgtMlITUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1
	y8wBukVJoSwxpxQoFJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPGx7SBjQRdvxZPZ
	y1gbGE9zdTFyckgImEg0bN3PCmGLSVy4t56ti5GLQ0hgOqPE+f5OdgjnDaPE4VUtQFUcHLwC
	WhLr7rOBNLAIqErsmD2PDSTMJqAtcWhbMEhYVCBC4kDfM7CZvAKCEj8m32MBsUUEdCVWPd/F
	DDKSWWAFo8THQ7fAioQFnCRW9k5lgtjVwSix9OdyRpAEp4C3xNQ118BsZgFriZWTtkHZ8hKb
	17xlnsAoMAvJkllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi+n0ntYFzZ
	YHGIUYCDUYmHVyPYPkSINbGsuDL3EKMEB7OSCG9pNFCINyWxsiq1KD++qDQntfgQoykwCCYy
	S4km5wNTT15JvKGxiZmRpZGZsYm5sbGSOO+BVutAIYH0xJLU7NTUgtQimD4mDk6pBkaBKEPF
	IrHjZ3jnKimanzszq2RLvXLw9jvSpeHFz6pm/DCXNF5zh9lhrrICf/25wtc/3rQcloxpOvRu
	WVfLTJtdM2LFmTvLtjy4Z8aofH9643oLrY0nZeYwTLr+gD/wvdHTX8nrW0Qy1A7IBvImrr90
	11bn+kfBC/widouvL+D4nWP15gTnuT4lluKMREMt5qLiRACNpCSpBQMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/16/2014 05:17 AM, Andrew Morton wrote:
> On Wed, 15 Oct 2014 19:00:43 +0900 Heesub Shin <heesub.shin@samsung.com> wrote:
>
>> When zbud is initialized through the zpool wrapper, pool->ops which
>> points to user-defined operations is always set regardless of whether it
>> is specified from the upper layer. This causes zbud_reclaim_page() to
>> iterate its loop for evicting pool pages out without any gain.
>>
>> This patch sets the user-defined ops only when it is needed, so that
>> zbud_reclaim_page() can bail out the reclamation loop earlier if there
>> is no user-defined operations specified.
>
> Which callsite is calling zbud_zpool_create(..., NULL)?

Currently nowhere. zswap is the only user of zbud and always passes a 
pointer to user-defined operation on pool creation. In addition, there 
may be less possibility that pool shrinking is requested by users who 
did not provide the user-defined ops. So, we may not need to worry much 
about what I wrote in the changelog. However, it is definitely weird to 
pass an argument, zpool_ops, which even will not be referenced by 
zbud_zpool_create(). Above all, it would be more useful to avoid the 
possibility in the future rather than just ignoring it.

regards,
heesub

>
>> ...
>> --- a/mm/zbud.c
>> +++ b/mm/zbud.c
>> @@ -132,7 +132,7 @@ static struct zbud_ops zbud_zpool_ops = {
>>
>>   static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
>>   {
>> -	return zbud_create_pool(gfp, &zbud_zpool_ops);
>> +	return zbud_create_pool(gfp, zpool_ops ? &zbud_zpool_ops : NULL);
>>   }
>>
>>   static void zbud_zpool_destroy(void *pool)
>
>
