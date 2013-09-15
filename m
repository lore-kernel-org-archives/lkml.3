Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757120Ab3IOPwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 11:52:37 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:53227 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab3IOPwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 11:52:36 -0400
Message-ID: <5235E5E1.3040808@kernel.org>
Date: Sun, 15 Sep 2013 17:52:49 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Matthias Kaehlcke <matthias.list@kaehlcke.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] iio: ti_am335x_adc: Take touchscreen channels into
 account for conversion timeout
References: <f1830a7d0debce351966d2f3232158313d87dcc0.1378846446.git.matthias@kaehlcke.net> <20130910210228.GC30481@raspi> <5235DD9A.5040700@kernel.org>
In-Reply-To: <5235DD9A.5040700@kernel.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/13 17:17, Jonathan Cameron wrote:
> On 09/10/13 22:02, Matthias Kaehlcke wrote:
>> The calculation of the old conversion timeout value was based on the number of
>> channels used by this driver. This doesn't take into account that other channels
>> can be used by the touchscreen driver. Adjust the timeout value to the maximum
>> if the touchscreen driver is enabled
>>
>> Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>
> Hmm... This is a bit of an uggly solution.  Can we do anything neater via some
> callbacks in the underlying mfd?  Rachna, any thoughts on this?
Ah, Rachna's email is dead.  So, anyone else care to comment?
> 
> If not I'm happy to take this as fixing a real problem and we can tidy up later
> if needed.
> 
> Jonathan
>> ---
>>  drivers/iio/adc/ti_am335x_adc.c | 4 ++++
>>  1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
>> index 3ceac3e..898fc78 100644
>> --- a/drivers/iio/adc/ti_am335x_adc.c
>> +++ b/drivers/iio/adc/ti_am335x_adc.c
>> @@ -146,7 +146,11 @@ static int tiadc_read_raw(struct iio_dev *indio_dev,
>>  	bool found = false;
>>  	u32 step_en;
>>  	unsigned long timeout = jiffies + usecs_to_jiffies
>> +#ifdef CONFIG_TOUCHSCREEN_TI_AM335X_TSC
>> +				(IDLE_TIMEOUT * TOTAL_CHANNELS);
>> +#else
>>  				(IDLE_TIMEOUT * adc_dev->channels);
>> +#endif
>>  	step_en = get_adc_step_mask(adc_dev);
>>  	am335x_tsc_se_set(adc_dev->mfd_tscadc, step_en);
>>  
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
