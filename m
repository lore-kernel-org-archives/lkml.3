Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbaAMRnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:43:49 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35046 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752380AbaAMRnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:43:46 -0500
Message-ID: <52D425CF.9050507@free-electrons.com>
Date: Mon, 13 Jan 2014 18:43:43 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ulf Hansson <ulf.hansson@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3] mmc: atmel-mci: add vmmc-supply support
References: <1382006808-22728-1-git-send-email-alexandre.belloni@free-electrons.com> <CAPDyKFoiWOE47DWrUHNWVPyihL=uCidpd52TV1vgUbq1aMNvbw@mail.gmail.com> <52B09FF0.4070200@free-electrons.com> <20131218081645.GA4268@ldesroches-Latitude-E6320>
In-Reply-To: <20131218081645.GA4268@ldesroches-Latitude-E6320>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I still don't see that on mmc.git, Any issue with that patch ? I would
prefer not missing the 3.14 merge window.

Regards

On 18/12/2013 09:16, Ludovic Desroches wrote:
> Hi Alexandre,
> 
> On Tue, Dec 17, 2013 at 08:03:12PM +0100, Alexandre Belloni wrote:
>> Hi,
>>
>> It seems that patch never made it to the mainline. Is it still missing
>> something ?
> 
> No reason on my side, maybe because my ack is missing but I thought I
> gave it on a previous version, maybe I am wrong.
> 
> So Acked-by: Ludovic Desroches <ludovic.desroches@atmel.com>
> 
> 
> Regards
> 
> Ludovic
> 
>>
>> Regards,
>>
>> On 17/10/2013 15:56, Ulf Hansson wrote:
>>> On 17 October 2013 12:46, Alexandre Belloni
>>> <alexandre.belloni@free-electrons.com> wrote:
>>>> Other MMC hosts handle a regulator named vmmc-supply that allows to power the
>>>> MMC card or SDIO device before communicating on the bus.
>>>>
>>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>> Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
>>>
>>>> ---
>>>>
>>>> Changes in v2:
>>>>  - use mmc_regulator_get_supply instead of devm_regulator_get
>>>>
>>>> Changes in v3:
>>>>  - en/disable the regulator in .set_ios using mmc_regulator_set_ocr
>>>>
>>>>  drivers/mmc/host/atmel-mci.c | 7 +++++++
>>>>  1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/drivers/mmc/host/atmel-mci.c b/drivers/mmc/host/atmel-mci.c
>>>> index 69e438e..a9e1ba6 100644
>>>> --- a/drivers/mmc/host/atmel-mci.c
>>>> +++ b/drivers/mmc/host/atmel-mci.c
>>>> @@ -1385,8 +1385,14 @@ static void atmci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>>>>                 clk_unprepare(host->mck);
>>>>
>>>>         switch (ios->power_mode) {
>>>> +       case MMC_POWER_OFF:
>>>> +               if (!IS_ERR(mmc->supply.vmmc))
>>>> +                       mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, 0);
>>>> +               break;
>>>>         case MMC_POWER_UP:
>>>>                 set_bit(ATMCI_CARD_NEED_INIT, &slot->flags);
>>>> +               if (!IS_ERR(mmc->supply.vmmc))
>>>> +                       mmc_regulator_set_ocr(mmc, mmc->supply.vmmc, ios->vdd);
>>>>                 break;
>>>>         default:
>>>>                 /*
>>>> @@ -2196,6 +2202,7 @@ static int __init atmci_init_slot(struct atmel_mci *host,
>>>>         }
>>>>
>>>>         host->slot[id] = slot;
>>>> +       mmc_regulator_get_supply(mmc);
>>>>         mmc_add_host(mmc);
>>>>
>>>>         if (gpio_is_valid(slot->detect_pin)) {
>>>> --
>>>> 1.8.1.2
>>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> -- 
>> Alexandre Belloni, Free Electrons
>> Embedded Linux, Kernel and Android engineering
>> http://free-electrons.com
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
