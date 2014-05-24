Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbaEXL4N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 07:56:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41088 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaEXL4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 07:56:11 -0400
Date: Sat, 24 May 2014 12:54:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Richard Genoud <richard.genoud@gmail.com>
Message-ID: <20140524115457.GP22111@sirena.org.uk>
References: <1400893054-16126-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d8o5DkpIDJ25MRRD"
Content-Disposition: inline
In-Reply-To: <1400893054-16126-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.116.200.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Set cs-gpios to output direction
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d8o5DkpIDJ25MRRD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 05:57:34PM -0700, Stephen Boyd wrote:
> Some gpios used for cs-gpios may not be configured for output by
> default. In these cases gpio_set_value() won't have any effect
> and so the chip select line won't toggle. Request the cs-gpios
> and set them to output direction once we know if the chip select
> is default high or default low.

Currently the SPI framework is expecting that the controller driver will
own the GPIOs so it's not requesting them at all - starting to request
them in the core without warning is likely to lead to double requests
which doesn't seem like the best idea ever.  The driver has to
understand that there are GPIO chip selects since it needs to figure out
what to do with any underlying hardware chip selects that it can't stop
toggling (there may be none or it may be directable into space with
pinmux but we can't rely on that). =20

Note also that you've done this in a DT specific bit of code and this
needs to work with non-DT systems too.

> I wonder if we should request the gpios when the master controller
> probes or when a spi device is added? We only know what the default
> value should be when the spi device is added. On the other hand,
> we should probably fail probe if the gpio controller isn't ready when
> the spi master controller probes.

Right, plus the fact that each driver has to open code the requesting,
probe deferral handling and so on.  It's not super awesome, the whole
area around GPIO chip select handling needs a bit of a sorched earth
refactoring.

Ideally we'd be able to error out only the device using an individual
GPIO rather than the whole controller if a GPIO isn't there for some
reason so doing it at device time would be nicer but my recollection is
that this won't play nicely with deferred probe, it's a while since I
looked so I may be misremembering.

> Also, is it better to convert this over to the gpiod interfaces?

Yes, that too.

--d8o5DkpIDJ25MRRD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTgIiKAAoJELSic+t+oim9DawP/3nsqAE1zahDADxJ7+qCTcQZ
sAwB2VjUcon0f714pQfRaM0gH86tvEVoO2Z2wSDTnRPPw9DUptkLXiiLX64vOjlq
YA5vmfW3MizlfnMB1FOVlwJRxR/plqkkKZObKsP9ikqAIKP5WH88OkdEKfQ7RbmV
rfFEvAMMpMJ/7LxOPy5UIGttnKUZ+i4zHLMykHNbGDZ15xWGcpFyEizVc9Y/8Q0H
NNhn/b/t0iJu9k5FH5WfGo+NTZ9qW0TM8rx3t1wCccZ5G+gviS7ehmBMRq+0GBvb
Su5vrQREYQSAJ6EHrKY/h/gI8P5VZeLm1MNG0lGotoAb95pSRJy1kun1lDSTuOJg
iz1mm7zj5KSjMrH7w3oke1CfthsGVzygnqu0Xt9mKpTGNZ8aR3wH8S4eSLpETmD3
SmyE8yIHUdLrpVWTO80qBnyUb35gyBlngN35e9qjlKokDaaVtaZ+2JmwJOhv5OH2
R0/11Dzd1BX2kfM29yOqReqUCcFVMqp6toA+Otm/sNQMAkDH5Xto3BBt+DJg+IqN
PVYU2RE4aiNLaI29PFubvE/UiZFrB+HSjdbrQcPRXJa1UNAJmGPMpLushm5WmIzc
RF7M7vhfOOyNwmTP24h/kCG3UL2BYNjL81A0+2PkxFrVpAZyM4CoFEiMQ9z9fqby
QGk2GOjVPyAIATY630pj
=s26C
-----END PGP SIGNATURE-----

--d8o5DkpIDJ25MRRD--
