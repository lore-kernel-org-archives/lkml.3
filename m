Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188AbaETJ41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:56:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:37204 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbaETJ40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:56:26 -0400
Message-ID: <537B3244.3010808@ti.com>
Date: Tue, 20 May 2014 13:45:24 +0300
From: Grygorii Strashko <grygorii.strashko@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, <santosh.shilimkar@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>, Rob Herring <robh@kernel.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [RFC PATCH] of/irq: do irq resolution in platform_get_irq_byname()
References: <1400506259-18397-1-git-send-email-grygorii.strashko@ti.com>	<20140519125738.GB9466@ulmo> <20140520061700.ED542C41087@trevor.secretlab.ca>
In-Reply-To: <20140520061700.ED542C41087@trevor.secretlab.ca>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 05/20/2014 09:17 AM, Grant Likely wrote:
> On Mon, 19 May 2014 14:57:39 +0200, Thierry Reding <thierry.reding@gmail.com> wrote:
>> On Mon, May 19, 2014 at 04:30:59PM +0300, Grygorii Strashko wrote:
>> [...]
>>> diff --git a/drivers/of/irq.c b/drivers/of/irq.c
>> [...]
>>>   /**
>>> + * of_irq_get_byname - Decode a node's IRQ and return it as a Linux irq number
>>> + * @dev: pointer to device tree node
>>> + * @name: zero-based index of the irq
>>
>> This is a name, not an index.
>>
>>> + *
>>> + * Returns Linux irq number on success, or -EPROBE_DEFER if the irq domain
>>> + * is not yet created, or errorno in case of failure.
>>
>> s/errorno/error code/? Also EPROBE_DEFER is also an error code, so I'm
>> not sure if it's worth a special case in the description here.
>>
>>> + *
>>> + */
>>> +int of_irq_get_byname(struct device_node *dev, const char *name)
>>> +{
>>> +	const char *name_irq = NULL;
>>> +	int index = 0;
>>> +
>>> +	if (unlikely(!name))
>>> +		return -EINVAL;
>>> +
>>> +	while (!of_property_read_string_index(dev, "interrupt-names",
>>> +					      index, &name_irq))
>>> +		if (!strcmp(name, name_irq))
>>> +			return of_irq_get(dev, index);
>>
>> Isn't this missing an index++ somewhere? Otherwise it seems like this
>> would loop infinitely if there was no match on the first entry.
>
> Better yet, use of_property_match_string().

yep. Thanks. I've just come to the same idea. Patch re-sent.

Regards,
-grygorii
