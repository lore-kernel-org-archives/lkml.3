Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3G2SQU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:16:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:57943 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615Ab3G2SQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:16:18 -0400
Date: Mon, 29 Jul 2013 19:15:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>,
        Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Message-ID: <20130729181554.GB9858@sirena.org.uk>
References: <1375117247-6376-1-git-send-email-p.zabel@pengutronix.de>
 <1375117247-6376-7-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C3GVr9oncBafBIUo"
Content-Disposition: inline
In-Reply-To: <1375117247-6376-7-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 6/6] mfd: da9063: add 32 kHz output clock to clock tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C3GVr9oncBafBIUo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 29, 2013 at 07:00:47PM +0200, Philipp Zabel wrote:

> +	clk = devm_clk_register(da9063->dev, &out_32k->clk_hw);
> +	if (IS_ERR(clk))
> +		return PTR_ERR(clk);
> +

This introduces a dependency on COMMON_CLK.  It might be best to make
this a function device in drivers/clk, and for something like this we
really ought to be able to create regmap helpers though that can be done
later on.

--C3GVr9oncBafBIUo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9rFXAAoJELSic+t+oim9xqMQAIlBbiAvebaP2NtIIPMhrG4W
V5IGpS8IrgiPlv/CO34FxsTFnaoYz3gH+m6EH4GSW7rq/hzHoZ3yXazdbs0SVGXN
TSaWSUJevb18s96xucsjIfFur0jyh91PGxpw/jAvi4QRd1/YgFRxoeCPbWxGVcfV
wlhlXliIUXG0RvGR0QrF/Z4y08vxa2pW8G3mK74L++v3YzM0V1FwJ4/HO7vkBM79
1hdUiy3f2UkEtnzODb+Vl/T7EqckQrUdtc2Pw1N7FvYBs9XZxF96ggWHWITHy9+i
O1rWBddq1X1w3TMYHH9NbrVESSqBG1diuo2lVip9U9vt9zl5q50ZFgJFnFCVSHsz
nBku53LQ/NUNnYEL/697o/owWISPMULIR/4e3n8B5cc7DuRv/LllKMc7dnlLq0XY
U6Qp0jnCrAuvBwYwi1nMKHEYezV70QIJNO7EfbHaF++WV5Sci93cZ3FOJkP2m2WW
Skh3GSp+Pg2lzapf8QxrI43XnL7OZjtpCjRyLlw+SzFmTZxvbeSUyAUxbpX1izko
ghruOeUlPmTuZzwZmTY1U3zBZphdEowc8jy6NhV1ciH9G09+eD1p3d6iWQUuVybo
kCSN0lc+WAROXCROuEN7/UPaZGySdQ/KAqhmDaI1umt53I6ysRr6aVFi+uK4laGE
OEcS+2S3C1PI6IIWQKux
=Z06a
-----END PGP SIGNATURE-----

--C3GVr9oncBafBIUo--
