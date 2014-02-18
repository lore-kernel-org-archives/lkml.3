Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaBRAPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:15:38 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55601 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaBRAPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:15:36 -0500
Date: Tue, 18 Feb 2014 09:14:20 +0900
From: Mark Brown <broonie@kernel.org>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        stable@vger.kernel.org
Message-ID: <20140218001420.GF2669@sirena.org.uk>
References: <1392577256-20475-1-git-send-email-mpa@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0hHDr/TIsw4o3iPK"
Content-Disposition: inline
In-Reply-To: <1392577256-20475-1-git-send-email-mpa@pengutronix.de>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.99.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core bugfix: Use normal enable for always_on
 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0hHDr/TIsw4o3iPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 16, 2014 at 08:00:56PM +0100, Markus Pargmann wrote:

Please use more standard subject lines, don't do things like "core
bugfix", just write a normal changelog.

> +static int _regulator_do_enable_no_delay(struct regulator_dev *rdev)
> +{
> +	int ret;
> +
> +	if (rdev->ena_pin) {
> +		ret = regulator_ena_gpio_ctrl(rdev, true);
> +		if (ret < 0)
> +			return ret;
> +		rdev->ena_gpio_state = 1;
> +	} else if (rdev->desc->ops->enable) {
> +		ret = rdev->desc->ops->enable(rdev);
> +	} else {
> +		ret = -EINVAL;
> +	}
> +
> +	return ret;
> +}

I don't understand this.  Why is this called _no_delay() and why don't
we want to delay when applying constraints?  We don't want to ever be in
a position where we think a supply is enabled but it has in fact not
finished ramping, and of course enable() may in fact be blocking anyway.

The use of the common code to do enable is good fix but this just seems
odd.

--0hHDr/TIsw4o3iPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTAqXZAAoJELSic+t+oim9QtYP+wTrgVT7sSOSGROT31EeC29u
4g2C1Zx899SfIoDMks50xWGVn1i3IOhNOAfCh4JKyTwXkcS9kgiTxVIpMoFfPEoj
IY6hVlP8xyTT6a91+k2HHkFNW/bLNiHf7CH3YQv5yOlglOubRwWTG60fV3GbFoaF
UfPb0Cg621s+yPVdm6pXW0pU8MEtXVOuZrB+bLRBGQTYnrx0VHmsaGcQqa8ylx/3
qBqeiqfyvUUHQnmuCKUQuuPQnf3ltZszF6t5WDr5KnYC6hlA5OU2gKZYn7MtlWc6
fw/TYgIQQPkzs9V1el7SAiLvU1QhpjYAkzZheY2IZIXAEgG54kpQGQJTRrWqhAVY
cR9M//BEGDsg0kia5+jttHBRH7zGro8gkq15N8NkZth21VF/N1Oer7KAAZyyABps
qdc0ulsVvCE8ehiyHUjw4/jI4Q/6ybiuqXTnkjR9Cggpqxf7UbFR2kUOVagw1iS5
PASBWU91u5bRFWYgNqpQ6FbYYvU9R6ITo8cZ7gwSY4P/soRAqlZBNvV6ji0m2Vju
CKIdWL23H057dLAyYapxAPsz1u3VLtPMTxgIULzVCLNxvC8jzQsTgZsh0uCxd5bx
n5j8mq6mAAn7PaGqcPPHVEZfC7pXGC7yVYo7IhJ/xpVG35vLHe6aYMqGcJHFyctU
A90yTooH8XIeuP0RbuRc
=1HUe
-----END PGP SIGNATURE-----

--0hHDr/TIsw4o3iPK--
