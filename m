Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaBSHvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 02:51:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60859 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBSHvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 02:51:17 -0500
Date: Wed, 19 Feb 2014 13:52:32 +0900
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140219045232.GD2669@sirena.org.uk>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-4-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DiN016b2AKplKC+S"
Content-Disposition: inline
In-Reply-To: <1392765432-9111-4-git-send-email-mporter@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.145.86
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 3/5] regulator: add bcm590xx regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DiN016b2AKplKC+S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 06:17:10PM -0500, Matt Porter wrote:

> +static struct of_device_id bcm590xx_of_match[] = {
> +	{ .compatible = "brcm,bcm59056-regs", },
> +	{ }
> +};

This looks pretty much OK however I am in general suspicious of MFDs
that have subdevices like this in the DT - it doesn't seem like this is
a reusable device which can appear anywhere else so you're pretty much
just representing the way that Linux splits things up here rather than a
reusable IP that can reasonably have a separate binding.

If you had a binding which did something like enumerate the individual
IP blocks as individual devices that'd be more interesting, I could see
for example that a different PMIC might have a different set of register
compatible regulator IPs laid out.  It looks like that might be doable,
but it's in no way essential.

--DiN016b2AKplKC+S
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBDiNAAoJELSic+t+oim9V6cQAJXssEgqanUNT7Ae2wPNcBfJ
VioNgTtjR0ydeeu2ve4SxN4IdR0HzhyVrUHXB6lYHEkmbgu8bYTCT3xJIUmKsnKH
tel1aoWFyy3S5Zdm8ffZId5emwaafCLUnICRxrIdPP1/tBZfzZq7Tl3h2h+gYUxo
H0xdZnbs2s50r4rS9G2aSp5x2ybSePb+Nen7hFmMe2M2Y+CkzOu97zx0MHjK7vCx
AnxdXhRPIgP4ANnREfvnL4kKVZfIq2smIoNDhjY66HHkKL4Zuj89zoWoNovgBy2C
xdhXm46n0wm6MZxfdGWjVL2wr4NgU10KXFhtld1UQa/VO3LQGyk+MziOEfXfLm88
EPBEbgTdl/MQ1tVByLfefExf7/i136s72O0rDI/cr754xbSkhWyY/YOGpd9O6m79
gvxGzabqu6Kw9UwgpGXaB+z8rZBkVXcFuQ6HH7MUZZZOpfokVppugrQO+7fZzuag
j/2yvwyCAcWvfa3VS0noUToeB8JYt3aVvBaZ7ctkEJhjoz4ZBTIoTcaX0DXoCoya
6UVAjO1uYyWcDCqqV6i4T972k+XFdSdAP32OqjuzwVzigOZZcS5LUsVD9dWzRevK
lf8dX9bpqpogrJy2DoSrDyNGWjZI1AQBd4XNXgF5fCYqzFAg66kzd3hb4Y5vb2G/
TyAL+HrK5sII2hXEozpR
=0uB6
-----END PGP SIGNATURE-----

--DiN016b2AKplKC+S--
