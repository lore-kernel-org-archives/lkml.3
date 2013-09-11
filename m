Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab3IKHSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:18:30 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:58598 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751726Ab3IKHS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:18:28 -0400
Message-ID: <52301963.5030006@metafoo.de>
Date: Wed, 11 Sep 2013 09:18:59 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Jonathan Cameron <jic23@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, arnd@arndb.de,
        linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 27/38] iio: pressure-core: st: Give some indication if
 device probing was successful
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org> <1378817379-8238-28-git-send-email-lee.jones@linaro.org> <43055af7-991f-4122-b308-a3dcddbbb72a@email.android.com> <20130911071053.GD11227@lee--X1>
In-Reply-To: <20130911071053.GD11227@lee--X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 09:10 AM, Lee Jones wrote:
> On Tue, 10 Sep 2013, Jonathan Cameron wrote:
>> Lee Jones <lee.jones@linaro.org> wrote:
>>> At the moment the driver is silent in some error cases and if
>>> successful.
>>> Prior to this patch there was no clear way to know if the driver
>>> succeeded
>>> or not without looking deep into sysfs.
>>>
>>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>> ---
>>> drivers/iio/pressure/st_pressure_core.c | 3 +++
>>> 1 file changed, 3 insertions(+)
>>>
>>> diff --git a/drivers/iio/pressure/st_pressure_core.c
>>> b/drivers/iio/pressure/st_pressure_core.c
>>> index 6ffd949..34b3fb1 100644
>>> --- a/drivers/iio/pressure/st_pressure_core.c
>>> +++ b/drivers/iio/pressure/st_pressure_core.c
>>> @@ -280,6 +280,9 @@ int st_press_common_probe(struct iio_dev
>>> *indio_dev,
>>> 	if (err && irq > 0)
>>> 		goto st_press_device_register_error;
>>>
>>> +	if (!err)
>>> +		dev_info(&indio_dev->dev, "Successfully registered\n");
>>> +
>> Not keen. That to my mind is pointless noise.
>
> I think it needs to be somewhere. IIO provides no indication whether
> these chips are probed/registered/whathaveyou, or even if the
> subsystem is in use.
>
> One line per hardware component is not noise, IMO it's indicative of
> key functionality which is now available:
>
> Bootlog:
> <snip>
> iio iio: lsm303dlh_accel: Successfully registered
> iio iio: l3g4200d_gyro: Successfully registered
> iio iio: lps001wp_press: Successfully registered
> iio iio: lsm303dlhc_magn: Successfully registered
> <snip>
>
>> If this made sense then it would be in the driver core not here.
>
> Also fine. Just anything but silence/NULL reporting.

Silence means everything is good, a message means there is an error. If every 
device that gets probed would spit out a message the log would be scrolling 
forever and you wouldn't be able to see the error messages.

- Lars

