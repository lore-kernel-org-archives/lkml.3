Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbbA0MDB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:03:01 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:53627 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755485AbbA0MC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:02:57 -0500
Message-ID: <54C77E69.7050600@ahsoftware.de>
Date: Tue, 27 Jan 2015 13:02:49 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: linux-mmc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Chris Ball <chris@printf.net>, Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH] mmc: print message if a card supports secure erase/trim
References: <1422359304-30321-1-git-send-email-holler@ahsoftware.de> <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
In-Reply-To: <CAFLxGvyuE8odPdNSD1PTccyBXFm=JO=ooikUOJfz41aFpsUAJg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.01.2015 um 12:55 schrieb Richard Weinberger:
> On Tue, Jan 27, 2015 at 12:48 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>> It's an interesting detail, so inform the user about it.
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>>   drivers/mmc/core/bus.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
>> index 8a1f124..4a60028 100644
>> --- a/drivers/mmc/core/bus.c
>> +++ b/drivers/mmc/core/bus.c
>> @@ -347,6 +347,10 @@ int mmc_add_card(struct mmc_card *card)
>>                          uhs_bus_speed_mode, type, card->rca);
>>          }
>>
>> +       if (mmc_can_secure_erase_trim(card))
>> +               pr_info("%s: card supports secure erase/trim\n",
>> +                       mmc_hostname(card->host));
>> +
>
> Please make this a sysfs attribute.
> Exposing such properties as log messages is horrible.

Look at the source at the message which is printed just before and 
decide which one you find more informational / useful.

Alexander Holler

