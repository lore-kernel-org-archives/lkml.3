Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbbANU0U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 15:26:20 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:37734 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbbANU0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 15:26:18 -0500
Message-ID: <54B55700.4010101@kernel.org>
Date: Tue, 13 Jan 2015 17:33:52 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Karol Wrona <k.wrona@samsung.com>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 3/5] iio: common: ssp_sensors: Add sensorhub iio commons
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com> <1417809290-9662-4-git-send-email-k.wrona@samsung.com> <54831539.1020705@kernel.org> <54B541DF.9000507@samsung.com>
In-Reply-To: <54B541DF.9000507@samsung.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/01/15 16:03, Karol Wrona wrote:
> [...]
>>> +EXPORT_SYMBOL(ssp_common_setup_buffer);
>>> diff --git a/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
>>> new file mode 100644
>>> index 0000000..4b79be0
>>> --- /dev/null
>>> +++ b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
>>> @@ -0,0 +1,56 @@
>>> +#ifndef __SSP_IIO_SENSOR_H__
>>> +#define __SSP_IIO_SENSOR_H__
>>> +
>>> +#define SSP_CHANNEL_AG(_type, _mod, _index) \
>>> +{ \
>>> +		.type = _type,\
>>> +		.modified = 1,\
>>> +		.channel2 = _mod,\
>>> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SAMP_FREQ),\
>>> +		.scan_index = _index,\
>>> +		.scan_type = {\
>>> +			.sign = 's',\
>>> +			.realbits = 16,\
>> Seems a little unlikely unless the device is padding appropriately. Even
>> then it is generally a bad idea to claim more accuracy than is real. Very
>> few accelerometers etc are 16 bit.  Please confirm.
>>> +			.storagebits = 16,\
> Physically it is mpu6500:
> http://www.invensense.com/mems/gyro/documents/PS-MPU-6500A-01.pdf.
> It has 16-bit ADC.  Other thing linux device does not get these data directly
> but after some processing by sensorhub and in this case it always will be 16-bit
> sample.
Fair enough, it'll be somewhat noisy but there might be some value in those low
bits ;)
> 
> 
> 
>>> +			.shift = 0,\
>>> +			.endianness = IIO_LE,\
>>> +		},\
>>> +}
>>> +
>>> +#define SSP_DIVISOR	1000000ULL
>>> +#define SSP_MS_PER_S	1000
> [...]
> 

