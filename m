Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaIOKoq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 06:44:46 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:62648 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754033AbaIOKoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 06:44:44 -0400
X-AuditID: cbfee68e-f79536d000000fd1-f5-5416c30c3418
Message-id: <5416C30C.6010400@samsung.com>
Date: Mon, 15 Sep 2014 19:44:28 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        Jaehoon Chung <jh80.chung@samsung.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "tgih.jun@samsung.com" <tgih.jun@samsung.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <chris@printf.net>
Subject: Re: [PATCH] mmc: Add delay between CMD6 and CMD13 for Sandisk eMMC
 cards
References: <1410265614-3275-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <54110B29.7030303@samsung.com>
 <CAL8zT=iezoevh_12GAZyDOdRy1dAS876RZDUJGVTZyY4zYZbaQ@mail.gmail.com>
In-reply-to: <CAL8zT=iezoevh_12GAZyDOdRy1dAS876RZDUJGVTZyY4zYZbaQ@mail.gmail.com>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPIsWRmVeSWpSXmKPExsWyRsSkUJfnsFiIwYmb3BYTLm9ntDj2ZCer
	xY1fbawWl3fNYbM48r+f0eLD/YvMFsfXhjuwe9y5tofN48arhUwefVtWMXp83iTnsf3EXKYA
	1igum5TUnMyy1CJ9uwSujJO34wrmilQcv8XWwPiKv4uRk0NCwERiU9dBdghbTOLCvfVsILaQ
	wFJGiflba2FqjhzdyAgRX8Qo8aGRu4uRC8h+zSjxuvEkM0iCV0BL4mPTBLBBLAKqElN79oI1
	sAnoSGz/dpwJxBYVCJM41DaPCaJeUOLH5HssILaIQKrEqdntTCBDmQUeMUpcvHYf6AoODmGB
	YImzMywhlm1nlNjUsgIszgkU//HZH6SXWUBdYtK8RcwQtrzE5jVvmUHqJQROsUs8WbyDCeIg
	AYlvkw+xgPRKCMhKbDrADPGYpMTBFTdYJjCKzUJy0iwkY2chGbuAkXkVo2hqQXJBcVJ6kZFe
	cWJucWleul5yfu4mRmC8nf73rG8H480D1ocYBTgYlXh4C/rEQoRYE8uKK3MPMZoCXTGRWUo0
	OR8Y1Xkl8YbGZkYWpiamxkbmlmZK4rwJUj+DhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTBa
	Lyx68/NA36lfShLZfH2GZoIyfa1FppeMlh+Zp6rce/xCVHXDk/deMztE2T5xH3+0seXpS9H9
	ufaR22PObW1XX9guGvVXMTzuROBbd814ue3cAp7Zpt7cd8y9Ol9cfup0vbLjV72t5CZ9K723
	tkLbztjcV+OVO2W6onDitvknVx81zLi05YESS3FGoqEWc1FxIgCeSowasgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFIsWRmVeSWpSXmKPExsVy+t9jAV2ew2IhBuc+sFpMuLyd0eLYk52s
	Fjd+tbFaXN41h83iyP9+RosP9y8yWxxfG+7A7nHn2h42jxuvFjJ59G1ZxejxeZOcx/YTc5kC
	WKMaGG0yUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgM5Q
	UihLzCkFCgUkFhcr6dthmhAa4qZrAdMYoesbEgTXY2SABhLWMGacvB1XMFek4vgttgbGV/xd
	jJwcEgImEkeObmSEsMUkLtxbzwZiCwksYpT40MjdxcgFZL9mlHjdeJIZJMEroCXxsWkCO4jN
	IqAqMbVnL1gzm4COxPZvx5lAbFGBMIlDbfOYIOoFJX5MvscCYosIpEqcmt3OBDKUWeARo8TF
	a/eBtnFwCAsES5ydYQmxbDujxKaWFWBxTqD4j8/+IL3MAuoSk+YtYoaw5SU2r3nLPIFRYBaS
	FbOQlM1CUraAkXkVo2hqQXJBcVJ6rpFecWJucWleul5yfu4mRnA8P5PewbiqweIQowAHoxIP
	b2GfWIgQa2JZcWXuIUYJDmYlEd7a/UAh3pTEyqrUovz4otKc1OJDjKbAEJjILCWanA9MNXkl
	8YbGJmZGlkbmhhZGxuZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODilGhh5RH0M2+MeLuqZePTe
	3ktevIt5+4SzS6646k9dUqD647m8HmPvL9ufE3lfMbZ/91qxpexCaPvWUH4Jff+ik/JbT2/K
	+X44dbUSs2qrZN8uwynN87nM/q+68u/ulase0tM9tVcWcT6Q4338/+CmCfFBl1tP2skKfJmx
	omin05+WQ5VvNqZuc96oxFKckWioxVxUnAgAwyr2O/0CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 07:08 PM, Jean-Michel Hautbois wrote:
> Hi Jaehoon,
> 
>> On 09/09/2014 09:26 PM, Jean-Michel Hautbois wrote:
>>> Tested on a i.MX6 board, with Sandisk SDIN5D1-2G.
>>> Without this patch, I/O errors occur.
>>> This eMMC seems to have a different Manufacturer ID as it reads 0x45
>>> and not 0x2 as specified in datasheet.
>>
>> I think this patch don't merge into mainline.
>> This is not solution for problem.
>> you mentioned the below comment, this is workaround.
> 
> Yes
> 
>>>
>>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>> ---
>>>  drivers/mmc/core/mmc_ops.c | 9 +++++++++
>>>  1 file changed, 9 insertions(+)
>>>
>>> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
>>> index f51b5ba..91babaa 100644
>>> --- a/drivers/mmc/core/mmc_ops.c
>>> +++ b/drivers/mmc/core/mmc_ops.c
>>> @@ -458,6 +458,15 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>>>       if (!use_busy_signal)
>>>               return 0;
>>>
>>> +     /* WORKAROUND: for Sandisk eMMC cards, it might need certain delay
>>> +      * before sending CMD13 after CMD6
>>> +      * On SDIN5D1-2G MANFID is 0x45 and not 0x2 as specified in datasheet
>>> +      */
>>> +     if (card->cid.manfid == CID_MANFID_SANDISK ||
>>> +             card->cid.manfid == 0x45) {
>>> +             msleep(1);
>>> +     }
>>
>> If it's a general problem of Sandisk SDIN5D1-2G,
>> I think you need to verify this problem. And can you use the MMC_FIXUP() and QUIRK?
> 
> Well, this is difficult to verify, I know that on all my SDIN5D1-2G I
> have this MANFID different from what is defined by CID_MANFID_SANDISK.
> How should I use MMC_FIXUP ? Like this ?

I think you need to explain why delay is need.
i didn't have same card, but it might be your host controller or other problem. 

You can define the 0x45 with other naming.
ex) CID_MANFID_SANDISK_2	0x45 ? Just example.:)

And Your first patch is applied for every Sandisk card, isn't?

Best Regards,
Jaehoon Chung

> MMC_FIXUP("SEM02G", 0x45, CID_OEMID_ANY, add_quirk, MMC_QUIRK_INAND_CMD13) ?
> 
> If so, can I use :
> if (card->quirks & MMC_QUIRK_INAND_CMD38)
>     msleep(1);
> 
> In drivers/mmc/core/mmc_ops.c ?
> Is this the good way ?
> 
> Thanks,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

