Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab3HUSas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 14:30:48 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36469 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752261Ab3HUSar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 14:30:47 -0400
Date: Wed, 21 Aug 2013 19:30:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, lee.jones@linaro.org, sameo@linux.intel.com
Message-ID: <20130821183045.GK26118@sirena.org.uk>
References: <1376997210-32631-1-git-send-email-florian.lobmaier@ams.com>
 <1376997210-32631-5-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4e5ZDkbgLEOfWmLx"
Content-Disposition: inline
In-Reply-To: <1376997210-32631-5-git-send-email-florian.lobmaier@ams.com>
X-Cookie: Your step will soil many countries.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] mfd: as3722: introduce regmap support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4e5ZDkbgLEOfWmLx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 20, 2013 at 01:13:30PM +0200, Florian Lobmaier wrote:

> +static bool as3722_readable(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case AS3722_SD0_VOLTAGE_REG:
> +	case AS3722_SD1_VOLTAGE_REG:

If there are no gaps in this a simple if ( >= <= ) would do - the switch
statements are normally used for sparse register maps with lots of gaps.

> +static bool as3722_volatile(struct device *dev, unsigned int reg)
> +{
> +	return false;
> +}

At least the interrupt status registers ought to be volatile.
Alternatively this function can be removed as non-volatile is the
default.

--4e5ZDkbgLEOfWmLx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSFQdRAAoJELSic+t+oim9I78P/RFsWFz+891lgLUjg19FXvZD
7LpiziX5N9r4GK+6fWuY8CYA2uhDAKBE52BIpMVJv0WfOnw3mBASwa7hhb8jKHQv
Gk13YoRRirOEHal4YPCFo07T6UiD2q03IhHtdWKZVgWYVl2Nk5XgIc9pbqpP2zB0
32JtAzzoJ7k1/MK91ENNnpnZa1gsv4rbK5PRHImakptns4YeQVx7xIxOCtKYS9dV
FxKyp2UUEssy+xlRYtzM2MsCNdjWu/wMUMBSHQUhnt0nImzgaX9P3HYbkTGP4Mzg
UkX9u/NRUXQMEPJGCtLBsYNjH0r1Nviefo3kRL7yKegLFz/qeqRfb9Y6s55OywUA
ClAf5V2fhZbnyxPOFiT09Dbf/sSd3HeD2Lq7fBlNZFTozWwDYIyRQi79nsvX6QTN
9Ktb7jcW7okdu8dBAyvyYEOEH0AzQHUP346lVmH/py5bGwIecQNpyWAD5x2eSeC/
l+OPQ+yddoNce7VN7RXp0cPQXb3o62l14fXIz8b6ESWarnmCReTtpOgmJTZIk1lA
54hdNp8UpFB3L/ZU7MpVUfYFExN7yhqyYl79/xtVlu9FCNf/U5+Nk25BEUVpiH0e
fSWjquLTSCPnC7yQUHJXS7DoVVFIGGdDtOR7rXVqku9bZkq85bRz2ZGf2T5ccbh4
zX2MvKrPpnSUInbex6Hi
=Y7VF
-----END PGP SIGNATURE-----

--4e5ZDkbgLEOfWmLx--
