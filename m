Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727Ab3GaFWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 01:22:30 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:32793 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754374Ab3GaFW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 01:22:28 -0400
Message-ID: <51F89B59.6010708@ti.com>
Date: Wed, 31 Jul 2013 00:06:33 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Tony Lindgren <tony@atomide.com>, Vinod Koul <vinod.koul@intel.com>,
        Benoit Cousson <benoit.cousson@linaro.org>,
        Balaji TK <balajitk@ti.com>, Arnd Bergmann <arnd@arndb.de>,
        Jason Kridner <jkridner@beagleboard.org>,
        Mark Jackson <mpfj-list@newflow.co.uk>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Pantel Antoniou <panto@antoniou-consulting.com>
Subject: Re: [PATCH v2] ARM: EDMA: Fix clearing of unused list for DT DMA
 resources
References: <1374515989-7391-1-git-send-email-joelf@ti.com> <51F61359.1090309@ti.com> <51F73738.6080901@ti.com> <51F7E9D0.1080107@ti.com>
In-Reply-To: <51F7E9D0.1080107@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 11:29 AM, Sekhar Nori wrote:
> On 7/30/2013 9:17 AM, Joel Fernandes wrote:
> 
>>>> diff --git a/arch/arm/common/edma.c b/arch/arm/common/edma.c
>>>> index a432e6c..765d578 100644
>>>> --- a/arch/arm/common/edma.c
>>>> +++ b/arch/arm/common/edma.c
> 
>>>> +	} else {
>>>> +		for (; i < pdev->num_resources; i++) {
>>>> +			if ((pdev->resource[i].flags & IORESOURCE_DMA) &&
>>>> +			    (int)pdev->resource[i].start >= 0) {
>>>> +				ctlr = EDMA_CTLR(pdev->resource[i].start);
>>>> +				clear_bit(EDMA_CHAN_SLOT(
>>>> +					  pdev->resource[i].start),
>>>> +					  edma_cc[ctlr]->edma_unused);
>>>> +			}
>>>
>>> So there is very little in common between OF and non-OF versions of this
>>> function. Why not have two different versions of this function for the
>>> two cases? The OF version can reside under the CONFIG_OF conditional
>>> already in use in the file. This will also save you the ugly line breaks
>>> you had to resort to due to too deep indentation.
>>
>> Actually those line breaks are not necessary and wouldn't result in
>> compilation errors. I was planning to drop them. I'll go ahead and split
>> it out anyway, now that also the OF version of the function is going to
>> be bit longer if we use the of_parse functions.
>>
>> Thanks for your review,
> 
> It turns out, I gave a bad idea. What I suggested will break the case of
> non-DT boot with CONFIG_OF enabled. So what you had was fine. May be
> just return from "if (dev->of_node)" so you don't need to have an else
> block and can save on the indentation.>

Ok, sure. I will go ahead and return from the if block.

Thanks,

-Joel


