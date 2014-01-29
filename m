Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200AbaA2Mp1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 07:45:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60875 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaA2MpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 07:45:25 -0500
Date: Wed, 29 Jan 2014 12:45:16 +0000
From: Mark Brown <broonie@kernel.org>
To: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Simon <horms@verge.net.au>, Magnus <magnus.damm@gmail.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <20140129124516.GZ11841@sirena.org.uk>
References: <87r47r6v48.wl%kuninori.morimoto.gx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="COrbquG2VC1mW6F2"
Content-Disposition: inline
In-Reply-To: <87r47r6v48.wl%kuninori.morimoto.gx@gmail.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About gpio-regulator setting on DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--COrbquG2VC1mW6F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 12:38:19AM -0800, Kuninori Morimoto wrote:

> How to set GPIOF_OUT_INIT_HIGH via DT ?
> Or, am I misunderstanding ?

The combination of the enable-active-high and enable-at-boot properties
ought be able to cause the driver to do the right thing, the flags do
this:

	if (config->enabled_at_boot) {
		if (config->enable_high)
			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
		else
			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
	} else {
		if (config->enable_high)
			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_LOW;
		else
			cfg.ena_gpio_flags |= GPIOF_OUT_INIT_HIGH;
	}

of_get_named_gpio() just looks up the GPIO number, it doesn't request
the GPIO.

--COrbquG2VC1mW6F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6PfZAAoJELSic+t+oim9EooP/29aTH7RKotfUbBPuaxLsICz
ENTlnaOBfy6a0aL40mvvjaOwU4x5wsJGsfn7F4XGpJCCygriaBiv1e+vwaTWHlkR
VfoiMWsOyrvwRRz6BX00Wbco7ftke1bPHDl+i591oWrKJMKJxSFE+vO9m21AecHb
0bDiui9jxzcIxQNDMAfslThaFXnO9X15nah6LE4xldGKiBDcyR/tOy7s4IqjutH0
kb9e99CbbW8uFHjzVt9LE3c0XDl/xwwPbp1L0Eweav5+OBx6g86pidLNQYGEsrxr
W1ig/GtCINcdfJJmM/+yFVlAD9DJVxx3NJ65PYquJfkuAHRzSsKtt1wn2iXj9iCl
dZThLXH16XYO5CFYuztk8o9LyHdywtz25mldpT6Apk2d3NplrcRR5zC8OYYJ1k2d
bke6YpVd18Bd8iFnPR9vnoS1hhZeHWJvepnqm2/fXt4T/yrcUeLQbEyyrJYeYwtW
sPqTwDHV2fvZXFwhIb20M1pvc5O0ClHOKkeM1H1Zhccbdq9AMdNBkWhYh9H3ymYb
vobAdEWs8c4ceeryxxzRCSF3A5sqLDhsDt8eRVJ0dt7KlOWRvq6uBsCJ+E8GXni0
N7zHRPacni+zQ9AVKz1RqJZBPxUUOtpdvxeKKX3LlVCoqudNgZS37nozr4knOFOD
sIzFmoZnl+sIb1A9xCvu
=K4cz
-----END PGP SIGNATURE-----

--COrbquG2VC1mW6F2--
