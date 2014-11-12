Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbaKLNAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:00:36 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:53678 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752369AbaKLNAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:00:33 -0500
MIME-Version: 1.0
In-Reply-To: <545B2651.4090905@ti.com>
References: <1414408111-2631-1-git-send-email-vigneshr@ti.com>
	<20141103180920.GA20779@localhost.localdomain>
	<545B2651.4090905@ti.com>
Date: Wed, 12 Nov 2014 14:00:32 +0100
Message-ID: <CAJKbBDDyShaJkzzfdFs07EK5gDUfwqWiv39Qi4FVSvRrfc6_fA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Touchscreen performance related fixes
From: Johannes Pointner <johannes.pointner@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Richard Cochran <richardcochran@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        devicetree@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Jan Kardell <jan.kardell@telliq.com>,
        linux-iio <linux-iio@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Meerwald <pmeerw@pmeerw.net>, Hartmut Knaack <knaack.h@gmx.de>,
        linux-omap@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Brad Griffis <bgriffis@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Vignesh,

I tried your patch version 3 on a customized board and had some
behavior I couldn't explain.
If I only use the touchscreen it works fine but if I also read values
from the ADCs then I get a lot of pen_up events even if I am still
touching the screen.
For the test I read via
# cat /sys/bus/iio/devices/iio\:device0/in_voltage5_raw
values from the ADC in an busy loop as you explained in an email
before. Did you also experience such behavior or do you know what
causes it?

Without the patches the touchscreen works fine during the iio test.

Thanks,
Hannes

2014-11-06 8:42 GMT+01:00 Vignesh R <vigneshr@ti.com>:
>
>
> On Monday 03 November 2014 11:39 PM, Richard Cochran wrote:
>> On Mon, Oct 27, 2014 at 04:38:27PM +0530, Vignesh R wrote:
>>> This series of patches fix TSC defects related to lag in touchscreen
>>> performance and cursor jump at touch release. The lag was result of
>>> udelay in TSC interrupt handler. Cursor jump due to false pen-up event.
>>> The patches implement Advisory 1.0.31 in silicon errata of am335x-evm
>>> to avoid false pen-up events and remove udelay.
>>
>> That advisory has two workarounds. You have chosen the second one?
>
> Work around one. Hence 5 wire design is not broken.
>
>>
>> The text of the second workaround says it only works on 4 wire setups,
>> so I wonder how 5 wire designs will be affected.
>>
>>> The advisory says to use
>>> steps 1 to 4 for ADC and 5 to 16 for TSC (assuming 4 wire TSC and 4 channel
>>> ADC).
>>
>> No, it doesn't say that. (sprz360f.pdf)
>
> The pen up event detection happens immediately after charge step. Hence,
> interchanging ADC and TSC steps makes sure that sampling of touch
> co-ordinates and pen events are done one after the other. This
> workaround was suggested by internal hardware folks. Earlier ADC steps
> intervened between sampling of co-ordinates and pen event detection
> which is not desirable.
>
>>
>>> Further the X co-ordinate must be the last one to be sampled just
>>> before charge step. The first two patches implement the required changes.
>>
>> FWIW, I implemented the first workaround and removed the udelay not
>> too long ago. Like Sebastian, I saw the TSC unit hang after about
>> 50000 interrupts when running with the workaround.
>>
>> Did you test you patch for very long?
>
> Yes, I tested for about 200000 interrupts and I didn't see any hang.
> This patch series does not just implement workaround but also does some
> minor changes, such as interchanging ADC and TSC steps etc, which makes
> TSC driver more robust. Let me know if you encounter any issues with my
> patch series.
>
> Regards
> Vignesh
>
>>
>> Thanks,
>> Richard
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
