Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752901Ab3ITQJF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 12:09:05 -0400
Received: from mail-ve0-f176.google.com ([209.85.128.176]:55290 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3ITQJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 12:09:03 -0400
MIME-Version: 1.0
In-Reply-To: <5226ED69.8080506@nod.at>
References: <1377511730-14834-1-git-send-email-richard@nod.at>
	<5226ED69.8080506@nod.at>
Date: Fri, 20 Sep 2013 18:09:02 +0200
Message-ID: <CAFLxGvwQ64QpC7GB5wG9S1RaQVfGuK5sn_JqABrdEmkqXY2KwA@mail.gmail.com>
Subject: Re: [PATCH] UBI: fix refill_wl_user_pool()
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: richard.genoud@gmail.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 10:20 AM, Richard Weinberger <richard@nod.at> wrote:
> Am 26.08.2013 12:08, schrieb Richard Weinberger:
>> If no free PEBs are available refill_wl_user_pool() must not
>> return with -ENOSPC immediately.
>> It has to block till produce_free_peb() produced a free PEB.
>>
>> Reported-and-Tested-by: Richard Genoud <richard.genoud@gmail.com>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/mtd/ubi/wl.c | 4 ----
>>  1 file changed, 4 deletions(-)
>>
>> diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
>> index c95bfb1..02317c1 100644
>> --- a/drivers/mtd/ubi/wl.c
>> +++ b/drivers/mtd/ubi/wl.c
>> @@ -599,10 +599,6 @@ static void refill_wl_user_pool(struct ubi_device *ubi)
>>       return_unused_pool_pebs(ubi, pool);
>>
>>       for (pool->size = 0; pool->size < pool->max_size; pool->size++) {
>> -             if (!ubi->free.rb_node ||
>> -                (ubi->free_count - ubi->beb_rsvd_pebs < 1))
>> -                     break;
>> -
>>               pool->pebs[pool->size] = __wl_get_peb(ubi);
>>               if (pool->pebs[pool->size] < 0)
>>                       break;
>>
>
> Artem, please don't forget do apply this patch.

*ping*

-- 
Thanks,
//richard
