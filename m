Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbbAJWLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 17:11:36 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59940 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbbAJWLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 17:11:35 -0500
Message-ID: <54B1A394.2090704@kernel.org>
Date: Sat, 10 Jan 2015 22:11:32 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, Karol Wrona <k.wrona@samsung.com>,
        linux-iio@vger.kernel.org, Hartmut Knaack <knaack.h@gmx.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>
Subject: Re: [RFC PATCH] iio: Add new operating mode for non triggered sw
 buffers
References: <1420655771-22465-1-git-send-email-k.wrona@samsung.com> <54AE6024.8050303@metafoo.de>
In-Reply-To: <54AE6024.8050303@metafoo.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/15 10:47, Lars-Peter Clausen wrote:
> On 01/07/2015 07:36 PM, Karol Wrona wrote:
>> There was a need for non triggered software buffer type.  It can be used when
>> triggered model does not fit and INDIO_BUFFER_HARDWARE causes confusion because
>> the data stream can be obtained not directly form hardware backend.
>>
>> Suggested-by: Jonathan Cameron <jic23@kernel.org>
>> Signed-off-by: Karol Wrona <k.wrona@samsung.com>
> 
> Looks good, thanks.
> 
> Reviewed-by: Lars-Peter Clausen <lars@metafoo.de>
> 
Thanks for doing this.

Applied to the togreg branch of iio.git - initially pushed out
as testing.

Jonathan
>> ---
>>   drivers/iio/industrialio-buffer.c |    2 ++
>>   include/linux/iio/iio.h           |    6 ++++--
>>   2 files changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
>> index f971f79..15e6de3 100644
>> --- a/drivers/iio/industrialio-buffer.c
>> +++ b/drivers/iio/industrialio-buffer.c
>> @@ -680,6 +680,8 @@ static int __iio_update_buffers(struct iio_dev *indio_dev,
>>           indio_dev->currentmode = INDIO_BUFFER_TRIGGERED;
>>       } else if (indio_dev->modes & INDIO_BUFFER_HARDWARE) {
>>           indio_dev->currentmode = INDIO_BUFFER_HARDWARE;
>> +    } else if (indio_dev->modes & INDIO_BUFFER_SOFTWARE) {
>> +        indio_dev->currentmode = INDIO_BUFFER_SOFTWARE;
>>       } else { /* Should never be reached */
>>           ret = -EINVAL;
>>           goto error_run_postdisable;
>> diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
>> index 3642ce7..55e63fd 100644
>> --- a/include/linux/iio/iio.h
>> +++ b/include/linux/iio/iio.h
>> @@ -284,10 +284,11 @@ static inline s64 iio_get_time_ns(void)
>>   /* Device operating modes */
>>   #define INDIO_DIRECT_MODE        0x01
>>   #define INDIO_BUFFER_TRIGGERED        0x02
>> +#define INDIO_BUFFER_SOFTWARE        0x04
>>   #define INDIO_BUFFER_HARDWARE        0x08
>>
>>   #define INDIO_ALL_BUFFER_MODES                    \
>> -    (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE)
>> +    (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE | INDIO_BUFFER_SOFTWARE)
>>
>>   #define INDIO_MAX_RAW_ELEMENTS        4
>>
>> @@ -591,7 +592,8 @@ void devm_iio_trigger_free(struct device *dev, struct iio_trigger *iio_trig);
>>   static inline bool iio_buffer_enabled(struct iio_dev *indio_dev)
>>   {
>>       return indio_dev->currentmode
>> -        & (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE);
>> +        & (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE |
>> +           INDIO_BUFFER_SOFTWARE);
>>   }
>>
>>   /**
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

