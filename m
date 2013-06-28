Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3F1PVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 11:21:16 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:51836 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753889Ab3F1PVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 11:21:14 -0400
Message-ID: <51CDAABB.4020505@metafoo.de>
Date: Fri, 28 Jun 2013 17:24:43 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shawn Guo <shawn.guo@linaro.org>, Jean Delvare <khali@linux-fr.org>,
        jimwall@q.com, brian@crystalfontz.com,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org
Subject: Re: [PATCH 3/4] hwmon: Add a simple driver to read the MXS SoC temperature
References: <1372236673-20725-1-git-send-email-alexandre.belloni@free-electrons.com> <1372236673-20725-4-git-send-email-alexandre.belloni@free-electrons.com> <20130626143927.GB31998@roeck-us.net> <20130627091732.GP5803@lukather> <20130627142758.GA5812@roeck-us.net> <51CC91E8.50605@free-electrons.com> <51CD9B19.90407@metafoo.de> <51CDA2BF.5050501@free-electrons.com>
In-Reply-To: <51CDA2BF.5050501@free-electrons.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 04:50 PM, Alexandre Belloni wrote:
> On 28/06/2013 16:18, Lars-Peter Clausen wrote:
>> On 06/27/2013 09:26 PM, Alexandre Belloni wrote:
>>>
>>> They are already registered as IIO_TEMP but only implement read_raw. Also,
>>>
>>> iio_hwmon_read_val() is using iio_read_channel_processed() and that will
>>> basically only read one of the 2 channels. As I documented, you actually
>>> need to read both channel 8 and channel 9 and then compute the value in
>>> Kelvins. I'm not sure how you want me to do that in the current framework.
>> What are these two channels actually measuring? Is the value of a single
>> channel meaningful on it's own? If not it might make sense to update the IIO
>> driver to just have one temperature channel.
> 
> It's not actually meaningful on its own. So, what you would do is expose
> one iio channel for two ADC channels and do the computation in read_raw
> ? or read_processed ? Then using iio-hwon to export it. ?
> 
> Regards,
> 

Yes, return channel9 - channel8 as the raw value for the temperature channel
and provide proper scale and offset values, so that
iio_read_channel_processed() will return the correct value.

- Lars
