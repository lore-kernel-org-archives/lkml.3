Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036Ab3GYTT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 15:19:28 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33825 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3GYTTZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 15:19:25 -0400
Date: Thu, 25 Jul 2013 20:19:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20130725191905.GR9858@sirena.org.uk>
References: <20130725111459.145a4aa4@armhf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ljwjD4eUwP//fgul"
Content-Disposition: inline
In-Reply-To: <20130725111459.145a4aa4@armhf>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] ASoc: kirkwood: add DT support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ljwjD4eUwP//fgul
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 11:14:59AM +0200, Jean-Francois Moine wrote:

> +	if (np) {
> +		priv->burst = 128;		/* might be 32 or 128 */
> +	} else if (data) {

When you posted this before I queried how and why the value might vary -
I see the code is the same and I don't recall a reply.

> -	priv->clk = devm_clk_get(&pdev->dev, NULL);
> +	priv->clk = devm_clk_get(&pdev->dev, "internal");
>  	if (IS_ERR(priv->clk)) {
> -		dev_err(&pdev->dev, "no clock\n");
> +		dev_err(&pdev->dev, "no internal clock\n");
>  		return PTR_ERR(priv->clk);
>  	}

Does the code providing it already name the clock?  If not are updates
needed to do that?

> -	priv->extclk = clk_get(&pdev->dev, "extclk");
> +	priv->extclk = clk_get(&pdev->dev, "external");

Is the clock actually called extclk in the datasheet and so on?  If so
it seems better to stick with that name.  Do any boards need updates for
the new name?

--ljwjD4eUwP//fgul
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8XolAAoJELSic+t+oim9V58P/1UNcnn+z1B+jlsAmpiBFQ09
f70LNDBBcE99XhF5Bn6Kl1pgtuZhnS4JIGkM3MI8yay5/S6L7KXcgmZEhX1zgnWG
pQf9nN94kGCHy7TExzTzFLXWGMa4MeT7DEczvsdMzJOQSQ24WRcXSoEacmjdresX
Jkq50zMl11ozYR9PlAvlHPA88jqKBBTaLVMp9f681c9c0kwHAKEuqDL8x9L+zDkR
Mwkg3+5XhqB+TbEFnQ2A+dXvglvtDiEQLtJXp04Ds0t+mfoJPKftfy7gAkJyKMr+
6xalKd+iABVFnytHw/Sq6DI/bBXyYtRCi5+NlDQodaIohxTb+QD3nO1AYNmSfOcZ
CgB692c8lsIMAv1jCdK2DYMnm59cgiE/xPNnTfNNrxDHJs8H8aMBF1DJQIb/7SbZ
aGmYV31TylBQEgyYQIGR6gQIpwHW0c1bEAcWrr9KfG8WTTDGinlaCcdXnJR5nVtq
7w4XbWCraXB9vU48YBYXyz21GcxKBRfe4EWoLp++OlllPJnFN9YuBhqZXi45p8dc
rBt89L8oFXwteSRLXcoMNzV4aXt2m+MOPEb9YQJysF7dwMeG423c0tSeGLy8TNrj
XVyp0lbCgbFFjwCGLfmJWGZ7Drzx0Ugrg3HrEIzCufw4KO2PZHh6cVuxb+K7VsF6
wbsnADjmiNspjLUv7AGY
=uKcT
-----END PGP SIGNATURE-----

--ljwjD4eUwP//fgul--
