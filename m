Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab3GHTkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 15:40:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36486 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab3GHTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 15:40:00 -0400
Date: Mon, 8 Jul 2013 16:07:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Message-ID: <20130708150721.GK27646@sirena.org.uk>
References: <1373290193-25300-1-git-send-email-richard.genoud@gmail.com>
 <1373290193-25300-2-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/W7LeEItOXj90cO"
Content-Disposition: inline
In-Reply-To: <1373290193-25300-2-git-send-email-richard.genoud@gmail.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.114
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] sound: sam9x5_wm8731: machine driver for
 at91sam9x5 wm8731 boards
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/W7LeEItOXj90cO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 08, 2013 at 03:29:49PM +0200, Richard Genoud wrote:

> + *		  Nicolas Ferre <nicolas.ferre@atmel.com>
> + *
> + * Based on sam9g20_wm8731.c by:
> + * Sedji Gaouaou <sedji.gaouaou@atmel.com>

The obvious question here is of course if we can use the same driver for
both of them.

> +	codec_dai->driver->playback.rates &= SNDRV_PCM_RATE_8000 |
> +		SNDRV_PCM_RATE_32000 |
> +		SNDRV_PCM_RATE_48000 |
> +		SNDRV_PCM_RATE_96000;
> +	codec_dai->driver->capture.rates &= SNDRV_PCM_RATE_8000 |
> +		SNDRV_PCM_RATE_32000 |
> +		SNDRV_PCM_RATE_48000 |
> +		SNDRV_PCM_RATE_96000;

You definitely shouldn't be fiddling with a driver's constant static
data.  You want to be using snd_pcm_hw_constraint() APIs to set
additional constraints intead.

--Y/W7LeEItOXj90cO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR2tWmAAoJELSic+t+oim9SigP/2mwYwTpQGPNkYf5YXgcIOT3
Pvc/Q0MjIbEglKCTk5iydPoqZlr/649FXbyatcxwe6BMhvS7EHzZ7KlrGVDJdPBS
7UjW0S7ZmhZGEHRVSX/osqYgJZtxFe2ONlamlp96pOO/8T+jyF73g4p1UETyEDkz
76jdU77aP2V8J0+pQrBH+F8B/uNubGDXAV3ur3wuJvH/27fNDivQkFpG4yc7o07r
GwBU4viaLYfTws+kLtGucgEsg551ZAXVwymraac6bMmeZW/oFgo1U/PRTlNvevio
LRIDyg+jer2CJ4ajB9RO56lU+IEpCq+fhh9Q70Vf2CPVAZMOPpdf1flSURO1yFrc
dW0nZ6tmH/AguGTc8Cnx3X1/9uJOuBEycC1z6d0ZuZjHvf7cgbxnLFMaX93eFS5y
l1hQiDTG2GFfRIJPs0490vOuQ227hpKgofv8KyPolth7mpaSTcNGui8CvrPymJrv
DLggcgUI3QMnRqeWkZulfdduIhNUZNbl0JnHpBF8jo4VBrVXMvrkIZpMjB2w5Px8
v2SRWvzeqgT/hg6M/AxjYhLBESEFOic9PlmQX9G6C74Ee1qumX482vV6+0GnA+8j
vJG3p+OKe0bgII8D6pxcAEW7ZTQinkYOCV3nI1qqueZyInwfJKub+iMKKB9IuwFG
mhKXJJTp1y5ctR6ljC6T
=WiwD
-----END PGP SIGNATURE-----

--Y/W7LeEItOXj90cO--
