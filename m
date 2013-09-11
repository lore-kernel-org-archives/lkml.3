Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab3IKHaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 03:30:00 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45043 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3IKH37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 03:29:59 -0400
Date: Wed, 11 Sep 2013 08:29:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, jic23@cam.ac.uk, arnd@arndb.de,
        linus.walleij@linaro.org, denis.ciocca@st.com,
        linux-iio@vger.kernel.org
Subject: Re: [PATCH 27/38] iio: pressure-core: st: Give some indication if
 device probing was successful
Message-ID: <20130911072955.GG11227@lee--X1>
References: <1378817379-8238-1-git-send-email-lee.jones@linaro.org>
 <1378817379-8238-28-git-send-email-lee.jones@linaro.org>
 <43055af7-991f-4122-b308-a3dcddbbb72a@email.android.com>
 <20130911071053.GD11227@lee--X1>
 <52301963.5030006@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52301963.5030006@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Lars-Peter Clausen wrote:

> On 09/11/2013 09:10 AM, Lee Jones wrote:
> >On Tue, 10 Sep 2013, Jonathan Cameron wrote:
> >>Lee Jones <lee.jones@linaro.org> wrote:
> >>>At the moment the driver is silent in some error cases and if
> >>>successful.
> >>>Prior to this patch there was no clear way to know if the driver
> >>>succeeded
> >>>or not without looking deep into sysfs.
> >>>
> >>>Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>>---
> >>>drivers/iio/pressure/st_pressure_core.c | 3 +++
> >>>1 file changed, 3 insertions(+)
> >>>
> >>>diff --git a/drivers/iio/pressure/st_pressure_core.c
> >>>b/drivers/iio/pressure/st_pressure_core.c
> >>>index 6ffd949..34b3fb1 100644
> >>>--- a/drivers/iio/pressure/st_pressure_core.c
> >>>+++ b/drivers/iio/pressure/st_pressure_core.c
> >>>@@ -280,6 +280,9 @@ int st_press_common_probe(struct iio_dev
> >>>*indio_dev,
> >>>	if (err && irq > 0)
> >>>		goto st_press_device_register_error;
> >>>
> >>>+	if (!err)
> >>>+		dev_info(&indio_dev->dev, "Successfully registered\n");
> >>>+
> >>Not keen. That to my mind is pointless noise.
> >
> >I think it needs to be somewhere. IIO provides no indication whether
> >these chips are probed/registered/whathaveyou, or even if the
> >subsystem is in use.
> >
> >One line per hardware component is not noise, IMO it's indicative of
> >key functionality which is now available:
> >
> >Bootlog:
> ><snip>
> >iio iio: lsm303dlh_accel: Successfully registered
> >iio iio: l3g4200d_gyro: Successfully registered
> >iio iio: lps001wp_press: Successfully registered
> >iio iio: lsm303dlhc_magn: Successfully registered
> ><snip>
> >
> >>If this made sense then it would be in the driver core not here.
> >
> >Also fine. Just anything but silence/NULL reporting.
> 
> Silence means everything is good, a message means there is an error.
> If every device that gets probed would spit out a message the log
> would be scrolling forever and you wouldn't be able to see the error
> messages.

Only if you print out every regulator, clock, GPIO pin and things of
this nature. Key hardware blocks such as; SD, Flash, USB, Eth, HDMI,
Audio, UART, GPIO and I2C controllers and Sensors I think deserve a
one line "I'm here and working" message.

I'll not fight this for too long. This is based my experience as a
user. I tried to look at the bootlog for the sensors I'd just enabled
and there was nothing. Some of them had probed, some hadn't and there
was no clear way to distinguish between them without digging into
sysfs.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
