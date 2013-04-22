Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3DVCaT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 22:30:19 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56288 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab3DVCaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 22:30:17 -0400
X-Originating-IP: 108.223.40.66
Date: Sun, 21 Apr 2013 19:30:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V6 6/7] drivers/hwmon: DA9058 HWMON driver
Message-ID: <20130422023045.GA31508@roeck-us.net>
References: <201304191712.r3JHCEmr017829@latitude>
 <51718BFE.7060409@metafoo.de>
 <20130420173513.GA8275@roeck-us.net>
 <24DF37198A1E704D9811D8F72B87EB514191F1F7@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191F1F7@NB-EX-MBX02.diasemi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 01:14:26AM +0000, Opensource [Anthony Olech] wrote:
> > -----Original Message-----
> > From: Guenter Roeck [mailto:linux@roeck-us.net]
> > Sent: 20 April 2013 18:35
> > To: Lars-Peter Clausen
> > Cc: Opensource [Anthony Olech]; Jean Delvare; Mark Brown; Randy Dunlap;
> > lm-sensors@lm-sensors.org; LKML; David Dajun Chen
> > Subject: Re: [NEW DRIVER V6 6/7] drivers/hwmon: DA9058 HWMON driver
> > On Fri, Apr 19, 2013 at 08:25:02PM +0200, Lars-Peter Clausen wrote:
> > > Same comment as before, I'd like to see this using the generic IIO to
> > > HWMON bridge instead of recreating it.
> > ... and I agree. Seems we are getting more and more of those, and at some
> > point it makes really sense to find a generic solution.
> > Anthony, can you please look into that ?
> > Thanks,
> > Guenter
> 
> OK -- generic IIO to HWMON bridge
> 
> I will investigate - but if you know any prototypes or any useful starting point could you let me know as I don't want to re-invent the wheel.
> 
The idea is that you would implement an IIO ADC driver (drivers/iio/adc has lots
of examples). The IIO to HWMON bridge already exists (drivers/hwmon/iio_hwmon.c
in linux-next or drivers/staging/iio/iio_hwmon.c in mainline). Setting it up
would then then a matter of platform data or device tree data.

Thanks,
Guenter
