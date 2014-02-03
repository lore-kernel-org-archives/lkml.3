Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbaBCTMC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 14:12:02 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:48466 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaBCTJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 14:09:26 -0500
Message-ID: <52EFE980.7070607@kernel.org>
Date: Mon, 03 Feb 2014 19:09:52 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marek Vasut <marex@denx.de>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] iio: mxs-lradc: remove useless check
References: <1390071918-10622-1-git-send-email-alexandre.belloni@free-electrons.com> <201401182133.15839.marex@denx.de>
In-Reply-To: <201401182133.15839.marex@denx.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 18/01/14 20:33, Marek Vasut wrote:
> On Saturday, January 18, 2014 at 08:05:18 PM, Alexandre Belloni wrote:
>> Checking the channel number is useless since mxs_lradc_read_raw() is called
>> from a controlled environment and the driver is responsible for filing the
>> struct iio_chan_spec.
>>
>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>> ---
>>   drivers/staging/iio/adc/mxs-lradc.c | 4 ----
>>   1 file changed, 4 deletions(-)
>
> Changelog's missing ;-)
>
> Acked-by: Marek Vasut <marex@denx.de>
Applied to the togreg branch of iio.git - will be pushed out as testing for
the autobuilders to play with it.

Thanks.
>
>> diff --git a/drivers/staging/iio/adc/mxs-lradc.c
>> b/drivers/staging/iio/adc/mxs-lradc.c index 7fc66a6a6e36..d304156ca2f7
>> 100644
>> --- a/drivers/staging/iio/adc/mxs-lradc.c
>> +++ b/drivers/staging/iio/adc/mxs-lradc.c
>> @@ -897,10 +897,6 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>>   {
>>   	struct mxs_lradc *lradc = iio_priv(iio_dev);
>>
>> -	/* Check for invalid channel */
>> -	if (chan->channel > LRADC_MAX_TOTAL_CHANS)
>> -		return -EINVAL;
>> -
>>   	switch (m) {
>>   	case IIO_CHAN_INFO_RAW:
>>   		if (chan->type == IIO_TEMP)
>
> Best regards,
> Marek Vasut
>
