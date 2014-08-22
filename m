Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204AbaHVVof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 17:44:35 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55878 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbaHVVoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 17:44:34 -0400
Date: Fri, 22 Aug 2014 16:44:17 -0500
From: Mark Brown <broonie@kernel.org>
To: atull@opensource.altera.com
Cc: linux@roeck-us.net, jdelvare@suse.de, lm-sensors@lm-sensors.org,
        lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        yvanderv@opensource.altera.com
Message-ID: <20140822214417.GC24407@sirena.org.uk>
References: <1408741894-24879-1-git-send-email-atull@opensource.altera.com>
 <1408741894-24879-2-git-send-email-atull@opensource.altera.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/OCBIV6O7sl/38gM"
Content-Disposition: inline
In-Reply-To: <1408741894-24879-2-git-send-email-atull@opensource.altera.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] pmbus: add regulator support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/OCBIV6O7sl/38gM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 22, 2014 at 04:11:33PM -0500, atull@opensource.altera.com wrote:

> +	if (pdata && pdata->reg_init_data) {
> +		config.init_data = pdata->reg_init_data;
> +	} else {
> +		config.init_data = of_get_regulator_init_data(dev, np);
> +		if (!config.init_data)
> +			return -ENOMEM;
> +	}

It should be fine to start with no init data - just let the regulator
core worry about it.  This will allow users to read back the state even
if they can't change anything which is useful for system bringup or
general debugging.

--/OCBIV6O7sl/38gM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT97muAAoJELSic+t+oim9RE0P/3ctAmxcQw+eYMxcs0XVvZQ6
ZwqnDoovINlsRXoi9kAGgp/gdeng1zsPgqVhdSgOdTL1p2gvoMshAnGSRGDKLopY
abZb87Nhf65UEvNob+opqeeQvRAs7pvjLNo+3BFUQ0CfhIji1LP2EwLqJt5UwJG5
sGK/MA2zchzWy9JZzRGA1meOS74wV7EzhZM047Ic1fu2+IkxXW8NpamiID4R5zey
tdxdf3jnQi3Q2M2RD7ZamEwDHSlCxSiNZCtPrj8o3KdmGoM+U0/AfWHXaDuaT961
cJNCxde7r1DSqoGMk7+4874lDjHzmdackgRyKEXFWPyDY/eAFvELbq3j7HCNKFKA
a4bRnknMubMZq3J8pY8pIpgU8BfzV+smwRN9FIbdECnNCVX7OuWA5fQBFUFXXAZn
UTslMrS8HihGspgctLkiZBjypThhaSJPvIvOpLpnvYACuCkekK2VY2bPCVW05sic
Q4FP431tG5V2tLfcgxUaJAktBrE56KvTQTU8TLtFdHOe1WZ3mZJqEwsBO33p8Q/v
fcbsWALG80OU2ljEOBdhxFfQ2Sw7aNvJyEeYToEQcYW3s8P5msPE2KkgIOcC9J9B
h14KVTjVJmNjPRn1EDtojH/3gZOgsoIaHTwL+qNocmpsV3iYLSQcEc1DqXCyDwZ7
/IPQv7z+iSoHn/fcGSmj
=chNo
-----END PGP SIGNATURE-----

--/OCBIV6O7sl/38gM--
