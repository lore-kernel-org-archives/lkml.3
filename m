Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbaIVC7k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 22:59:40 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:26354 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIVC7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 22:59:38 -0400
X-AuditID: cbfee691-f79b86d000004a5a-92-541f9097583f
Message-id: <541F9096.3050700@samsung.com>
Date: Mon, 22 Sep 2014 11:59:34 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>
Cc: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Subject: Re: [PATCH] mmc: Add delay between CMD6 and CMD13 for Sandisk eMMC
 cards
References: <1410265614-3275-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <54110B29.7030303@samsung.com>
 <CAL8zT=iezoevh_12GAZyDOdRy1dAS876RZDUJGVTZyY4zYZbaQ@mail.gmail.com>
 <5416C30C.6010400@samsung.com> <20140921174827.GB11414@xo-6d-61-c0.localdomain>
In-reply-to: <20140921174827.GB11414@xo-6d-61-c0.localdomain>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkSHf6BPkQg+dLZSwmXN7OaHHsyU5W
	i8u75rBZHPnfz2hx99RRNosP9y8yWxxfG+7A7nHn2h42jxuvFjJ59G1ZxeixYvV3do/Pm+Q8
	tp+YyxTAFsVlk5Kak1mWWqRvl8CV8XPLE5aCrUIVXxq2szcwbuPrYuTkkBAwkfgx8TkrhC0m
	ceHeerYuRi4OIYGljBLXXu9mhCn60DCRDcQWEpjOKDHthxVE0WtGieZtz8ESvAJaEmvebQJr
	YBFQlbhwdT0LiM0moCOx/dtxJhBbVCBM4lDbPCaIekGJH5PvgdWICMhLbO1bwQwylFlgLpPE
	svfTgAZxcAgLBEucnWEJsbiTSaJtQxxImFPAVuLjwTSQMDPQ+P2t09ggbHmJzWveMkPcfI5d
	ouMgD8Q5AhLfJh9iAWmVEJCV2HQAqkRS4uCKGywTGMVmITloFpKps5BMXcDIvIpRNLUguaA4
	Kb3IVK84Mbe4NC9dLzk/dxMjMPZO/3s2cQfj/QPWhxgFOBiVeHh/tMiHCLEmlhVX5h5iNAW6
	YiKzlGhyPjDC80riDY3NjCxMTUyNjcwtzZTEeXWkfwYLCaQnlqRmp6YWpBbFF5XmpBYfYmTi
	4JRqYAy3ti+pDBQ8HXNx04kPS9mS+b34p53ql3guqPBBc+f6A9fZflaG8v68miz5skTt3SfO
	vcmHHTmqPmeUTzhcOsFu/Qdh7jnv1V80rQvJVHjCZab0+tZ2U9UHK2w3aq1KWsLYNt9kmcr2
	Fv2FJ5Z+WDN5Q6dSkHFmavm1z8t+9PTdkym45xrnJKTEUpyRaKjFXFScCACuCwpvuAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAIsWRmVeSWpSXmKPExsVy+t9jQd3pE+RDDH5PEbWYcHk7o8WxJztZ
	LS7vmsNmceR/P6PF3VNH2Sw+3L/IbHF8bbgDu8eda3vYPG68Wsjk0bdlFaPHitXf2T0+b5Lz
	2H5iLlMAW1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4Cu
	W2YO0C1KCmWJOaVAoYDE4mIlfTtME0JD3HQtYBojdH1DguB6jAzQQMIaxoyfW56wFGwVqvjS
	sJ29gXEbXxcjJ4eEgInEh4aJbBC2mMSFe+vBbCGB6YwS035YdTFyAdmvGSWatz0HS/AKaEms
	ebeJEcRmEVCVuHB1PQuIzSagI7H923EmEFtUIEziUNs8Joh6QYkfk++B1YgIyEts7VvBDDKU
	WWAuk8Sy99OABnFwCAsES5ydYQmxuJNJom1DHEiYU8BW4uPBNJAwM9D4/a3T2CBseYnNa94y
	T2AUmIVkwywkZbOQlC1gZF7FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERzbz6R3MK5qsDjE
	KMDBqMTD+6NFPkSINbGsuDL3EKMEB7OSCO/RHKAQb0piZVVqUX58UWlOavEhRlNgAExklhJN
	zgemnbySeENjEzMjSyNzQwsjY3Mlcd6DrdaBQgLpiSWp2ampBalFMH1MHJxSDYzKRZf7lVdI
	lBsvWXjLOfADs2+TRmPhmQ1Z2Qf5+1/KNR473jpL/L1i6a3s+EUCy85piX99abbGd9a5CvOi
	czmXio2+60dUOldy59Sb3/Ht2L/Q8FFGRbO6qXE/m8L8Uxkff/wL/Mdydpli61emY89C5Svm
	zw4+pcp5trax1uhMs/Oy5yWN3EosxRmJhlrMRcWJAPBTCtgDAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/22/2014 02:48 AM, Pavel Machek wrote:
> On Mon 2014-09-15 19:44:28, Jaehoon Chung wrote:
>> On 09/15/2014 07:08 PM, Jean-Michel Hautbois wrote:
>>> Hi Jaehoon,
>>>
>>>> On 09/09/2014 09:26 PM, Jean-Michel Hautbois wrote:
>>>>> Tested on a i.MX6 board, with Sandisk SDIN5D1-2G.
>>>>> Without this patch, I/O errors occur.
>>>>> This eMMC seems to have a different Manufacturer ID as it reads 0x45
>>>>> and not 0x2 as specified in datasheet.
>>>>
>>>> I think this patch don't merge into mainline.
>>>> This is not solution for problem.
>>>> you mentioned the below comment, this is workaround.
>>>
>>> Yes
>>>
>>>>>
>>>>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>>>> ---
>>>>>  drivers/mmc/core/mmc_ops.c | 9 +++++++++
>>>>>  1 file changed, 9 insertions(+)
>>>>>
>>>>> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
>>>>> index f51b5ba..91babaa 100644
>>>>> --- a/drivers/mmc/core/mmc_ops.c
>>>>> +++ b/drivers/mmc/core/mmc_ops.c
>>>>> @@ -458,6 +458,15 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>>>>>       if (!use_busy_signal)
>>>>>               return 0;
>>>>>
>>>>> +     /* WORKAROUND: for Sandisk eMMC cards, it might need certain delay
>>>>> +      * before sending CMD13 after CMD6
>>>>> +      * On SDIN5D1-2G MANFID is 0x45 and not 0x2 as specified in datasheet
>>>>> +      */
>>>>> +     if (card->cid.manfid == CID_MANFID_SANDISK ||
>>>>> +             card->cid.manfid == 0x45) {
>>>>> +             msleep(1);
>>>>> +     }
>>>>
>>>> If it's a general problem of Sandisk SDIN5D1-2G,
>>>> I think you need to verify this problem. And can you use the MMC_FIXUP() and QUIRK?
>>>
>>> Well, this is difficult to verify, I know that on all my SDIN5D1-2G I
>>> have this MANFID different from what is defined by CID_MANFID_SANDISK.
>>> How should I use MMC_FIXUP ? Like this ?
>>
>> I think you need to explain why delay is need.
>> i didn't have same card, but it might be your host controller or other problem. 
> 
> Datasheet says it is needed, so we need to do the delay.
> 
> Adding pointer to the datasheet (page, chapter) to the comment might be good idea.

It's good. Then i think good that it will add the delay with the MMC_FIXUP and QUIRK.

Best Regards,
Jaehoon Chung

> 
> 

