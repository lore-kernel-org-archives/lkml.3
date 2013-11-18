Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab3KROhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:37:10 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:51932 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab3KROhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:37:04 -0500
Message-ID: <528A260D.7090807@koalo.de>
Date: Mon, 18 Nov 2013 15:37:01 +0100
From: Florian Meier <florian.meier@koalo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "Koul, Vinod" <vinod.koul@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv7] dmaengine: Add support for BCM2835
References: <5288E327.8050809@koalo.de> <1384768816.14845.186.camel@smile>	 <528A051A.7000703@koalo.de> <1384785017.14845.214.camel@smile>
In-Reply-To: <1384785017.14845.214.camel@smile>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> +static enum dma_status bcm2835_dma_tx_status(struct dma_chan *chan,
>>>> +	dma_cookie_t cookie, struct dma_tx_state *txstate)
>>>> +{
>>>
>>> []
>>>
>>>> +	} else {
>>>> +		txstate->residue = 0;
>>>
>>> Useless assignment since dmaengine will do this for you in
>>> dma_cookie_status.
>>
>> I agree that it is useless, but I think otherwise it might be concealed
>> that there is a third case left that uses a residue of 0. Do you think a
>> comment is better? E.g.:
>>
>> +	} else {
>> +		/* residue = 0 per default */
> 
> I think like in many other DMA drivers either you have separate function
> to get residue, which returns 0, or just not include this case.

You mean like in the omap-dma.c? ;-P

>>>> +static int bcm2835_dma_probe(struct platform_device *pdev)
>>>> +{
> 
>>>> +	uint32_t chans_available;
>>>
>>> Why uint32_t?
>>
>> Because it is a bit mask of fixed length that directly comes from the
>> firmware.
> 
> Like one already told you in your i2s patch, please, change that to
> corresponding u* value, namely u32.

I have no problem with changing that, but why?

