Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750912AbaAGL2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 06:28:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36250 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaAGL2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 06:28:15 -0500
Message-ID: <1389094089.4815.22.camel@pizza.hi.pengutronix.de>
Subject: Re: [PATCH v2 2/2] reset: Add GPIO support to reset controller
 framework
From: Philipp Zabel <p.zabel@pengutronix.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Roger Quadros <rogerq@ti.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 07 Jan 2014 12:28:09 +0100
In-Reply-To: <20140107111954.GA2849@lukather>
References: <1389030903-27684-1-git-send-email-p.zabel@pengutronix.de>
	 <1389030903-27684-2-git-send-email-p.zabel@pengutronix.de>
	 <20140106181422.GS3144@lukather>
	 <1389088341.4815.9.camel@pizza.hi.pengutronix.de>
	 <20140107111954.GA2849@lukather>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:ca9c:dcff:febd:f1b5
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 07.01.2014, 12:19 +0100 schrieb Maxime Ripard:
> Hi Philipp,
> 
> On Tue, Jan 07, 2014 at 10:52:21AM +0100, Philipp Zabel wrote:
> > > > +	const char *gpio_con_id = "reset";
> > > > +	struct reset_controller_dev *rcdev;
> > > > +	struct reset_control *rstc;
> > > > +	struct gpio_desc *gpiod;
> > > > +	bool asserted = false;
> > > > +	char scratch[48];
> > > > +	int ret;
> > > > +
> > > > +	if (id) {
> > > > +		snprintf(scratch, 48, "%s-reset-boot-asserted", id);
> > > > +		assert_prop = scratch;
> > > > +	}
> > > > +
> > > > +	asserted = of_property_read_bool(dev->of_node, assert_prop);
> > > > +
> > > > +	if (id) {
> > > > +		snprintf(scratch, 48, "%s-reset", id);
> > > > +		gpio_con_id = scratch;
> > > > +	}
> > > > +
> > > > +	gpiod = gpiod_get(dev, gpio_con_id);
> > > > +	if (IS_ERR(gpiod)) {
> > > > +		dev_err(dev, "Failed to get GPIO reset: %ld\n", PTR_ERR(gpiod));
> > > > +		return ERR_CAST(gpiod);
> > > > +	}
> > > > +
> > > > +	ret = gpiod_direction_output(gpiod, asserted);
> > > > +	if (ret < 0)
> > > > +		goto err_put;
> > > 
> > > What happens if the GPIO is active low? I see no way in your binding
> > > and driver to give that information, and that would change the
> > > behaviour quite a bit.
> > 
> > I was under the (wrong) impression that gpiod_direction_output takes a
> > logical value as gpiod_set_value does. Will fix that.
> 
> I don't think gpiod_set_value does either unfortunately.

It does, and Alexandre (added to Cc:) suggested that
gpiod_direction_output probably should, too.
I'll send a patch.

regards
Philipp

