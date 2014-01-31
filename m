Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448AbaAaMsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:48:37 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33196 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaAaMsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:48:35 -0500
Date: Fri, 31 Jan 2014 12:48:09 +0000
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>, linux-sunxi@googlegroups.com,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Message-ID: <20140131124809.GE22609@sirena.org.uk>
References: <1391165752-1819-1-git-send-email-maxime.ripard@free-electrons.com>
 <1391165752-1819-4-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iY5udFbGw2SsPZe4"
Content-Disposition: inline
In-Reply-To: <1391165752-1819-4-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/5] spi: sunxi: Add Allwinner A31 SPI controller
 driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iY5udFbGw2SsPZe4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 31, 2014 at 11:55:50AM +0100, Maxime Ripard wrote:

> +	master = devm_spi_alloc_master(&pdev->dev, sizeof(struct sun6i_spi));
> +	if (!master) {
> +		dev_err(&pdev->dev, "Unable to allocate SPI Master\n");
> +		return -ENOMEM;
> +	}

This now depends on your other series which as I said doesn't look like
the best approach.

> +	pm_runtime_enable(&pdev->dev);
> +	if (!pm_runtime_enabled(&pdev->dev)) {
> +		ret = sun6i_spi_runtime_resume(&pdev->dev);
> +		if (ret) {
> +			dev_err(&pdev->dev, "Couldn't resume the device\n");
> +			return ret;
> +		}
> +	}

No, as discussed don't do this - notice how other drivers aren't written
this way either.  Like I said leave the device powered on startup and
then let it be idled by runtime PM.

--iY5udFbGw2SsPZe4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS65uGAAoJELSic+t+oim9eagP/1uZeSFrHuaHL6Pc/qQWV49j
vlm+fMGJFyXTkpTCSw4g/99UG4r6Tei+eoQQZ1f0FGeDCruWU+RPaN1sVtiEyfYm
srDRaS5DLjrYAki+1XiRHCegaNvcbDyaHsZVriEnw2d2Ck0FI/AEjULz8eDSPMb2
5ZU0rTW+mFweTXjbGdQJjnBV/Q1K7qzbK/ZdGN/nGCcsOKdTN9Pb77Lf+S57AqZr
KXwEfbQqlVNR2oMekrQ/nXNIjTU35yLRj+efBS21atRZur6d0RxFeYIvXfdWC0xb
DY1ramrodT4mUX8fHxq9oW4j/l+pEmd3PgIpLh7xaaEPet52ymQZmK/TvDubg4IT
TDPvV5aW6bHDykUQRNgMbuByH9Nj8SOkR5+W8tSKZ1QTcUsvo0M9nGftipHWBks4
m6hPjy1keC7G+/c5H/f+gv10L1lYAZUTcW7lHyeN1gimaCoo8Fu6cKdw+pj+C6Wo
dYaCwd8pH6cjtUxb8OAvbCBTyW+Tm5T/X+cFJpQqu6J99jcoRk2uzei1iJNqMZGd
Jgu6cGcO5GaT1liBbBezNIOI9wKZmjwODnXE4FMZeNkA1tQg1TSJLq91cf5EeP1R
i/+A+FYfkgV0uatpyV9LyhVj4zXSBwrfDb1iFJL8eTNddVuQ/C1Wg7Moz1PQme6c
NfHWSJ3HNZfZdF/bZ6M6
=nU+u
-----END PGP SIGNATURE-----

--iY5udFbGw2SsPZe4--
