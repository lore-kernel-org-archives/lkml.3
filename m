Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752579AbaAMRfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:35:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53618 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAMRfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:35:33 -0500
Date: Mon, 13 Jan 2014 17:35:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, rjw@rjwysocki.net,
        grant.likely@secretlab.ca, jarkko.nikula@linux.intel.com,
        mika.westerberg@linux.intel.com
Message-ID: <20140113173525.GF29039@sirena.org.uk>
References: <1389620911-3890-1-git-send-email-rui.zhang@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Oaap7OtF9SpYl9KE"
Content-Disposition: inline
In-Reply-To: <1389620911-3890-1-git-send-email-rui.zhang@intel.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] fix module autoloading for ACPI enumerated devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Oaap7OtF9SpYl9KE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2014 at 09:48:31PM +0800, Zhang Rui wrote:
> ACPI enumerated devices has ACPI style _HID and _CID strings,
> all of these strings can be used for both driver loading and matching.

> But currently, in Platform, I2C and SPI bus, only the ACPI style
> driver matching is supported by invoking acpi_driver_match_device()
> in bus .match() callback.

I don't understand what this means, sorry.  As far as I can tell "ACPI
style _HID and _CID strings" are something different to "ACPI style
driver matching" but what that actually means is not at all clear to me
so I don't know what problem this is intended to fix.

Please also always remember to CC maintainers on patches.

> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 349ebba..ab70eda 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -58,6 +58,11 @@ static ssize_t
>  modalias_show(struct device *dev, struct device_attribute *a, char *buf)
>  {
>  	const struct spi_device	*spi =3D to_spi_device(dev);
> +	int len;
> +
> +	len =3D acpi_device_modalias(dev, buf, PAGE_SIZE);
> +	if (len !=3D -ENODEV)
> +		return len;
> =20
>  	return sprintf(buf, "%s%s\n", SPI_MODULE_PREFIX, spi->modalias);
>  }

What does this do and why can't acpi_driver_match_device() handle this
like it does for other ACPI devices?  We don't need to add such code for
other firmware interfaces...

--Oaap7OtF9SpYl9KE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1CPZAAoJELSic+t+oim9SoYP/RYp4eAn4U/DgMOpKnEJevUI
4syEAhXA0USolseyLUdyI7WpLsII+xvPkAUzYDrpBDm8takZY8rlGhejT9CGmeAO
KXq5fQM6MLcYw8i7R5f3LrwHDaqgqudQK5eEsz2p+MKqGHl2DhGgbr+UaxT33UiN
XYWH/kDfeGgNCkF4crJcthbCiuNCXrjyx4KbrzJJNO9E62WCDetltf185fXt9nhl
TtiufrH3K4IgBEDcZ47ITdWz+vv0ciEJsX+trVCB35XsCfBws6150vdIwyXEhpgG
2qHZIru84pNp1g3je7+DSfbuyTSesdIB5T6lh5M6sgc/JEEj2F0hx7jS4L8+SZcP
8O3E6v+UIFFx8tz5WJIqvJmMWZMrPbxhc83uthOf5ZFNZkqCr9JcPDB8JVGFGVMb
BdUa89+9AJn7z1qELCrIZkuV/DGmp0E4eDwanx9+fpNTMJpAzPi+KksFW6aZDhme
dn1qGvXpuk2fCU5995P9DGfd7juv3LiInPxTg0D5YP1a5rFzsZNTzXdulxCq2Hi4
gy5vhYnTuc+R6PVyZyWRsN/zUy587zoqxLMck54pJbzzd4f5cgd1+HzkpR6tLvkR
6Rnjx3oeeQcT7/whsDW9dFeL9oXQdaQ+bt/Yf3MWZJw3CxLySFApyGnbp7LaFPxY
wpMoKiKrA+y6hGzh+bNJ
=tMHc
-----END PGP SIGNATURE-----

--Oaap7OtF9SpYl9KE--
