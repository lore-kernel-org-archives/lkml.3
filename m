Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3KURIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 12:08:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:50318 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3KURIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 12:08:32 -0500
Message-ID: <528E3DD4.7030607@ti.com>
Date: Thu, 21 Nov 2013 22:37:32 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
CC: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@kernel.crashing.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/12] mtd: nand: davinci: don't set timings if AEMIF
 is used
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>, <1384187188-5776-11-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D53@DNCE04.ent.ti.com> <528307F0.6000805@ti.com> <52838941.4060207@ti.com> <5284ABB9.70608@ti.com> <5284DFE7.70308@ti.com>
In-Reply-To: <5284DFE7.70308@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2013 8:06 PM, Santosh Shilimkar wrote:
> On Thursday 14 November 2013 05:53 AM, Nori, Sekhar wrote:
>> On Wednesday 13 November 2013 07:44 PM, Santosh Shilimkar wrote:
>>> On Wednesday 13 November 2013 12:02 AM, Sekhar Nori wrote:
>>>> On Monday 11 November 2013 10:40 PM, Khoronzhuk, Ivan wrote:
>>>>> If Davinci AEMIF is used we don't need to set timings and bus width.
>>>>> It is done by AEMIF driver (drivers/memory/davinci-aemfi.c).
>>>>>
>>>>> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
>>>>> ---
>>>>>  drivers/mtd/nand/davinci_nand.c |   22 +++++++++++++++-------
>>>>>  1 file changed, 15 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
>>>>> index 4705214..879e915 100644
>>>>> --- a/drivers/mtd/nand/davinci_nand.c
>>>>> +++ b/drivers/mtd/nand/davinci_nand.c
>>>>> @@ -742,27 +742,35 @@ static int __init nand_davinci_probe(struct platform_device *pdev)
>>>>>                 goto err_clk_enable;
>>>>>         }
>>>>>
>>>>> +#if !IS_ENABLED(CONFIG_TI_DAVINCI_AEMIF)
>>>>
>>>> This is a hack! Just because AEMIF driver is enabled, it does not
>>>> guarantee that the timings have been setup by it. Instead of configuring
>>>> timings in two drivers, why not just convert everyone over to use the
>>>> new driver. Dont worry about breaking old platforms, I will help test
>>>> and ack them.
>>>>
>>> How about you take a stab at and convert the DaVinci code over to make
>>> use of new driver. We are trying to re-use as much as possible from the
>>> common drivers and also making an option so that the DaVinci arch can
>>> move over to these drivers if they want to.
>>
>> Sure I could.
>>
> Thanks
> 
>> Ivan,
>>
>> The AEMIF driver does not use platfrom_data currently. Is that something
>> you can add or you want me to take a stab at that as well?
>>
> The AEMIF new driver is device tree only and thats the direction. So the
> better thing would be to convert Davinci to DT and then make use of this
> new driver. Thats how most of the new drivers used on arm socs are
> moving. Adding platform data to new driver is a step in backward
> direction so I would want to avoid that.

Yes, that would be the ideal way. But the reality is that there is close
to zero chance of all the DaVinci platforms using AEMIF ever getting
converted to DT. This means that we will never be able to get rid of
this piece of code.

I do agree platform data is not the direction you want to take on ARM
but at the same time its not really a deprecated mechanism as far as the
broader kernel is concerned.

So, can we consider adding platform data mechanism to the AEMIF driver?

Thanks,
Sekhar
