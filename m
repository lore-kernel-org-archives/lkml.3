Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936269AbaH1HTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 03:19:55 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:37559 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934221AbaH1HTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 03:19:53 -0400
Date: Thu, 28 Aug 2014 08:19:46 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Beniamino Galvani <b.galvani@gmail.com>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Mark Brown <broonie@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        linux-watchdog@vger.kernel.org, devicetree@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Carlo Caione <carlo@caione.org>
Subject: Re: [PATCH 3/4] watchdog: add driver for Ricoh RN5T618 watchdog
Message-ID: <20140828071946.GF24579@lee--X1>
References: <1409091237-16722-1-git-send-email-b.galvani@gmail.com>
 <1409091237-16722-4-git-send-email-b.galvani@gmail.com>
 <20140827190135.GA18849@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140827190135.GA18849@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Guenter Roeck wrote:
> On Wed, Aug 27, 2014 at 12:13:56AM +0200, Beniamino Galvani wrote:
> > This adds a driver for the watchdog timer available in Ricoh RN5T618
> > PMIC. The device supports a programmable expiration time of 1, 8, 32
> > or 128 seconds.
> > 
> > Signed-off-by: Beniamino Galvani <b.galvani@gmail.com>
> > ---
> >  drivers/watchdog/Kconfig       |   11 +++
> >  drivers/watchdog/Makefile      |    1 +
> >  drivers/watchdog/rn5t618_wdt.c |  196 ++++++++++++++++++++++++++++++++++++++++
> >  include/linux/mfd/rn5t618.h    |    4 +
> >  4 files changed, 212 insertions(+)
> >  create mode 100644 drivers/watchdog/rn5t618_wdt.c

[...]

> > +++ b/drivers/watchdog/rn5t618_wdt.c
> > @@ -0,0 +1,196 @@

[...]

> > +static int rn5t618_wdt_set_timeout(struct watchdog_device *wdt_dev,
> > +				   unsigned int timeout)
> > +{
> > +	struct rn5t618_wdt *wdt = watchdog_get_drvdata(wdt_dev);
> > +	int ret, i;
> > +
> > +	for (i = 0; i < ARRAY_SIZE(rn5t618_wdt_map); i++) {
> > +		if (rn5t618_wdt_map[i].time + 1 >= timeout)
> > +			break;
> > +	}
> > +
> > +	if (i == ARRAY_SIZE(rn5t618_wdt_map))
> > +		ret = -EINVAL;
> 
> Can you simplify this a bit ? If you use
> 
> 	if (i == ARRAY_SIZE(rn5t618_wdt_map))
> 		return -EINVAL;

This changes the semantics.

> > +	else
> 
> You can drop this else statement.
> 
> > +		ret = regmap_update_bits(wdt->rn5t618->regmap, RN5T618_WATCHDOG,
> > +					 RN5T618_WATCHDOG_WDOGTIM_M,
> > +					 rn5t618_wdt_map[i].reg_val);
> > +	if (!ret)
> > +		wdt_dev->timeout = rn5t618_wdt_map[i].time;

... Isn't this important?

> > +	return ret;
> > +}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
