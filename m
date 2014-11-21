Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750910AbaKUFZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:25:39 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:54576 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726AbaKUFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:25:38 -0500
MIME-Version: 1.0
In-Reply-To: <20141121034355.GA10123@bbox>
References: <1416488913-9691-1-git-send-email-opensource.ganesh@gmail.com>
	<20141121034355.GA10123@bbox>
Date: Fri, 21 Nov 2014 13:25:37 +0800
Message-ID: <CADAEsF9foZzneOY+0b_S71b8xVhrX+bNqGZCcgaL56c_SNicOQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zsmalloc: avoid duplicate assignment of prev_class
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>, iamjoonsoo.kim@lge.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

2014-11-21 11:43 GMT+08:00 Minchan Kim <minchan@kernel.org>:
> On Thu, Nov 20, 2014 at 09:08:33PM +0800, Mahendran Ganesh wrote:
>> In zs_create_pool(), prev_class is assigned (ZS_SIZE_CLASSES - 1)
>> times. And the prev_class only references to the previous alloc
>> size_class. So we do not need unnecessary assignement.
>>
>> This patch modifies *prev_class* to *prev_alloc_class*. And the
>> *prev_alloc_class* will only be assigned when a new size_class
>> structure is allocated.
>>
>> Signed-off-by: Mahendran Ganesh <opensource.ganesh@gmail.com>
>> ---
>>  mm/zsmalloc.c |    9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>> index b3b57ef..ac2b396 100644
>> --- a/mm/zsmalloc.c
>> +++ b/mm/zsmalloc.c
>> @@ -970,7 +970,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
>>               int size;
>>               int pages_per_zspage;
>>               struct size_class *class;
>> -             struct size_class *prev_class;
>> +             struct size_class *uninitialized_var(prev_alloc_class);
>
> https://lkml.org/lkml/2012/10/27/71
> In addition, I prefer prev_class.

Thanks for you review. I will resend the patch.

>
> Thanks.
>
> --
> Kind regards,
> Minchan Kim
