Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab3GYLBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 07:01:23 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55603 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab3GYLBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 07:01:22 -0400
Message-ID: <1374750044.4297.30.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH 1/2] mfd: Add Dialog DA9063 core driver.
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Date: Thu, 25 Jul 2013 13:00:44 +0200
In-Reply-To: <20130724170721.GQ9858@sirena.org.uk>
References: <1374683683-13370-1-git-send-email-p.zabel@pengutronix.de>
	 <1374683683-13370-2-git-send-email-p.zabel@pengutronix.de>
	 <20130724170721.GQ9858@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 24.07.2013, 18:07 +0100 schrieb Mark Brown:
> On Wed, Jul 24, 2013 at 06:34:42PM +0200, Philipp Zabel wrote:
> 
> > +	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_ID, &model);
> > +	if (ret < 0) {
> > +		dev_err(da9063->dev, "Cannot read chip model id.\n");
> > +		return -EIO;
> > +	}
> > +
> > +	ret = regmap_read(da9063->regmap, DA9063_REG_CHIP_VARIANT, &revision);
> > +	if (ret < 0) {
> > +		dev_err(da9063->dev, "Cannot read chip revision id.\n");
> > +		return -EIO;
> > +	}
> 
> Is it possible to valiate these at all?

Yes, I think so. Chip id is 0x61, and revision is 3 for da9063.

> > +static int __init da9063_i2c_init(void)
> > +{
> > +	int ret;
> > +
> > +	ret = i2c_add_driver(&da9063_i2c_driver);
> > +	if (ret != 0)
> > +		pr_err("Failed to register da9063 I2C driver\n");
> > +
> > +	return ret;
> > +}
> > +subsys_initcall(da9063_i2c_init);
> 
> You should really be able to use module_i2c_driver() for modern systems,
> probe deferral should resolve the init order issues.

Ok, will fix that.

regards
Philipp

