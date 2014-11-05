Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaKEPcP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 10:32:15 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43374 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbaKEPcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 10:32:13 -0500
Message-ID: <545A42FA.7090501@kernel.org>
Date: Wed, 05 Nov 2014 15:32:10 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v4 2/2] iio: vadc: Qualcomm SPMI PMIC voltage ADC driver
References: <1415028270-25860-1-git-send-email-iivanov@mm-sol.com>		 <1415028270-25860-3-git-send-email-iivanov@mm-sol.com>		 <545A218F.5060301@kernel.org> <1415195855.3660.4.camel@mm-sol.com>	 <545A2EDB.5040801@kernel.org> <1415199681.3660.8.camel@mm-sol.com>
In-Reply-To: <1415199681.3660.8.camel@mm-sol.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/14 15:01, Ivan T. Ivanov wrote:
> 
> On Wed, 2014-11-05 at 14:06 +0000, Jonathan Cameron wrote:
>> On 05/11/14 13:57, Ivan T. Ivanov wrote:
>>> On Wed, 2014-11-05 at 13:09 +0000, Jonathan Cameron wrote:
>>>> On 03/11/14 15:24, Ivan T. Ivanov wrote:
>>>>> From: Stanimir Varbanov <svarbanov@mm-sol.com>
>>>>>
>>>>> The voltage ADC is peripheral of Qualcomm SPMI PMIC chips. It has
>>>>> 15 bits resolution and register space inside PMIC accessible across
>>>>> SPMI bus.
>>>>>
>>>>> The vadc driver registers itself through IIO interface.
>>>>>
>>>>> Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
>>>>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
>>>> Hi Ivan,
>>>>
>>>> Couple of utterly tiny bits inline.  The biggest one is that
>>>> you store some info about the calibration that you never actually
>>>> use... Left over from some debugging perhaps?
>>>>
>>>> Jonathan
>>>
>>> <snip>
>>>
>>>>> +
>>>>> +/*
>>>>> + * VADC_CALIB_ABSOLUTE: uses the 625mV and 1.25V as reference channels.
>>>>> + * VADC_CALIB_RATIOMETRIC: uses the reference voltage (1.8V) and GND for
>>>>> + * calibration.
>>>>> + */
>>>>> +enum vadc_calibration {
>>>>> +       VADC_CALIB_ABSOLUTE = 0,
>>>>> +       VADC_CALIB_RATIOMETRIC
>>>>> +};
>>>>> +
>>>>> +/**
>>>>> + * struct vadc_linear_graph - Represent ADC characteristics.
>>>>> + * @dy: numerator slope to calculate the gain.
>>>> As dy is always equal to vref-gnd you could drop it and use those
>>>> directly...
>>>>
>>>> Conversly you store vref or grnd and never use them...
>>>
>>> I am not sure I am following you. Please take a look in
>>> vadc_measure_ref_points() and vadc_calibrate().
>> Good point on grnd, but vref is set but never read anywhere that I can find..
>>
> 
> Right. At this point it is not used. Driver right now provide basic per
> channel voltage measurements. The plan is to add temperature compensation for the
> measurements and additional scaling functions which are specific per channel.
> 
> I could drop this field from initial driver version if you like.
Probably best as otherwise some compiler in a clever mood will give
a warning and I'll get an irritating patch to remove it!

J
> 
> Regards,
> Ivan
> 
