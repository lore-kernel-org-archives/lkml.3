Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab3JEJl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 05:41:57 -0400
Received: from smtp-out-063.synserver.de ([212.40.185.63]:1060 "EHLO
	smtp-out-062.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447Ab3JEJl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 05:41:56 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 8292
Message-ID: <524FDF54.5000207@metafoo.de>
Date: Sat, 05 Oct 2013 11:43:48 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130922 Icedove/17.0.9
MIME-Version: 1.0
To: leroy christophe <christophe.leroy@c-s.fr>
CC: Jonathan Cameron <jic23@cam.ac.uk>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, patrick.vasseur@c-s.fr
Subject: Re: [PATCH] IIO AD7923 iio_consumer support
References: <201310050821.r958LBqP012933@localhost.localdomain> <524FD0AB.7020209@metafoo.de> <524FD976.9060708@c-s.fr> <524FDD4F.7080406@metafoo.de> <524FDE35.3050008@c-s.fr>
In-Reply-To: <524FDE35.3050008@c-s.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2013 11:39 AM, leroy christophe wrote:
> 
> Le 05/10/2013 11:35, Lars-Peter Clausen a écrit :
>> On 10/05/2013 11:18 AM, leroy christophe wrote:
>>> Le 05/10/2013 10:41, Lars-Peter Clausen a écrit :
>>>> On 10/05/2013 10:21 AM, Christophe Leroy wrote:
>>>>> +        .consumer_channel = "channel_0",
>>>>> +        .adc_channel_label = "0",
>>>>> +    },
>>>>> +    {
>>>>> +        .consumer_dev_name = AD7923_NAME,
>>>>> +        .consumer_channel = "channel_1",
>>>>> +        .adc_channel_label = "1",
>>>>> +    },
>>>>> +    {
>>>>> +        .consumer_dev_name = AD7923_NAME,
>>>>> +        .consumer_channel = "channel_2",
>>>>> +        .adc_channel_label = "2",
>>>>> +    },
>>>>> +    {
>>>>> +        .consumer_dev_name = AD7923_NAME,
>>>>> +        .consumer_channel = "channel_3",
>>>>> +        .adc_channel_label = "3",
>>>>> +    },
>>>>> +    { }
>>>>> +};
>>>> This is a mapping between channel names of the provider between the channel
>>>> names of the consumer. So it is specific to a certain combination of
>>>> consumer and provider and usually depend on how things are physically wired
>>>> on your board. As such there can be no generic mapping and this needs to go
>>>> into your machine/board driver. The mapping is usually passed to the IIO
>>>> driver via its platform data.
>>>>
>>>> So e.g. imagine you have a provider like this driver and you have a
>>>> consumer
>>>> that has a "voltage" channel. And on your board channel 3 of the ADC is
>>>> what
>>>> you want to route to that consumer. Then your mapping would look like this:
>>>>
>>>> {
>>>>      .consumer_dev_name = "your_consumer_device.1",
>>>>      .consumer_channel = "voltage",
>>>>      .adc_channel_label = "AIN3",
>>>> }
>>>>
>>>> And in your consumer driver you'd do:
>>>>
>>>> channel = iio_channel_get(dev, "voltage");
>>>>
>>>>
>>> Thanks for the explanation.
>>>
>>> Can the mapping be retrieved via of_platform ?
>>>
>>> Indeed, the only exemple I found was in the lp8788_adc driver, which
>>> includes iio/machine.h and declares a default mapping, but it is based on
>>> platform_data, not of_platform.
>>>
>> If you are using device tree you can specify the mapping inside the
>> devicetree. Have a look at
>> Documentation/devicetree/bindings/iio/iio-bindings.txt
>>
>>
> Yes, I saw that. Is there anything that shall be done in the driver to
> support it, or is it automatic ?

It should work out of the box. Just make sure to set the #io-channel-cells
property for the ADC device node in the devicetree.

- Lars

