Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751534AbaDSU0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 16:26:06 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59940 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDSUZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 16:25:59 -0400
Date: Sat, 19 Apr 2014 22:25:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Reichel <sre@kernel.org>
Cc: Sebastian Reichel <sre@ring0.de>, Linus Walleij <linus.walleij@linaro.org>,
        Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        Carlos Chinea <cch.devel@gmail.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        Joni Lapilainen <joni.lapilainen@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: [PATCHv3 11/14] HSI: Introduce Nokia N900 modem driver
Message-ID: <20140419202556.GK5148@amd.pavel.ucw.cz>
References: <1396053110-21639-1-git-send-email-sre@kernel.org>
 <1396053110-21639-12-git-send-email-sre@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396053110-21639-12-git-send-email-sre@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2014-03-29 01:31:47, Sebastian Reichel wrote:
> The Nokia N900's modem is connected via Synchronous Serial Interface (SSI),
> which is a legacy version of MIPI's High-speed Synchronous Serial Interface
> (HSI).
> 
> The handles the GPIOs for enabling and resetting the modem and instanciates
> ssi-protocol for data exchange. It does not yet support exchanging voice data
> with the modem.
> 
> Signed-off-by: Sebastian Reichel <sre@kernel.org>

Reviewed-by: Pavel Machek <pavel@ucw.cz>

> +static void do_nokia_modem_rst_ind_tasklet(unsigned long data)
> +{
> +	struct nokia_modem_device *modem = (struct nokia_modem_device *)data;
> +
> +	if (!modem)
> +		return;
> +
> +	dev_info(modem->device, "*** CMT rst line change detected ***\n");

Maybe slightly less stars would work?


> +static int nokia_modem_gpio_probe(struct device *dev)
> +{
> +	struct device_node *np = dev->of_node;
> +	struct nokia_modem_device *modem = dev_get_drvdata(dev);
> +	int gpio_count, gpio_name_count, i, err;
> +
> +	gpio_count = of_gpio_count(np);
> +	gpio_name_count = of_property_count_strings(np, "gpio-names");
> +
> +	if(gpio_count != gpio_name_count) {

"if (".

> +	modem->ssi_protocol = hsi_new_client(port, &ssip);
> +	if (modem->ssi_protocol == NULL) {

...if (! ...)

> +		dev_err(dev, "Could not register ssi-protocol device\n");
> +		goto error2;
> +	}
> +
> +	err = device_attach(&modem->ssi_protocol->device);
> +	if (err == 0) {

if (!...)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
