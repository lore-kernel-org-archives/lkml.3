Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745AbaKHKqh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 05:46:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51657 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaKHKqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 05:46:36 -0500
Date: Sat, 8 Nov 2014 10:46:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141108104606.GH2722@sirena.org.uk>
References: <1415364314-30320-1-git-send-email-laurentiu.palcu@intel.com>
 <1415364314-30320-2-git-send-email-laurentiu.palcu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h3LYUU6HlUDSAOzy"
Content-Disposition: inline
In-Reply-To: <1415364314-30320-2-git-send-email-laurentiu.palcu@intel.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.249
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h3LYUU6HlUDSAOzy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 07, 2014 at 02:45:13PM +0200, Laurentiu Palcu wrote:

> +static int dln2_spi_transfer_one_message(struct spi_master *master,
> +					 struct spi_message *msg)

It's a bit sad not to do transfer_one() but it's reasonable not to
because of the fun way /CS is being set.

> +	ret = dln2_spi_get_speed_range(dln2,
> +					   &master->min_speed_hz,
> +					   &master->max_speed_hz);

Strange indentation here.

> +static int dln2_spi_remove(struct platform_device *pdev)
> +{
> +	struct spi_master *master = spi_master_get(platform_get_drvdata(pdev));
> +	struct dln2_spi *dln2 = spi_master_get_devdata(master);
> +
> +	if (dln2_spi_enable(dln2, false) < 0)
> +		dev_err(&pdev->dev, "Failed to disable SPI module\n");
> +
> +	spi_master_put(master);

You shouldn't need this _put(), it's defeating the purpose of having the
devm_ registration.

--h3LYUU6HlUDSAOzy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUXfRtAAoJECTWi3JdVIfQeKgH/AzPYlV/+iFcPfPOiXEKPXzr
GmURLOB+FzvIiV4sFHglMMJAdroggxqWJQrEB5PUKxOxtNS7RSBlqa18Nq7rBio9
N0+p6uf7iiaxPYxL7sy2Wy7VdVl9cqAXdUiGrmbB7VJVyHp9DvMYhWKX87SChLL6
lePUJwT9Wjb2CXURx4wl+MdZONJccHs9UINTbOiDHPKpK9TdQkE9m2SNguth0VgN
BRi/kSmdBWh7TQPaqj1RJbpA3JO6yZh0nc0jSTJtuABOgsfGZcRQneiuJhRdQbIO
xHiP8AtCitMahd5sgpDfLLlBeUf47VJ4zVzMsGrqVoa7jAoW6K5ZyQ9CXSSPCmo=
=RriI
-----END PGP SIGNATURE-----

--h3LYUU6HlUDSAOzy--
