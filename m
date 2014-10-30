Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759375AbaJ3Lpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:45:45 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:59668 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759041AbaJ3Lpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAPDyKFqFOb9L6WyFhLbSY-dQy_75YVUhTzVsBku1BKcEMmgpBg@mail.gmail.com>
References: <1414655193-16952-1-git-send-email-pramod.gurav@smartplayin.com>
	<CAPDyKFqFOb9L6WyFhLbSY-dQy_75YVUhTzVsBku1BKcEMmgpBg@mail.gmail.com>
Date: Thu, 30 Oct 2014 17:15:42 +0530
Message-ID: <CAMf-jSm-Fc6gcnSqB4cixjqZSQOrvSLaQ2hXqy1TZncFrjn8hw@mail.gmail.com>
Subject: Re: [PATCH v2] mmc: davinci: Fix and simplify probe failure path
From: Pramod Gurav <pramod.gurav.etc@gmail.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, linux-mmc <linux-mmc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ulf,

On Thu, Oct 30, 2014 at 4:38 PM, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 30 October 2014 08:46, Pramod Gurav <pramod.gurav@smartplayin.com> wrote:
>> The sequence of resource release in probe failure path in this
>> driver was wrong and needed fixes to cleanly unload the driver.
>> This changes does the same by switching to managed resources and
>> fixes return path to release resource in proper sequence.
>>
>> Cc: Chris Ball <chris@printf.net>
>> Cc: Ulf Hansson <ulf.hansson@linaro.org>
>> Cc: linux-mmc@vger.kernel.org
>
> Please remove these Ccs above from the commit message. It's not needed
> when you anyway need to send the patches directly to these addresses.
Will remove Cc.

>
>> Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
>> ---
..

>>
>>         host = mmc_priv(mmc);
>>         host->mmc = mmc;        /* Important */
>> @@ -1275,15 +1273,16 @@ static int __init davinci_mmcsd_probe(struct platform_device *pdev)
>>                 host->txdma = r->start;
>>
>>         host->mem_res = mem;
>> -       host->base = ioremap(mem->start, mem_size);
>> -       if (!host->base)
>> -               goto out;
>> +       host->base = devm_ioremap(&pdev->dev, mem->start, mem_size);
>
> I realized that you should use devm_ioremap_resource() instead. That
> would simplify the code even more.
>
Yes, we could have used devm_ioremap_resource() but this driver stores
the return from devm_request_mem_region() in host->mem_res and uses
the same in the other part of drivers. Is there a way to work this
around?

> [...]
>
> Kind regards
> Uffe
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
