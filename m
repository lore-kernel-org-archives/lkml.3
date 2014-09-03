Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaICCMd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 22:12:33 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:25461 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbaICCMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 22:12:30 -0400
X-AuditID: cbfee68f-f797f6d000001173-bd-5406790c282a
Message-id: <5406790B.1090305@samsung.com>
Date: Wed, 03 Sep 2014 11:12:27 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: "Fu, Zhonghui" <zhonghui.fu@linux.intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Aaron Lu <aaron.lu@intel.com>, linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jackey Shen <jackey.shen@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on
 sdio thread
References: <53E85967.5060503@linux.intel.com>
 <CAPDyKFqLE-09=3k_6stMXiY3+Ax3xoRBO3q__GHyqH4fd-XmsQ@mail.gmail.com>
 <53F16D28.5010500@linux.intel.com>
 <CAPDyKFrfXe0f6S0z8HUG2Mg29JVU39C0VOBimgKtq-HL47HZrA@mail.gmail.com>
 <53FB5FDD.6030202@linux.intel.com> <5406789C.7040706@linux.intel.com>
In-reply-to: <5406789C.7040706@linux.intel.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkQJenki3E4M16fotNfb/ZLCZc3s5o
	0bx4PZB1byKrxeVdc9gsjvzvZ7T4cP8is8XxteEW7ZcuMjtwerRe+svmsXjPSyaPO9f2sHnM
	OxnosX/uGnaPG68WMnn0bVnF6PF5k1wARxSXTUpqTmZZapG+XQJXxq2/O9gLJrlUvF8xibGB
	sc2oi5GTQ0LARGJZ6xlGCFtM4sK99WxdjFwcQgJLGSUanrQzwxR9fjmFGSIxnVHiwY197BDO
	a0aJzkONLCBVvAJaEucuHwazWQRUJU5MPQpmswnoSGz/dpwJxBYVCJM41DaPCaJeUOLH5Htg
	NSICERKnHv9jBRnKLLCZSWLCg0Vgq4UFoiR+Xd3MCrFtJZNE/7rJYMdyCuhL9J1czw5iMwuo
	S0yaB9HALCAvsXnNW6i7P7JLbD7GCXGRgMS3yYeAtnEAxWUlNh2AKpGUOLjiBssERrFZSG6a
	hWTqLCRTFzAyr2IUTS1ILihOSi8y1itOzC0uzUvXS87P3cQIjNTT/57172C8e8D6EKMAB6MS
	D++CALYQIdbEsuLK3EOMpkBXTGSWEk3OB6aDvJJ4Q2MzIwtTE1NjI3NLMyVx3oVSP4OFBNIT
	S1KzU1MLUovii0pzUosPMTJxcEo1MPbN7Vyc/MtbtCn0XEI8b23RmRnyN1Vf+Yvdv5LpvaGB
	+aO3ZFrvkTruvyrxmW2PAjh2v/fXn1T3S0jQPvRw6ZKklqvhFz1uy0rf/fDSnWnqMm2n5y9u
	fNn6selNcqjpv8cXbX2uz1U+Fni80bs/qpyjrXqirMJB6+S0AmebjKMCiyUeLTmQpMRSnJFo
	qMVcVJwIAL0K46zPAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+xoC5PJVuIwbVTbBab+n6zWUy4vJ3R
	onnxeiDr3kRWi8u75rBZHPnfz2jx4f5FZovja8Mt2i9dZHbg9Gi99JfNY/Gel0wed67tYfOY
	dzLQY//cNeweN14tZPLo27KK0ePzJrkAjqgGRpuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMD
	Q11DSwtzJYW8xNxUWyUXnwBdt8wcoPOUFMoSc0qBQgGJxcVK+naYJoSGuOlawDRG6PqGBMH1
	GBmggYQ1jBm3/u5gL5jkUvF+xSTGBsY2oy5GTg4JAROJzy+nMEPYYhIX7q1n62Lk4hASmM4o
	8eDGPnYI5zWjROehRhaQKl4BLYlzlw+D2SwCqhInph4Fs9kEdCS2fzvOBGKLCoRJHGqbxwRR
	LyjxY/I9sBoRgQiJU4//sYIMZRbYzCQx4cEisNXCAlESv65uZoXYtpJJon/dZEaQBKeAvkTf
	yfXsIDazgLrEpHkQDcwC8hKb17xlnsAoMAvJkllIymYhKVvAyLyKUTS1ILmgOCk911CvODG3
	uDQvXS85P3cTIzgRPJPawbiyweIQowAHoxIP74IAthAh1sSy4srcQ4wSHMxKIry+iUAh3pTE
	yqrUovz4otKc1OJDjKbAMJjILCWanA9MUnkl8YbGJmZGlkbmhhZGxuZK4rwHWq0DhQTSE0tS
	s1NTC1KLYPqYODilGhjjNbdv9lr5WnXZ5Z8djDY7M39vK2bPWLa+3V1sz/szojEf0ozYCz5+
	TnkhohOxrVPm/7KHkodixDvLWs+eevfwt54Eww2Gw0terlH7mXWNudBf4zxHitOqOyLzXlxY
	vqlryZ2lHy9prdoRY22vEnqh2nB6TePUjScvFu76xZW19yPv/MTFYu8XKbEUZyQaajEXFScC
	ADChLMcaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/03/2014 11:10 AM, Fu, Zhonghui wrote:
> 
> Hi,Uffe
> 
> Could you please tell me into which git repository this patch is merged now?

I knew it was merged into Ulf's git repository.
You can refer to below git.

url = http://git.linaro.org/git/people/ulf.hansson/mmc.git


Best Regards,
Jaehoon Chung
> 
> 
> 
> Thanks,
> Zhonghui 
> 
> 
> 
> On 2014/8/26 0:10, Fu, Zhonghui wrote:
>>
>> Many thanks for your helps.
>>
>>
>>
>> Thanks,
>> Zhonghui
>>
>>
>> On 2014/8/18 20:07, Ulf Hansson wrote:
>>> On 18 August 2014 05:04, Fu, Zhonghui <zhonghui.fu@linux.intel.com> wrote:
>>>> From 21266249bbbaf9407c1e88cd5950e06ac88aeebf Mon Sep 17 00:00:00 2001
>>>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>>> Date: Mon, 18 Aug 2014 10:48:14 +0800
>>>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>>>
>>>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>>>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>>>> the use of our own custom threaded IRQ handler, but left in an
>>>> unconditional wake_up_process() on that handler at resume-time.
>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=80151
>>>>
>>>> In addition, the check for MMC_CAP_SDIO_IRQ capability is added
>>>> before enable sdio IRQ.
>>>>
>>>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>>>> Signed-off-by: Chris Ball <chris@printf.net>
>>>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>>>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>> Thanks! Applied for next and added a stable tag for v3.16+.
>>>
>>> Kind regards
>>> Uffe
>>>
>>>> ---
>>>>  drivers/mmc/core/sdio.c     |   12 ++++++++++--
>>>>  drivers/mmc/core/sdio_irq.c |    4 ++--
>>>>  2 files changed, 12 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>>>> index e636d9e..3fc40a7 100644
>>>> --- a/drivers/mmc/core/sdio.c
>>>> +++ b/drivers/mmc/core/sdio.c
>>>> @@ -992,8 +992,16 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>>>                 }
>>>>         }
>>>>
>>>> -       if (!err && host->sdio_irqs)
>>>> -               wake_up_process(host->sdio_irq_thread);
>>>> +       if (!err && host->sdio_irqs) {
>>>> +               if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>>> +                       wake_up_process(host->sdio_irq_thread);
>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>> +                       mmc_host_clk_hold(host);
>>>> +                       host->ops->enable_sdio_irq(host, 1);
>>>> +                       mmc_host_clk_release(host);
>>>> +               }
>>>> +       }
>>>> +
>>>>         mmc_release_host(host);
>>>>
>>>>         host->pm_flags &= ~MMC_PM_KEEP_POWER;
>>>> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
>>>> index 5cc13c8..696eca4 100644
>>>> --- a/drivers/mmc/core/sdio_irq.c
>>>> +++ b/drivers/mmc/core/sdio_irq.c
>>>> @@ -208,7 +208,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
>>>>                                 host->sdio_irqs--;
>>>>                                 return err;
>>>>                         }
>>>> -               } else {
>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>                         mmc_host_clk_hold(host);
>>>>                         host->ops->enable_sdio_irq(host, 1);
>>>>                         mmc_host_clk_release(host);
>>>> @@ -229,7 +229,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
>>>>                 if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>>>                         atomic_set(&host->sdio_irq_thread_abort, 1);
>>>>                         kthread_stop(host->sdio_irq_thread);
>>>> -               } else {
>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>                         mmc_host_clk_hold(host);
>>>>                         host->ops->enable_sdio_irq(host, 0);
>>>>                         mmc_host_clk_release(host);
>>>> -- 1.7.1
>>>>
>>>> On 2014/8/12 18:23, Ulf Hansson wrote:
>>>>> On 11 August 2014 07:49, Fu, Zhonghui <zhonghui.fu@linux.intel.com> wrote:
>>>>>> From 6cee984e1d76ba0a3320430f8cf4318ab65fcf06 Mon Sep 17 00:00:00 2001
>>>>>> From: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>>>>> Date: Tue, 5 Aug 2014 12:44:38 +0800
>>>>>> Subject: [PATCH] mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread
>>>>>>
>>>>>> 781e989cf59 ("mmc: sdhci: convert to new SDIO IRQ handling") and
>>>>>> bf3b5ec66bd ("mmc: sdio_irq: rework sdio irq handling") disabled
>>>>>> the use of our own custom threaded IRQ handler, but left in an
>>>>>> unconditional wake_up_process() on that handler at resume-time.
>>>>>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=80151
>>>>>>
>>>>>> In addition, the check for MMC_CAP_SDIO_IRQ capability is added
>>>>>> before enable sdio IRQ.
>>>>>>
>>>>>> Signed-off-by: Jaehoon Chung <jh80.chung@samsung.com>
>>>>>> Signed-off-by: Chris Ball <chris@printf.net>
>>>>>> Signed-off-by: Fu Zhonghui <zhonghui.fu@linux.intel.com>
>>>>>> ---
>>>>>>  drivers/mmc/core/sdio.c     |   14 ++++++++++++--
>>>>>>  drivers/mmc/core/sdio_irq.c |    4 ++--
>>>>>>  2 files changed, 14 insertions(+), 4 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
>>>>>> index e636d9e..e04a540 100644
>>>>>> --- a/drivers/mmc/core/sdio.c
>>>>>> +++ b/drivers/mmc/core/sdio.c
>>>>>> @@ -992,8 +992,18 @@ static int mmc_sdio_resume(struct mmc_host *host)
>>>>>>                 }
>>>>>>         }
>>>>>>
>>>>>> -       if (!err && host->sdio_irqs)
>>>>>> -               wake_up_process(host->sdio_irq_thread);
>>>>>> +       if (!err && host->sdio_irqs) {
>>>>>> +               if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>>>>> +                       wake_up_process(host->sdio_irq_thread);
>>>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>>> +                       mmc_release_host(host);
>>>>> Why mmc_release_host() and the corresponding mmc_claim_host() below?
>>>>> Those shouldn't be needed I think.
>>>> You are right. These two functions shouldn't be invoked here. I made a new patch as above.
>>>>
>>>>
>>>> Thanks,
>>>> Zhonghui
>>>>>> +                       mmc_host_clk_hold(host);
>>>>>> +                       host->ops->enable_sdio_irq(host, 1);
>>>>>> +                       mmc_host_clk_release(host);
>>>>>> +                       mmc_claim_host(host);
>>>>>> +               }
>>>>>> +       }
>>>>>> +
>>>>>>         mmc_release_host(host);
>>>>>>
>>>>>>         host->pm_flags &= ~MMC_PM_KEEP_POWER;
>>>>>> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
>>>>>> index 5cc13c8..696eca4 100644
>>>>>> --- a/drivers/mmc/core/sdio_irq.c
>>>>>> +++ b/drivers/mmc/core/sdio_irq.c
>>>>>> @@ -208,7 +208,7 @@ static int sdio_card_irq_get(struct mmc_card *card)
>>>>>>                                 host->sdio_irqs--;
>>>>>>                                 return err;
>>>>>>                         }
>>>>>> -               } else {
>>>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>>>                         mmc_host_clk_hold(host);
>>>>>>                         host->ops->enable_sdio_irq(host, 1);
>>>>>>                         mmc_host_clk_release(host);
>>>>>> @@ -229,7 +229,7 @@ static int sdio_card_irq_put(struct mmc_card *card)
>>>>>>                 if (!(host->caps2 & MMC_CAP2_SDIO_IRQ_NOTHREAD)) {
>>>>>>                         atomic_set(&host->sdio_irq_thread_abort, 1);
>>>>>>                         kthread_stop(host->sdio_irq_thread);
>>>>>> -               } else {
>>>>>> +               } else if (host->caps & MMC_CAP_SDIO_IRQ) {
>>>>>>                         mmc_host_clk_hold(host);
>>>>>>                         host->ops->enable_sdio_irq(host, 0);
>>>>>>                         mmc_host_clk_release(host);
>>>>>> -- 1.7.1
>>>>>>
>>>>> Thanks for working on this!
>>>>>
>>>>> Kind regards
>>>>> Uffe
>>>>> --
>>>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>>>> the body of a message to majordomo@vger.kernel.org
>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>> Please read the FAQ at  http://www.tux.org/lkml/
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

