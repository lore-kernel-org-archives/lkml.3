Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149Ab3GWMfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 08:35:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49715 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab3GWMfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 08:35:11 -0400
Date: Tue, 23 Jul 2013 13:34:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@vger.kernel.org
Message-ID: <20130723123444.GW9858@sirena.org.uk>
References: <20130723104615.3696f1a9@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+hGRuEBnBrDfOHI9"
Content-Disposition: inline
In-Reply-To: <20130723104615.3696f1a9@armhf>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ARM: kirkwood: extend the kirkwood i2s driver for DT
 usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+hGRuEBnBrDfOHI9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 10:46:15AM +0200, Jean-Francois Moine wrote:

> +	np = pdev->dev.of_node;
> +	if (np) {
> +		struct of_phandle_args clkspec;
> +
> +		priv->burst = 128;			/* might be 32 or 128 */

The comment says this needs to be variable (depending on what?) but it's
hard coded.

> +		priv->clk = of_clk_get(np, 0);	/* internal clock */
> +		err = of_parse_phandle_with_args(np,
> +					"clocks", "#clock-cells", 1,
> +					&clkspec);

As others have pointed out if you need to change the clock get code
there's something wrong here, DT should be handled transparently by the
clock API.

--+hGRuEBnBrDfOHI9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7nhhAAoJELSic+t+oim92m0P/AtxA5KzgTvL2JcRGSatCCch
RGRuSa2aJ9Hr7priDpX2DM9tmyFCorGq3lNYuPorq949aR1au/i05cFXdKgF9qgB
Csz8aNTXZHg+isoQs1K+8fzew761s629mydAfJrEqXhu8uOHXDPwjEZ8r/OHZjLB
9SBcQLw1E35m4xCEwDNoYuCboatKf5oL9Zdje3KZv3j5YyX/7pEeWlXEaE7etlGb
gL7eQ+GMqgMYX2RKU2fx95piusn6kSs1kITs0jg4BMutPfNIxcVeaW0P9P08tHlc
gTVTvvLhJkl3XrcUk3GcnV0c9DLH38GmDYUhFn08RBa6V4Uie8wxrOQXbVYgNQS7
jIZa+vGo6VoD8kCkf5C60kBorS49kZXe4lNlKv5dKyXeN+Y5BbiERBgHcRtN+5s2
tdEax1pm3Q6pQ5tGdzRY+WAZ24tvnDs2LvowPYvtx2iqvwT2vf7/Hq3RDPfBW9FE
eDoIB2BM1XeZBQG+E7ZPCR+WY/F0UtpXKoPacHzLqBTx5vhM/aIPb/HTwYfK/ILL
xMjhpoaQMNV6AD7DRbrjmnoC+KmNR4IcjGASkpiVqhNGbkkKLFIh7KErPWwNpihT
vwbFpQhhBkVyUAS4HmrYHe1pGMSMYmLndD3hwDjnYQBI2cOPI3NWvWvTsi2uzKJj
MinYAGpE6Wl9xtsWYC54
=n8yr
-----END PGP SIGNATURE-----

--+hGRuEBnBrDfOHI9--
