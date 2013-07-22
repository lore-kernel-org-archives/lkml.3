Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab3GVIBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:01:50 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.108]:45791 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756500Ab3GVIBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:01:48 -0400
X-Env-Sender: Hector.Palacios@digi.com
X-Msg-Ref: server-3.tower-201.messagelabs.com!1374480102!10083186!1
X-Originating-IP: [66.77.174.13]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <51ECE6E0.1030509@digi.com>
Date: Mon, 22 Jul 2013 10:01:36 +0200
From: Hector Palacios <hector.palacios@digi.com>
Organization: Digi International
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonathan Cameron <jic23@kernel.org>
CC: Marek Vasut <marex@denx.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>
Subject: Re: [PATCH v2 5/5] iio: mxs-lradc: add write_raw function to modify
 scale
References: <1374225208-28940-1-git-send-email-hector.palacios@digi.com> <1374225208-28940-6-git-send-email-hector.palacios@digi.com> <201307191639.01240.marex@denx.de> <51E95BEC.5080703@digi.com> <51E9A240.3000108@kernel.org>
In-Reply-To: <51E9A240.3000108@kernel.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On 07/19/2013 10:32 PM, Jonathan Cameron wrote:
>>>> @@ -323,6 +326,54 @@ static int mxs_lradc_read_raw(struct iio_dev *iio_dev,
>>>>        return ret;
>>>>    }
>>>>
>>>> +static int mxs_lradc_write_raw(struct iio_dev *iio_dev,
>>>> +                   const struct iio_chan_spec *chan,
>>>> +                   int val, int val2, long m)
>>>> +{
>>>> +    struct mxs_lradc *lradc = iio_priv(iio_dev);
>>>> +    int ret;
>>>> +
>>>> +    ret = mutex_trylock(&lradc->lock);
>>>> +    if (!ret)
>>>> +        return -EBUSY;
>>>> +
>>>> +    switch (m) {
>>>> +    case IIO_CHAN_INFO_SCALE:
>>>> +        ret = -EINVAL;
>>>> +        if (val == lradc->scale_avail[chan->channel][0][0] &&
>>>> +            val2 == lradc->scale_avail[chan->channel][0][1]) {
>>>> +            /* [0] -> divider by two disabled */
>>>
>>> This comment is confusing, you use [0] in different dimensions of the array. So
>>> is the stuff below.
>>>
>>> Still, how does this even work, can you show me and example how to set the
>>> divider from userland ? Sorry, I'm a bit confused with this 3D-business here,
>>> even if the comment in previous patch made it a bit clearer. Actually you can
>>> use some #define to specify if you're accessing div/2 or div/1 portion of the
>>> array to make it more readable.
>>>
>>> Like ... scale_avail[chan->channel][LRADC_DIV_BY_2][LRADC_DECIMAL_PART] ...
>>> would by nice.
>>
>> Agreed.
> Could even make the int + nano part a structure then you could have
> scale_avail[chan->channel][LRADC_DIV_BY_2].integer / .nano
>
> might not be worth the hassel though for the slight gain in readability.
>
> I'm happy either way.

I prefer the struct approach, it removes one dimension to the array and I find it cleaner.

Best regards,
--
Hector Palacios
