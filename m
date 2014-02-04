Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaBDRI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:08:27 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35277 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828AbaBDRIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:08:23 -0500
Date: Tue, 4 Feb 2014 17:07:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Alessandro Rubini <rubini@unipv.it>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Chris Ball <chris@printf.net>,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mmc@vger.kernel.org
Message-ID: <20140204170746.GD22609@sirena.org.uk>
References: <1391529538-21685-1-git-send-email-ulf.hansson@linaro.org>
 <1391529538-21685-9-git-send-email-ulf.hansson@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3L1hu/R33NquA63z"
Content-Disposition: inline
In-Reply-To: <1391529538-21685-9-git-send-email-ulf.hansson@linaro.org>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/17] spi: pl022: Fully gate clocks at request inactivity
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3L1hu/R33NquA63z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 04:58:49PM +0100, Ulf Hansson wrote:
> Use clk_disable_unprepare and clk_prepare_enable from the runtime PM
> callbacks, to fully gate|ungate clocks. Potentially this will save more
> power, depending on the clock tree for the current SOC.

The same patch has already been applied (I noticed and fixed it while
doing unrelated code review).

>  	pinctrl_pm_select_default_state(dev);
> -	clk_enable(pl022->clk);
> +	clk_prepare_enable(pl022->clk);

Someone should really make this check errors though!

--3L1hu/R33NquA63z
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8R5fAAoJELSic+t+oim9+KAP/14mFD5xmmvH/r8MoIs9oN3r
nZ4cbt/EFSqLZncm8QuG5HRA+ZOzw0z8REs3UzLrjNkEsTmt9KNUxoYyEniHeS1N
mmsbJY77oyj12oaLv31fqh3YZGJoUVoq1Cp5/crgtADMTqjEqn/RRZmvwFnextdN
d/DPVMrx8v4kNNGQ64cj4zf/SdKJtbF+KlvkyVal7S/SVZWoZ0eUXC9d/lTBAP0w
pk6ipMZ7Rc4DYBdkmexq5jZCHS3lm4ndsDmnMKxKPHGLO3oXD0uswZ7NSa/q9uj1
8V+MlIP5P0Ah2H0g2Iz967esOmIv8MidHgG5Ae0aJdG/SI6YxgGGn2VFfLCzko2Q
OCXAKSVzJy7qEWUwaeVM1AedAho3GsfCsLqTPaWoOnw7R1Znu+TW/y6TSh0/z+S/
SYaWl1uIp3wJ6j37L1cSnurEvzuwNFvhPYjkQVQuuWVuwosG90+1egmj/uag2NQe
ZZVfm3KmZfo0xC6vNKk9aCt9ENsNBN5J11FEZzn7/ygxk84ctxqmtCcJ8+REqeUx
j8zMq8morWlL+IEOR3AzIJRWICUhr2TT4LZANy8iBlKDvoKRdRECrI9Ln+t1vTPm
gAMcaGgRKjdjDNEKADmytoxxsH/u71FpYBTddg5z4STn8RbhXSJWnXc5VePul1Ku
HH/aJCZdeAcAn1r80GxJ
=k7iL
-----END PGP SIGNATURE-----

--3L1hu/R33NquA63z--
