Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784AbaKVMRV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 07:17:21 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:40433 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbaKVMRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 07:17:20 -0500
Message-ID: <54707ECA.7090800@kernel.org>
Date: Sat, 22 Nov 2014 12:17:14 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, Karol Wrona <k.wrona@samsung.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2 1/5] misc: sensorhub: Add sensorhub driver
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com> <1416593957-19788-2-git-send-email-k.wrona@samsung.com> <3489864.y2krC9T9rK@wuerfel>
In-Reply-To: <3489864.y2krC9T9rK@wuerfel>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/11/14 19:38, Arnd Bergmann wrote:
> On Friday 21 November 2014 19:19:13 Karol Wrona wrote:
>> Sensorhub  is MCU dedicated to collect data and manage several sensors.
>> Sensorhub is a spi device which provides a layer for IIO devices. It provides
>> some data parsing and common mechanism for sensorhub sensors.
>>
>> Adds common sensorhub library for sensorhub driver and iio drivers
>> which uses sensorhub MCU to communicate with sensors.
>>
>> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> ---
>>  drivers/misc/Kconfig                   |    1 +
>>  drivers/misc/Makefile                  |    1 +
>>  drivers/misc/sensorhub/Kconfig         |   13 +
>>  drivers/misc/sensorhub/Makefile        |    6 +
>>  drivers/misc/sensorhub/ssp.h           |  279 +++++++++++
>>  drivers/misc/sensorhub/ssp_dev.c       |  828 ++++++++++++++++++++++++++++++++
>>  drivers/misc/sensorhub/ssp_spi.c       |  653 +++++++++++++++++++++++++
>>  include/linux/iio/common/ssp_sensors.h |   79 +++
> 
> You seem to provide infrastructure for other drivers here, so I don't think
> drivers/misc is a good place. Have you considered making this a regular
> mfd driver? If that doesn't fit, is there possibly some place in the iio
> framework for this kind of driver?

Looks like an MFD to me.  If all the children lie within
IIO (so far they do I think - though the thermostat firmware implies
perhaps not!) then you could put it in drivers/iio/common
(as you have with the library code) - or perhaps, given these sensor
hubs are becoming pretty common a sub directory under mfd/ is the
best plan. Some of them are sure to offer functionality more general
that IIO sooner or later.




> 
> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

