Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbbAMQDu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 11:03:50 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:43906 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531AbbAMQDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 11:03:48 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-8b-54b541e177bc
Message-id: <54B541DF.9000507@samsung.com>
Date: Tue, 13 Jan 2015 17:03:43 +0100
From: Karol Wrona <k.wrona@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.2.0
MIME-version: 1.0
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [PATCH v3 3/5] iio: common: ssp_sensors: Add sensorhub iio commons
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
 <1417809290-9662-4-git-send-email-k.wrona@samsung.com>
 <54831539.1020705@kernel.org>
In-reply-to: <54831539.1020705@kernel.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xK7oPHbeGGFx+I2ixccZ6VosHTauY
	LHb9f8NscbbpDbvFvCPvWCwu75rDZrFn3RYmB3aPnbPusnt8+BjnsWlVJ5tH35ZVjB6fN8kF
	sEZx2aSk5mSWpRbp2yVwZTw75FZwkKtia9NatgbG4xxdjJwcEgImEr0dP1ghbDGJC/fWs4HY
	QgJLGSWOv1HuYuQCsj8xSnz+tJsRJMEroCVx5uxyoCIODhYBVYm5q+RBwmwC6hLNOxYzg9ii
	AhESV9bMgSoXlPgx+R4LyBwRgRZGiRc/d7GCOMwC7YwS9zedZwepEhbwl+ju+MQOsW02o8S0
	L19YQBKcQNuWHz7EBLKNWUBP4v5FLZAws4C8xOY1b5knMArMQrJkFkLVLCRVCxiZVzGKppYm
	FxQnpeca6hUn5haX5qXrJefnbmKEBPiXHYyLj1kdYhTgYFTi4d2RvSVEiDWxrLgy9xCjBAez
	kgjvI/OtIUK8KYmVValF+fFFpTmpxYcYmTg4pRoYxQXS16yQOOvk+ekA88S3L6VnVJwzPrTg
	97w1tpJxumq1534H7A/QcXR+ssN9ximpRY5yX6TfJ+dEf71zoeq+SyzL/WT2Sd+NfH4fOHjL
	Pry4nkf9tOH0NSXqLVmVbnk3vQ2u5UxPmMj/5ADXxdeT+TlPndlvdUUnOktqacyissnHnKu3
	nG3KUmIpzkg01GIuKk4EAEW+wWlOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[...]
>> +EXPORT_SYMBOL(ssp_common_setup_buffer);
>> diff --git a/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
>> new file mode 100644
>> index 0000000..4b79be0
>> --- /dev/null
>> +++ b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
>> @@ -0,0 +1,56 @@
>> +#ifndef __SSP_IIO_SENSOR_H__
>> +#define __SSP_IIO_SENSOR_H__
>> +
>> +#define SSP_CHANNEL_AG(_type, _mod, _index) \
>> +{ \
>> +		.type = _type,\
>> +		.modified = 1,\
>> +		.channel2 = _mod,\
>> +		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SAMP_FREQ),\
>> +		.scan_index = _index,\
>> +		.scan_type = {\
>> +			.sign = 's',\
>> +			.realbits = 16,\
> Seems a little unlikely unless the device is padding appropriately. Even
> then it is generally a bad idea to claim more accuracy than is real. Very
> few accelerometers etc are 16 bit.  Please confirm.
>> +			.storagebits = 16,\
Physically it is mpu6500:
http://www.invensense.com/mems/gyro/documents/PS-MPU-6500A-01.pdf.
It has 16-bit ADC.  Other thing linux device does not get these data directly
but after some processing by sensorhub and in this case it always will be 16-bit
sample.



>> +			.shift = 0,\
>> +			.endianness = IIO_LE,\
>> +		},\
>> +}
>> +
>> +#define SSP_DIVISOR	1000000ULL
>> +#define SSP_MS_PER_S	1000
[...]
