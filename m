Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaKXLjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:39:17 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26106 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaKXLjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:39:15 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-f8-547318e13bdf
Message-id: <547318E0.8070407@samsung.com>
Date: Mon, 24 Nov 2014 12:39:12 +0100
From: Karol Wrona <k.wrona@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/5] misc: sensorhub: Add sensorhub driver
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com>
 <1416593957-19788-2-git-send-email-k.wrona@samsung.com>
 <3489864.y2krC9T9rK@wuerfel> <54707ECA.7090800@kernel.org>
In-reply-to: <54707ECA.7090800@kernel.org>
Content-type: text/plain; charset=windows-1252; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xa7oPJYpDDFqW8Fn8nXSM3WLjjPWs
	Fg+aVjFZnG16w25x/+tRRot5R96xWFzeNYfN4nQ3qwOHx+9fkxg9Nq3qZPO4c20Pm8e8k4Ee
	fVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlXHgwizWgjniFZ9PvmRpYFwk1MXIySEhYCKxft1n
	dghbTOLCvfVsXYxcHEICSxklnh+5xAaSEBL4xCixZZsGiM0roCXxsm02E4jNIqAqcfX7d7Aa
	NgF1ieYdi5lBbFGBCIkra+YwQtQLSvyYfI8FZKiIwARGidlrboFtYBZYwChxsnUl2GphAUeJ
	uY2LGCG27WKUuD9DBMTmBNr2a/4vsBpmAVuJBe/XsUDY8hKb17xlnsAoMAvJkllIymYhKVvA
	yLyKUTS1NLmgOCk910ivODG3uDQvXS85P3cTIyTwv+5gXHrM6hCjAAejEg/vj57CECHWxLLi
	ytxDjBIczEoivGJixSFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGDmZXvka37rwxNznrKb0lZb5
	LGXZKx5oTGDuz9Cd7zF/7ruomi+OStknpn+btfGxw9nHdq3KWm8vsq69UPdF316Wpb31cN1f
	psK/RYn9Kuc1Ght7o48nnZxTvtXa5b+rsQrHzgKbDqfShcU5719feLa3OfrOricHNJd4rFz3
	SHdi91dhuVU1rkosxRmJhlrMRcWJAM8PbaRaAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2014 01:17 PM, Jonathan Cameron wrote:
> On 21/11/14 19:38, Arnd Bergmann wrote:
>> On Friday 21 November 2014 19:19:13 Karol Wrona wrote:
>>> Sensorhub  is MCU dedicated to collect data and manage several sensors.
>>> Sensorhub is a spi device which provides a layer for IIO devices. It provides
>>> some data parsing and common mechanism for sensorhub sensors.
>>>
>>> Adds common sensorhub library for sensorhub driver and iio drivers
>>> which uses sensorhub MCU to communicate with sensors.
>>>
>>> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>   drivers/misc/Kconfig                   |    1 +
>>>   drivers/misc/Makefile                  |    1 +
>>>   drivers/misc/sensorhub/Kconfig         |   13 +
>>>   drivers/misc/sensorhub/Makefile        |    6 +
>>>   drivers/misc/sensorhub/ssp.h           |  279 +++++++++++
>>>   drivers/misc/sensorhub/ssp_dev.c       |  828 ++++++++++++++++++++++++++++++++
>>>   drivers/misc/sensorhub/ssp_spi.c       |  653 +++++++++++++++++++++++++
>>>   include/linux/iio/common/ssp_sensors.h |   79 +++
>>
>> You seem to provide infrastructure for other drivers here, so I don't think
>> drivers/misc is a good place. Have you considered making this a regular
>> mfd driver? If that doesn't fit, is there possibly some place in the iio
>> framework for this kind of driver?
>
> Looks like an MFD to me.  If all the children lie within
> IIO (so far they do I think - though the thermostat firmware implies
> perhaps not!) then you could put it in drivers/iio/common
> (as you have with the library code) - or perhaps, given these sensor
> hubs are becoming pretty common a sub directory under mfd/ is the
> best plan. Some of them are sure to offer functionality more general
> that IIO sooner or later.
It is possible that it can serve as input device sth else. So you are
right about MFD.

The structure of mfd directory is flat. I wonder what can be better:
just putting these sources inside mfd dir or to some new category inside mfd.
Generally sensorhub will not differ than others mfd devs but in the near future 
it can be that we end up with different (sensor)hubs or in my case with one core 
driver with several interfaces, mcu's modes - sth like ssp-i2c.c etc.
These drivers can grow in size as these devices will appear in different boards.

Also there is a question where firmware loader (stm32fwu) should be placed as it 
is a library?

>
>
>
>
>>
>> 	Arnd
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

