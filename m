Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab3HMU00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 16:26:26 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:59403 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758856Ab3HMU0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 16:26:25 -0400
Message-ID: <520AA47E.7060202@kernel.org>
Date: Tue, 13 Aug 2013 22:26:22 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Hector Palacios <hector.palacios@digi.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "marex@denx.de" <marex@denx.de>
Subject: Re: [PATCH v3 4/5] iio: mxs-lradc: add scale_available file to channels
References: <1374501843-19651-1-git-send-email-hector.palacios@digi.com> <1374501843-19651-5-git-send-email-hector.palacios@digi.com> <51EE4300.7070802@metafoo.de> <51EE8445.6070603@digi.com> <51F276D8.9090906@free-electrons.com> <d838f30e-30ca-49ca-a9f3-ebf4e523c7eb@email.android.com> <5201FC55.5080304@free-electrons.com>
In-Reply-To: <5201FC55.5080304@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 08:50, Alexandre Belloni wrote:
> Hi Jonathan, Lars
> 
> I would really like to see that included in 3.12. While I agree there is
> room for improvement, I don't think there are any comments that need an
> immediate action before inclusion apart from the decision that has to be
> taken for the device tree.
> 
> Can you confirm whether you'll take this series as is ?

I've just raised the device tree issue again.  I'm happy with everything
else in the series, but want some more expert input on that small element.

Sorry this has taken so long and hopefully we'll get it cleared up over the
next couple of days.

Jonathan
> 
> Regards,
> 
> On 26/07/2013 18:13, Jonathan Cameron wrote:
>>
>> Alexandre Belloni <alexandre.belloni@free-electrons.com> wrote:
>>> On 23/07/2013 15:25, Hector Palacios wrote:
>>>> Dear Lars,
>>>>
>>>> On 07/23/2013 10:46 AM, Lars-Peter Clausen wrote:
>>>>> On 07/22/2013 04:04 PM, Hector Palacios wrote:
>>>>> [...]
>>>>>> +static ssize_t mxs_lradc_show_scale_available_ch(struct device
>>> *dev,
>>>>>> +        struct device_attribute *attr,
>>>>>> +        char *buf,
>>>>>> +        int ch)
>>>>>> +{
>>>>>> +    struct iio_dev *iio = dev_to_iio_dev(dev);
>>>>>> +    struct mxs_lradc *lradc = iio_priv(iio);
>>>>>> +    int i, len = 0;
>>>>>> +
>>>>>> +    for (i = 0; i < ARRAY_SIZE(lradc->scale_avail[ch]); i++)
>>>>>> +        len += sprintf(buf + len, "%d.%09u ",
>>>>>> +                   lradc->scale_avail[ch][i].integer,
>>>>>> +                   lradc->scale_avail[ch][i].nano);
>>>>>> +
>>>>>> +    len += sprintf(buf + len, "\n");
>>>>>> +
>>>>>> +    return len;
>>>>>> +}
>>>>>> +
>>>>>> +static ssize_t mxs_lradc_show_scale_available(struct device *dev,
>>>>>> +        struct device_attribute *attr,
>>>>>> +        char *buf)
>>>>>> +{
>>>>>> +    struct iio_dev_attr *iio_attr = to_iio_dev_attr(attr);
>>>>>> +
>>>>>> +    return mxs_lradc_show_scale_available_ch(dev, attr, buf,
>>>>>> +                         iio_attr->address);
>>>>>> +}
>>>>>> +
>>>>>> +#define SHOW_SCALE_AVAILABLE_ATTR(ch)                    \
>>>>>> +static IIO_DEVICE_ATTR(in_voltage##ch##_scale_available, S_IRUGO, 
>>>  \
>>>>>> +               mxs_lradc_show_scale_available, NULL, ch)
>>>>>> +
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(0);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(1);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(2);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(3);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(4);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(5);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(6);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(7);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(8);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(9);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(10);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(11);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(12);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(13);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(14);
>>>>>> +SHOW_SCALE_AVAILABLE_ATTR(15);
>>>>>> +
>>>>>> +static struct attribute *mxs_lradc_attributes[] = {
>>>>>> +    &iio_dev_attr_in_voltage0_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage1_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage2_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage3_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage4_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage5_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage6_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage7_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage8_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage9_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage10_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage11_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage12_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage13_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage14_scale_available.dev_attr.attr,
>>>>>> +    &iio_dev_attr_in_voltage15_scale_available.dev_attr.attr,
>>>>>> +    NULL
>>>>>> +};
>>>>> This should really be using the iio_chan_spec_ext_info
>>>>> infrastructure. Bonus
>>>>> points for factoring out the common code used to calculate and
>>>>> display the
>>>>> scales.
>>>> I perfectly understand. Sadly, I don't currently have the time and
>>>> expertise to try to work this out the proper way. It already took
>>> much
>>>> longer than expected to have this driver toggle a divider flag.
>>>>
>>>> I'd appreciate if anyone wishes to complete this job.
>>>> @Alexander, please feel free to submit your other temp patch without
>>>> waiting for this one.
>>>>
>>> Maybe, we can get the patch set as is and do further clean up later.
>>> Anyway, that driver is still in staging, right ?
>>>
>>> As said, I'm willing to propose something for the scale calculation.
>> My thoughts exactly. Long term plans include generic handling of available attributes for the whole of IIO.
>>
>> It will take me a little while to catch up my backlog though!
>>
>> Jonathan
>>
>>
>>
> 
> 
