Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaEVRe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 13:34:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39258 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaEVRe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 13:34:26 -0400
Date: Thu, 22 May 2014 18:34:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tushar Behera <tushar.behera@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        tiwai@suse.de, perex@perex.cz, dianders@chromium.org,
        jerry.wong@maximintegrated.com
Message-ID: <20140522173403.GL12304@sirena.org.uk>
References: <1400750228-13750-1-git-send-email-tushar.behera@linaro.org>
 <1400750228-13750-2-git-send-email-tushar.behera@linaro.org>
 <537E1D0A.6020303@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G6fORYReWn2mc50W"
Content-Disposition: inline
In-Reply-To: <537E1D0A.6020303@wwwdotorg.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: max98090: Add master clock handling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G6fORYReWn2mc50W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 22, 2014 at 09:51:38AM -0600, Stephen Warren wrote:
> On 05/22/2014 03:17 AM, Tushar Behera wrote:

> > +	if (!IS_ERR(max98090->mclk)) {
> > +		freq = clk_round_rate(max98090->mclk, freq);
> > +		clk_set_rate(max98090->mclk, freq);
> > +	}

> What are the intended semantics of set_sysclk()?
> sound/soc/tegra/tegra_wm98090.c assumes that set_sysclk() is a
> notification to the CODEC driver to tell it what rate the MCLK input is
> set to (the rate is set before calling set_sysclk), whereas the code
> above assumes that this function is to tell the CODEC to somehow
> configure its input clock to be a particular rate. I have a feeling the
> code above might fail on Tegra.

It's a bit of both.  Since we've never had a generic clock API (and
still don't really due to everything being a shambles) it's generally
just a notification to the CODEC that it's at the specified rate,
however if the CODEC knows about its dependencies it seems sensible for
it to tell the clock API about what was asked.  Ideally we want to
remove all the ASoC specific clock control and use the clock API.

The Tegra driver will presumably succeed unless someone does the
appropriate clock hookup in DT, at which point clk_set_rate() for the
rate the clock is already at really ought to succeed so things should
continue to work.

--G6fORYReWn2mc50W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfjUIAAoJELSic+t+oim97igQAJrfT18/HczMy7h37CO8JPj3
yVJfaI0t/2IBxmEpJIYzuNiULEUT2GcLvplK0j7HcudEX4h4qsVure3oTOGcZWtI
Aa9xMOe51G6x8Uw68NKLWq9+tU1uKN5NPJHdSpg6tDQLPY315JyZ/i99RsMJKei/
73Ad2AGmqyZt4mfB8jICdJ4ngsSMj+aM6HXdlev/LqvlTEiFWMj8SOwrU9spePim
3WORM7kY+MLrbNjGO3ShLJJS8Yi4w5wazbSAKZbnvIHofPozC+jxCnvAyT2L0y1H
XYrvnenStu7Exx0/hPMOXXLg5QIRO41+EN7BmjWAXPHzATJnbuMe4S9GPDiFMgF/
rfKqEMgL6fiPScLQUusUdwuySbSuWOERQjAKVODu69PE+neQ1WtrmlirMlTVhkN3
Uo6HCm28HIavIeYJM+grD7/9/UudvPZDVNczhs/CLjZjKLm3ojQzPta/2qis+FqR
VM8RcjZIu/0lYV9atvKXH5Y+GBBeB4C6ki8hD7c3qmmK6uNQk+8cMmjlsGTvkQQ5
2jf5dF9wyveG7XP19ZaV6izPYNsekM8qc0feOuDVsCLpCom4Xr+blSxLk5dL2eWl
1r3xIGpE/8sreHTo+z7NzRk++9ECBSGjxPU3Q3jJLnpNVQAiGzPzS6voL9Ojp3lU
PW6v6f5fa+P4xDVliRIM
=hAyV
-----END PGP SIGNATURE-----

--G6fORYReWn2mc50W--
