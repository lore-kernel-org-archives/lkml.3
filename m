Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaIPB0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 21:26:05 -0400
Received: from imx9.toshiba.co.jp ([202.33.96.51]:62980 "EHLO
	imx9.toshiba.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689AbaIPB0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 21:26:02 -0400
X-Greylist: delayed 1673 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 21:26:01 EDT
From: <hisanao.kinkawa@toshiba.co.jp>
To: <jean-michel.hautbois@vodalys.com>, <jh80.chung@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <tgih.jun@samsung.com>, <ulf.hansson@linaro.org>, <chris@printf.net>
Subject: Re: [PATCH] mmc: Add delay between CMD6 and CMD13 for Sandisk eMMC
 cards
Thread-Topic: [PATCH] mmc: Add delay between CMD6 and CMD13 for Sandisk eMMC
 cards
Thread-Index: AQHPzClihiT9qP4CC02kQYp4vcc1opv6o8KAgAbHH4CAAAn4AIAAAqSAgAAJ2QCAAOC+gA==
Date: Tue, 16 Sep 2014 00:53:34 +0000
Message-ID: <54178A0D.1050004@toshiba.co.jp>
References: <1410265614-3275-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <54110B29.7030303@samsung.com>
 <CAL8zT=iezoevh_12GAZyDOdRy1dAS876RZDUJGVTZyY4zYZbaQ@mail.gmail.com>
 <5416C30C.6010400@samsung.com>
 <CAL8zT=jVWTp5tzW3Pi2MFAq6gySeinvACwSyFdj+4SpYEW2YXg@mail.gmail.com>
 <CAL8zT=j86XDU7TZMALYnP+359dxGZHqWsERtRJaO8r-DES1dgg@mail.gmail.com>
In-Reply-To: <CAL8zT=j86XDU7TZMALYnP+359dxGZHqWsERtRJaO8r-DES1dgg@mail.gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
user-agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
x-originating-ip: [133.199.145.187]
msscp.transfermailtomossagent: 103
Content-Type: text/plain; charset="utf-8"
Content-ID: <67135EB60333E5478C9A6E1CF358AD93@toshiba.local>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8G1QB9G024222

Hi

Do not hit the following bug?
Often, This bug fails setting of CMD6.

-------- Original Message --------
Subject: 	Re: [PATCH v2] mmc:sdhci: handle busy-end interrupt during command
Date: 	Tue, 2 Sep 2014 11:27:51 +0200
From: 	Ulf Hansson <ulf.hansson@linaro.org>
To: 	Chanho Min <chanho.min@lge.com>

	

On 30 August 2014 05:40, Chanho Min <chanho.min@lge.com> wrote:
> It is fully legal for a controller to start handling busy-end interrupt
> before it has signaled that the command has completed. So make sure
> we do things in the proper order, Or it results that command interrupt
> is ignored so it can cause unexpected operations. This is founded at some
> toshiba emmc with the bellow warning.
>
> "mmc0: Got command interrupt 0x00000001 even though
> no command operation was in progress."
>
> This issue has been also reported by Youssef TRIKI:
> It is not specific to Toshiba devices, and happens with eMMC devices
> as well as SD card which support Auto-CMD12 rather than CMD23.
>
> Also, similar patch is submitted by:
> Gwendal Grignou <gwendal@chromium.org>
>
> Changes since v1:
>  Fixed conflict with the next of git.linaro.org/people/ulf.hansson/mmc.git
>  and Tested if issue is fixed again.
>
> Signed-off-by: Hankyung Yu <hankyung.yu@lge.com>
> Signed-off-by: Chanho Min <chanho.min@lge.com>
> Tested-by: Youssef TRIKI <youssef.triki@st.com>

Best Regards,
=======================================================
Hisanao Kinkawa      [hisanao.kinkawa@toshiba.co.jp <mailto:hisanao.kinkawa@toshiba.co.jp>]
=======================================================


(2014/09/15 20:29), Jean-Michel Hautbois wrote:
> 2014-09-15 12:53 GMT+02:00 Jean-Michel Hautbois
> <jean-michel.hautbois@vodalys.com>:
>> 2014-09-15 12:44 GMT+02:00 Jaehoon Chung <jh80.chung@samsung.com>:
>>> On 09/15/2014 07:08 PM, Jean-Michel Hautbois wrote:
>>>> Hi Jaehoon,
>>>>
>>>>> On 09/09/2014 09:26 PM, Jean-Michel Hautbois wrote:
>>>>>> Tested on a i.MX6 board, with Sandisk SDIN5D1-2G.
>>>>>> Without this patch, I/O errors occur.
>>>>>> This eMMC seems to have a different Manufacturer ID as it reads 0x45
>>>>>> and not 0x2 as specified in datasheet.
>>>>> I think this patch don't merge into mainline.
>>>>> This is not solution for problem.
>>>>> you mentioned the below comment, this is workaround.
>>>> Yes
>>>>
>>>>>> Signed-off-by: Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>
>>>>>> ---
>>>>>>   drivers/mmc/core/mmc_ops.c | 9 +++++++++
>>>>>>   1 file changed, 9 insertions(+)
>>>>>>
>>>>>> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
>>>>>> index f51b5ba..91babaa 100644
>>>>>> --- a/drivers/mmc/core/mmc_ops.c
>>>>>> +++ b/drivers/mmc/core/mmc_ops.c
>>>>>> @@ -458,6 +458,15 @@ int __mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>>>>>>        if (!use_busy_signal)
>>>>>>                return 0;
>>>>>>
>>>>>> +     /* WORKAROUND: for Sandisk eMMC cards, it might need certain delay
>>>>>> +      * before sending CMD13 after CMD6
>>>>>> +      * On SDIN5D1-2G MANFID is 0x45 and not 0x2 as specified in datasheet
>>>>>> +      */
>>>>>> +     if (card->cid.manfid == CID_MANFID_SANDISK ||
>>>>>> +             card->cid.manfid == 0x45) {
>>>>>> +             msleep(1);
>>>>>> +     }
>>>>> If it's a general problem of Sandisk SDIN5D1-2G,
>>>>> I think you need to verify this problem. And can you use the MMC_FIXUP() and QUIRK?
>>>> Well, this is difficult to verify, I know that on all my SDIN5D1-2G I
>>>> have this MANFID different from what is defined by CID_MANFID_SANDISK.
>>>> How should I use MMC_FIXUP ? Like this ?
>>> I think you need to explain why delay is need.
>>> i didn't have same card, but it might be your host controller or other problem.
>> Well, I don't know why it is needed, this is undocumented, nothing in
>> datasheet explains anything about this.
> It seems to be uSDHC / DDR mode related. I don't even know if this is
> limited to Sandisk !
> And I don't have another board with another manufacturer eMMC to test.
> Maybe some guys from Freescale could help with this ?
>
> Thanks,
> JM
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
