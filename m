Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab3JEJSu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 05:18:50 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:47259 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab3JEJSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 05:18:49 -0400
Message-ID: <524FD976.9060708@c-s.fr>
Date: Sat, 05 Oct 2013 11:18:46 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO AD7923 iio_consumer support
References: <201310050821.r958LBqP012933@localhost.localdomain> <524FD0AB.7020209@metafoo.de>
In-Reply-To: <524FD0AB.7020209@metafoo.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 05/10/2013 10:41, Lars-Peter Clausen a écrit :
> On 10/05/2013 10:21 AM, Christophe Leroy wrote:
>> +		.consumer_channel = "channel_0",
>> +		.adc_channel_label = "0",
>> +	},
>> +	{
>> +		.consumer_dev_name = AD7923_NAME,
>> +		.consumer_channel = "channel_1",
>> +		.adc_channel_label = "1",
>> +	},
>> +	{
>> +		.consumer_dev_name = AD7923_NAME,
>> +		.consumer_channel = "channel_2",
>> +		.adc_channel_label = "2",
>> +	},
>> +	{
>> +		.consumer_dev_name = AD7923_NAME,
>> +		.consumer_channel = "channel_3",
>> +		.adc_channel_label = "3",
>> +	},
>> +	{ }
>> +};
> This is a mapping between channel names of the provider between the channel
> names of the consumer. So it is specific to a certain combination of
> consumer and provider and usually depend on how things are physically wired
> on your board. As such there can be no generic mapping and this needs to go
> into your machine/board driver. The mapping is usually passed to the IIO
> driver via its platform data.
>
> So e.g. imagine you have a provider like this driver and you have a consumer
> that has a "voltage" channel. And on your board channel 3 of the ADC is what
> you want to route to that consumer. Then your mapping would look like this:
>
> {
> 	.consumer_dev_name = "your_consumer_device.1",
> 	.consumer_channel = "voltage",
> 	.adc_channel_label = "AIN3",
> }
>
> And in your consumer driver you'd do:
>
> channel = iio_channel_get(dev, "voltage");
>
>
Thanks for the explanation.

Can the mapping be retrieved via of_platform ?

Indeed, the only exemple I found was in the lp8788_adc driver, which 
includes iio/machine.h and declares a default mapping, but it is based 
on platform_data, not of_platform.

Christophe
