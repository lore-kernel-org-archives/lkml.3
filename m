Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758154Ab3HNP3n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:29:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46817 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3HNP3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:29:42 -0400
Date: Wed, 14 Aug 2013 16:29:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, lee.jones@linaro.org
Message-ID: <20130814152940.GT6427@sirena.org.uk>
References: <1376492098-15672-1-git-send-email-florian.lobmaier@ams.com>
 <1376492098-15672-2-git-send-email-florian.lobmaier@ams.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7m9CHdxeBipTaBWu"
Content-Disposition: inline
In-Reply-To: <1376492098-15672-2-git-send-email-florian.lobmaier@ams.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] added regmap of AS3722
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7m9CHdxeBipTaBWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 14, 2013 at 04:54:56PM +0200, Florian Lobmaier wrote:

> +static bool as3722_readable(struct device *dev, unsigned int reg)
> +{
> +	switch (reg) {
> +	case AS3722_SD0_VOLTAGE_REG:

Are there any gaps in this register map?  If not just checking the range
would be easier (it looks like this is the case here).

> +	case AS3722_INTERRUPTSTATUS1_REG:
> +	case AS3722_INTERRUPTSTATUS2_REG:
> +	case AS3722_INTERRUPTSTATUS3_REG:
> +	case AS3722_INTERRUPTSTATUS4_REG:

> +static bool as3722_volatile(struct device *dev, unsigned int reg)
> +{
> +	return false;
> +}

At least the interrupt status register above should be volatile
otherwise you'll never be able to read the actual stauts.

--7m9CHdxeBipTaBWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSC6JgAAoJELSic+t+oim9FJ4P/jPIdjeNqrWNXwtwkYZycTKN
WmpvzG0rn9mylhWbSnyYkyDLO4R4Y/UJ+p/tF5ym7Z8jTsCqDY3GwNMyOT3c4Hvv
Q/O8J2I6bg7n7/NlMYwPqNhI72cb+qvzW7zD3pXgcEwnLDB2cA+TR+LDL1m8oU/x
JxLXvvplexCHHRYNlMgs8fY/EDF5jQXALOtBKgMLLXo7q4MM9LW1PL7gECfCeSoo
LDXH7zdZcoFeMdXQkJj5MtGk4K+4mgPAeiCb8jJ5HLpdsusNKoGbYsCQ0BBhXkZe
ClBzuRF886ag246D2VcwNQmIooi/NzukT3t/nh6VYxLYp7dXrSiIr7LoeFXjBBts
GXSm94AV11yxnfHNaDja3em7jbiCzCzWlerFT47EiGH+75ACtVLG5qcoMTjhRtUI
W2M7bIIB8D/SkV2GOtLY9tvtrfUpCr4Y8N4DmUHEg0QulJmvecMxq4D1MqQo9KZS
Co/gwywHxB+8c7wwVVOtBQbJL0sPz0hJfbO8yrIrcWhvy3Mi1SltIpHaOKkjEqwz
UTvKRNiFBZ/MLxSBeSjRw6kG1q20pZcLl4WtZalgl48MsJbw9j03UdKebWGFxZ0B
Sb9piw1V6YKXramMRFO3Vy4vZwh6912xGAluvMS909VNex00HvdW8fvw5Mab8JVS
/H2jqhXtZnY9yQYYeccj
=NC7f
-----END PGP SIGNATURE-----

--7m9CHdxeBipTaBWu--
