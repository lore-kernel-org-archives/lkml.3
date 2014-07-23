Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755325AbaGWLQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:16:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40546 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaGWLQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:16:20 -0400
Message-ID: <53CF9933.8030908@gmail.com>
Date: Wed, 23 Jul 2014 16:44:59 +0530
From: Varka Bhadram <varkabhadram@gmail.com>
Organization: CDAC-HYD
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yao Yuan <yao.yuan@freescale.com>,
        =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>, "marex@denx.de" <marex@denx.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Subject: Re: [PATCH v5 1/2] i2c: add DMA support for freescale i2c driver
References: <1406103883-3572-1-git-send-email-yao.yuan@freescale.com>	<1406103883-3572-2-git-send-email-yao.yuan@freescale.com> <20140723114834.411f6bb4@ipc1.ka-ro> <b1778af62e7b42b39381fb2699b34eb1@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <b1778af62e7b42b39381fb2699b34eb1@BL2PR03MB338.namprd03.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 04:41 PM, Yao Yuan wrote:
> Hi,
>
> Thanks for your review.
>
> Lothar Waßmann wrote:
>> Yuan Yao wrote:
>>> Add dma support for i2c. This function depend on DMA driver.
>>> You can turn on it by write both the dmas and dma-name properties in dts node.
>>>
>>> Signed-off-by: Yuan Yao <yao.yuan@freescale.com>
>>> ---
>>>   drivers/i2c/busses/i2c-imx.c | 377
> [...]
>>> +
>>> +fail_rx:
>>> +	dma_release_channel(dma->chan_rx);
>>> +fail_tx:
>>> +	dma_release_channel(dma->chan_tx);
>>> +fail_al:
>>> +	devm_kfree(dev, dma);
>>>
>> No need for this one (that's the whole point of using devm_kzalloc())!
>>
> When DMA request failed, I2C will switch to PIO mode. So if the failed reason is just like DMA channel request failed. At this time the DMA should free by devm_kfree(). Is it?

If probe failed the memory will be freed automatically because
we are using devm_kzalloc()...

If we use devm_kzalloc() ,no need to free manually on fail...

-- 
Regards,
Varka Bhadram.

