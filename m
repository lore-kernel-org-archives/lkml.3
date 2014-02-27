Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaB0ENV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 23:13:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52557 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaB0ENU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 23:13:20 -0500
Date: Thu, 27 Feb 2014 13:11:40 +0900
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, vinod.koul@intel.com, brian.austin@cirrus.com,
        Paul.Handrigan@cirrus.com, timur@tabi.org, mr.swami.reddy@ti.com,
        vishwas.a.deshpande@ti.com, fabio.estevam@freescale.com,
        kuninori.morimoto.gx@renesas.com, sachin.kamat@linaro.org,
        Adam.Thomson.Opensource@diasemi.com, dgreid@chromium.org,
        abrestic@chromium.org, swarren@nvidia.com, shc_work@mail.ru,
        s.trumtrar@pengutronix.de, bardliao@realtek.com, shawn.guo@linaro.org,
        LW@KARO-electronics.de, mpa@pengutronix.de, peter.ujfalusi@ti.com,
        Andreas.Irestal@axis.com, ckeepax@opensource.wolfsonmicro.com,
        rf@opensource.wolfsonmicro.com, viresh.kumar@linaro.org,
        axel.lin@ingics.com, alban.bedel@avionic-design.de,
        voice.shen@atmel.com, jic23@kernel.org, mahaijuns@gmail.com,
        mike.dyer@md-soft.co.uk, b42378@freescale.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140227041140.GC9383@sirena.org.uk>
References: <1393465065-9512-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nmemrqcdn5VTmUEE"
Content-Disposition: inline
In-Reply-To: <1393465065-9512-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 223.55.94.147
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: io: Clean up snd_soc_codec_set_cache_io()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nmemrqcdn5VTmUEE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 09:37:45AM +0800, Xiubo Li wrote:

> I'm also thinking could we just discard snd_soc_codec_set_cache_io()
> calling from each individual driver to simply the code? And just bind
> it to devm_regmap_init_i2c() and devm_regmap_init_spi()...

> Is there any other limitations for snd_soc_codec_set_cache_io() usage?

That's the goal overall, I'm not sure it's worth going through and
changing the signature of the function and then later going through and
merging it, it's just too much churn.  The main thing we need to do in
order to do that is to make sure nothing is relying on specific
sequencing during startup, probably by providing a way to manually set
the regmap pointer in the main device probe function rather than in the
ASoC one.

--nmemrqcdn5VTmUEE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDrr5AAoJELSic+t+oim9Zp4P+wSGUTQFyn2X5+xBMXX/ttxN
VzoW7LwmCcCpRp6nB868ZLUHSP8c7CeA5vO7AaVWxwh05063sd3296KpU+jfurL/
sfmpTlFsEcA2/mNB3mXrrEx0oxz+xZzlJcYLuanZZc3XISOHYScxu0IhZyXjZnk4
R7jM8+xmaM3sG9cvcoL65ebXHhbEnGbULn8inMmHJ/WlLm6fCkH7OPe7MzWbaHsP
bjTpFWy7QLl/O6ooo/4xMaTVjcRbU1O31tc+PbvWXyRly6b+UaMhNOVuVaGQQXIq
UxSoV1XwYVrBUWakjQGdQWQzSBPlIKmXJhoS2TVDxrf2tAgQxifGkMSWzHklM1K3
nsC+WG45YhDcCpcid6xsX13OZlaT1dA8W67b+TXNf87ybshZr4o0Qq7Z0SV3ILjx
IdYdqo4uyJ3CgF5Zucj59ia3tBBNuSlhZkus4NGbAukZslMw+FljiAoEChVDzWbO
SZkHT+UnMjBYFSSxveFC6deRCgkp6WlhaCq0BgWIsLxtufp7iw/8gk5d29CDEg9n
yp12KUk72IK1HYikOrUwkqyTZUNs18bsi6Vo+TrJiOP5YIihXjRd3r3w8kxRn9Vh
IUP9Qh2VZWGhSj8YAMQ8KFVhd2ivw6D3BC2w0dwaiCYBbcbwFQDnjOu6WZ2ZzftE
TLC5xN7rQfwv8y/QFQzs
=pVVl
-----END PGP SIGNATURE-----

--nmemrqcdn5VTmUEE--
