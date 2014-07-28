Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002AbaG1MWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:22:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59372 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbaG1MW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:22:26 -0400
Date: Mon, 28 Jul 2014 13:22:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, b42378@freescale.com,
        b02247@freescale.com
Message-ID: <20140728122211.GS17528@sirena.org.uk>
References: <1406547718-21498-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sQHYUlYw2n5TT65C"
Content-Disposition: inline
In-Reply-To: <1406547718-21498-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: wm8962: Let CODEC driver enable and disable its
 own MCLK
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sQHYUlYw2n5TT65C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 07:41:58PM +0800, Nicolin Chen wrote:

> +	pdata->mclk = devm_clk_get(&i2c->dev, NULL);
> +

This is broken for deferred probe.

> +	clk_prepare_enable(wm8962->pdata.mclk);
> +

Missing error checking.

--sQHYUlYw2n5TT65C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT1kBwAAoJELSic+t+oim9y68QAItg0yHLAH5aKxbFUeYxYmlh
9VwzpR+I146ElSU0ATyA3k9RTUClJ02UoXNez5PjZe4/X90obhIXkJ7HX8qEUwAl
ABhDx120ePbjbFkKr2jEjSHPpdS4t53RVVGN85V13U4ZMxWXWxaNcNSfIR8z2Y71
iRVmwSFMsgRaZ4TAsvsp7RgoGHfy5xr7owcClh9vMpFmBs9U5mHfv50lRDhuwF2l
wZ1uFqv8mQ9IMWiYOk1SBnGZNRDTix1uDsjsd5361fosRgzu/v8Kymn3ZJEEMKfZ
ONPoJ93j5ZXtcwitvkUVaQhwWCMEtxz6vSuCOghmf6AlD5uQEobC1rVPFw8TCkih
Wn0wP1GtYKhvE+FSiKXv/Zo/3Pge/RsBcSgDU1hhz874q3w6+/I41fJEzkzNkNMg
AD5GxJTq64gWxBQbnVfKbI+mIge+6Qpvw+LZCjgSRa5eMiS7CrAPatk+qDfI1Vwv
LMkanbH/vuokRi+orGLY3TvhhB8kV/bclnf0mLydm+I7vOvom13MqBFh7vETtp2I
uWTGe1IU79mldj/9Q/HsSRHZ0a6Qe82ddRiUfWsAk0IDKw0FTXrPjV5Q5EqdK/aI
sjvgwgW/eaGAcQ7on1MTinA8kq2JND0TsW0cXA4dZdTYuOnzx3/LXgEsmyEeq1JX
DJgNJdISm9HJfC5xBj0p
=ymCK
-----END PGP SIGNATURE-----

--sQHYUlYw2n5TT65C--
