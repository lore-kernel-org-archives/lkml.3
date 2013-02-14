Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788Ab3BNLCP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 06:02:15 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:17844 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab3BNLCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 06:02:14 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Thu, 14 Feb 2013 03:01:11 -0800
Message-ID: <511CC41E.7040608@nvidia.com>
Date: Thu, 14 Feb 2013 16:31:50 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regmap: irq: Add support for interrupt type
References: <1360761290-15976-1-git-send-email-ldewangan@nvidia.com> <20130213135440.GI5062@opensource.wolfsonmicro.com>
In-Reply-To: <20130213135440.GI5062@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 February 2013 07:24 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Feb 13, 2013 at 06:44:49PM +0530, Laxman Dewangan wrote:
>> Most of the MFD module have the GPIO and gpio interrupt is
>> enabled/disabled through the rising/falling edge type. There
>> is no specific mask enable/disable registers for GPIO submodules.
>>
>> Extend the regmap irq to support the irq_set_type() so that
>> gpio submodule of MFD devices can use the regmap-irq framework
>> for their interrupt registration.
> This commit message needs to be rewritten for comprehensibility, MFD has
> nothing to do with this - it's something to do with your particular
> hardware that you're trying to support.  Describe the hardware feature,
> not the subsystem your hardware happens to be used in.

Fine, I will try to write better.

>
>> +	switch (type) {
>> +	case IRQ_TYPE_EDGE_FALLING:
>> +		d->type_buf[reg] |= irq_data->type_falling_mask;
>> +		break;
>> +
>> +	case IRQ_TYPE_EDGE_RISING:
>> +		d->type_buf[reg] |= irq_data->type_rising_mask;
>> +		break;
>> +
>> +	case IRQ_TYPE_EDGE_BOTH:
>> +		d->type_buf[reg] |= (irq_data->type_falling_mask |
>> +					irq_data->type_rising_mask);
>> +		break;
> This should handle the case where an output type is not supported, for
> example if the device only supports falling edge.  It'd also seem
> sensible to have an explicit value to set for each trigger type rather
> than reyling on the device using separate bits for everything - you
> might see an encoding like 0 for falling, 1 for rising, 2 for both and 3
> for level for example.

is this mean we should have variable like
.supported_iflags which capture what it is supported or not.
And then irq_type_val[MAX_REGMAP_IRQ_TYPE] as array and define the 
REGMAP_IRQ_TYPE_[FALLING/RISING/BOTH] as index and client can fill this 
info as per the hardware or

Or we should have separate variable for each type like:
int irq_type_rising_val;
int irq_type_faling_val;
int ire_type_both_val;

along with
int irq_type_supported;
int irq_type_mask_val;






