Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934087Ab3BNLGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:06:33 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:18120 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933839Ab3BNLGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:06:32 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 14 Feb 2013 03:05:29 -0800
Message-ID: <511CC520.8050104@nvidia.com>
Date: Thu, 14 Feb 2013 16:36:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] regmap: irq: do not write mask register if it is
 not supported
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com> <1360761290-15976-2-git-send-email-ldewangan@nvidia.com> <20130213142036.GJ5062@opensource.wolfsonmicro.com>
In-Reply-To: <20130213142036.GJ5062@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2013 07:50 PM, Mark Brown wrote:
> *
>
>>   	for (i = 0; i < d->chip->num_regs; i++) {
>> +		if (!d->chip->mask_base)
>> +			goto skip_mask_reg_update;
>> +
> Why is this inside the loop?
>
> I'd also expect us to return an error if a caller tries to enable or
> disable an interrupt, or possibly to give different ops to the IRQ
> subsystem, rather than just silently claim we did what we were asked.

I tried to use regmap-irq for the gpio submodule and it has two sets of 
register:
GPIOx_CNFG: bit[7:6] interrupt rising/falling.
GPIO_INT_STS where each bit shows the interrupt status whether it 
occured or not.
There is no mask register.

In regmap-irq_thread() we see the interrupt status and compare against 
mask enable buffer wther this is enabled or not and accordingly call the 
handler.

hence I am still require irq_mask()/irq_unmask() to reflect the mask 
with interrupt status and type for actually configuring the GPIOx_CNFG.

if I remove the mask_buf at all then how do we tell the int_sts register 
is corresponding to which gpio handler?

