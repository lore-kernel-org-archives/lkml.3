Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab3IKRaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 13:30:05 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:56744 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3IKRaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 13:30:02 -0400
Message-ID: <5230B6B1.3050902@kernel.org>
Date: Wed, 11 Sep 2013 19:30:09 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, arnd@arndb.de,
        linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 27/38] iio: pressure-core: st: Give some indication if
 device probing was successful
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-28-git-send-email-lee.jones@linaro.org> <43055af7-991f-4122-b308-a3dcddbbb72a@email.android.com> <20130911071053.GD11227@lee--X1> <52301963.5030006@metafoo.de>
In-Reply-To: <52301963.5030006@metafoo.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 08:18, Lars-Peter Clausen wrote:
> On 09/11/2013 09:10 AM, Lee Jones wrote:
>> On Tue, 10 Sep 2013, Jonathan Cameron wrote:
>>> Lee Jones <lee.jones@linaro.org> wrote:
>>>> At the moment the driver is silent in some error cases and if
>>>> successful.
>>>> Prior to this patch there was no clear way to know if the driver
>>>> succeeded
>>>> or not without looking deep into sysfs.
>>>>
>>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>>> ---
>>>> drivers/iio/pressure/st_pressure_core.c | 3 +++
>>>> 1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/drivers/iio/pressure/st_pressure_core.c
>>>> b/drivers/iio/pressure/st_pressure_core.c
>>>> index 6ffd949..34b3fb1 100644
>>>> --- a/drivers/iio/pressure/st_pressure_core.c
>>>> +++ b/drivers/iio/pressure/st_pressure_core.c
>>>> @@ -280,6 +280,9 @@ int st_press_common_probe(struct iio_dev
>>>> *indio_dev,
>>>>     if (err && irq > 0)
>>>>         goto st_press_device_register_error;
>>>>
>>>> +    if (!err)
>>>> +        dev_info(&indio_dev->dev, "Successfully registered\n");
>>>> +
>>> Not keen. That to my mind is pointless noise.
>>
>> I think it needs to be somewhere. IIO provides no indication whether
>> these chips are probed/registered/whathaveyou, or even if the
>> subsystem is in use.
>>
>> One line per hardware component is not noise, IMO it's indicative of
>> key functionality which is now available:
>>
>> Bootlog:
>> <snip>
>> iio iio: lsm303dlh_accel: Successfully registered
>> iio iio: l3g4200d_gyro: Successfully registered
>> iio iio: lps001wp_press: Successfully registered
>> iio iio: lsm303dlhc_magn: Successfully registered
>> <snip>
>>
>>> If this made sense then it would be in the driver core not here.
>>
>> Also fine. Just anything but silence/NULL reporting.
> 
> Silence means everything is good, a message means there is an error. If every device that gets probed would spit out a
> message the log would be scrolling forever and you wouldn't be able to see the error messages.

Exactly.  If you really think this is worthwhile, then propose it is added to the relevant
place in drivers/base/ (possibly bus.c)  I've just been lax in persuading people not
to put it in existing drivers rather than the other way around.

> 
> - Lars
> 
