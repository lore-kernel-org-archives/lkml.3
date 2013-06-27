Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3F0T0g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:26:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:56662 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab3F0T0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:26:34 -0400
Message-ID: <51CC91E8.50605@free-electrons.com>
Date: Thu, 27 Jun 2013 21:26:32 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Organization: Free Electrons
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jean Delvare <khali@linux-fr.org>,
        jimwall@q.com, brian@crystalfontz.com,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH 3/4] hwmon: Add a simple driver to read the MXS SoC temperature
References: <1372236673-20725-1-git-send-email-alexandre.belloni@free-electrons.com> <1372236673-20725-4-git-send-email-alexandre.belloni@free-electrons.com> <20130626143927.GB31998@roeck-us.net> <20130627091732.GP5803@lukather> <20130627142758.GA5812@roeck-us.net>
In-Reply-To: <20130627142758.GA5812@roeck-us.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 27/06/2013 16:27, Guenter Roeck wrote:
> On Thu, Jun 27, 2013 at 11:17:32AM +0200, Maxime Ripard wrote:
>> On Wed, Jun 26, 2013 at 07:39:27AM -0700, Guenter Roeck wrote:
>>> On Wed, Jun 26, 2013 at 10:51:12AM +0200, Alexandre Belloni wrote:
>>>> The low resolution ADC of the mxs is able to read an internal temperature
>>>> sensor, expose that using hwmon.
>>>>
>>>> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>>>> ---
>>> Wouldn't it make more sense to use iio-hwmon and improve it if necessary ?
>> Actually, I wonder if we should not just put the hwmon driver
>> capabilities directly into the mxs-lradc driver, just like it's already
>> been done in this driver for the touchscreen support.
>>
>> The probing of this hwmon driver doesn't really belong to the DT, it's
>> not really realistic to probe it from the machine definition, and it
>> really is the IP that is wired that way.
>>
> Merging iio-hwmon functionality into an adc driver seems just as bad
> (or even worse) as copying it into a new driver.
>
> If the lradc driver knows that the ADC channels are temperature sensors, it
> should register them with the iio subsystem as IIO_TEMP type. Then you should
> be able to use iio_hwmon as is.

They are already registered as IIO_TEMP but only implement read_raw. Also,

iio_hwmon_read_val() is using iio_read_channel_processed() and that will
basically only read one of the 2 channels. As I documented, you actually
need to read both channel 8 and channel 9 and then compute the value in
Kelvins. I'm not sure how you want me to do that in the current framework.

Regards,

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

