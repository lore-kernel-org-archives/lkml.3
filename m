Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935548AbaH0RlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 13:41:24 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:36444 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbaH0RlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 13:41:23 -0400
Message-ID: <53FE183D.4020403@kernel.org>
Date: Wed, 27 Aug 2014 18:41:17 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Adam Thomson <Adam.Thomson@diasemi.com>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: "knaack.h@gmx.de" <knaack.h@gmx.de>, "lars@metafoo.de" <lars@metafoo.de>,
        "pmeerw@pmeerw.net" <pmeerw@pmeerw.net>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] iio: core: Propagate error codes from OF layer to client
 drivers
References: <1408971437-10751-1-git-send-email-iivanov@mm-sol.com>		 <53FB5FF7.8020504@kernel.org> <20140825165430.GB14614@roeck-us.net>	 <1409039490.5256.75.camel@iivanov-dev> <53FC8AB3.2080603@roeck-us.net> <1409060908.5256.83.camel@iivanov-dev> <2E89032DDAA8B9408CB92943514A0337AB5113C5@SW-EX-MBX01.diasemi.com>
In-Reply-To: <2E89032DDAA8B9408CB92943514A0337AB5113C5@SW-EX-MBX01.diasemi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/08/14 16:59, Adam Thomson wrote:
> On August 26, 2014 15:36, Adam Thomson wrote:
> 
>> On August 26, 2014 14:48, Ivan T. Ivanov wrote:
>>
>>> On Tue, 2014-08-26 at 06:25 -0700, Guenter Roeck wrote:
>>>> On 08/26/2014 12:51 AM, Ivan T. Ivanov wrote:
>>>>> Hi,
>>>>>
>>>> [ ... ]
>>>>>
>>>>> Another, less intrusive, solution will be if we revert last patch and explicitly
>>>>> check for EPROBE_DEFER on of_ by_name() return. How this sounds?
>>>>>
>>>> How is that different to the just accepted patch ?
>>>
>>> You mean this one[1]. I have prepared fix last Friday and forget to
>>> check again before posting it, sorry. Please ignore my patch.
>>>
>>> Thanks,
>>> Ivan
>>>
>>> [1] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
>>>
>>
>> Apologies on my part for fixing one problem and introducing another. Didn't see
>> that in my testing, and missed that potential return value when examining the
>> code. At the time It looked like the parent function would only expect NULL
>> pointers for failure, especially given the non CONFIG_OF definitions of the
>> functions. Should've delved further. :(
> 
> On August 26, 2014 15:36, Adam Thomson wrote:
> 
>> On August 26, 2014 14:48, Ivan T. Ivanov wrote:
>>
>>> On Tue, 2014-08-26 at 06:25 -0700, Guenter Roeck wrote:
>>>> On 08/26/2014 12:51 AM, Ivan T. Ivanov wrote:
>>>>> Hi,
>>>>>
>>>> [ ... ]
>>>>>
>>>>> Another, less intrusive, solution will be if we revert last patch and explicitly
>>>>> check for EPROBE_DEFER on of_ by_name() return. How this sounds?
>>>>>
>>>> How is that different to the just accepted patch ?
>>>
>>> You mean this one[1]. I have prepared fix last Friday and forget to
>>> check again before posting it, sorry. Please ignore my patch.
>>>
>>> Thanks,
>>> Ivan
>>>
>>> [1] iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_name
>>>
>>
>> Apologies on my part for fixing one problem and introducing another. Didn't see
>> that in my testing, and missed that potential return value when examining the
>> code. At the time It looked like the parent function would only expect NULL
>> pointers for failure, especially given the non CONFIG_OF definitions of the
>> functions. Should've delved further. :(
> 
> In testing patch code for one of our devices, I've verified what Guenter
> mentioned previously in this thread, in that iio_channel_get_sys() doesn't
> return -EPROBE_DEFER. This means that drivers using the default map approach of
> accessing IIO channels will fail to instantiate as they do not know they
> need to defer their probe (have seen this with my driver too).
> 
> Haven't looked in detail yet as to how, but I guess this is something that will
> also need to be addressed.
Yes, that stuff (I think) predates deferred probing and no one has gotten around
to bringing it up to date as yet.

All contributions welcome!

J

> Legal Disclaimer: This e-mail communication (and any attachment/s) is confidential and contains proprietary information, some or all of which may be legally privileged. It is intended solely for the use of the individual or entity to which it is addressed. Access to this email by anyone else is unauthorized. If you are not the intended recipient, any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on it, is prohibited and may be unlawful.
> 
> Please consider the environment before printing this e-mail
> 
> 
