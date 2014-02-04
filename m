Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848AbaBDSJa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 13:09:30 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35382 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100AbaBDSJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 13:09:28 -0500
Date: Tue, 4 Feb 2014 18:09:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Message-ID: <20140204180922.GN22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <df65a2de7d4afc2471846c02b73e8bbdc4f9a743.1391274628.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rXXdS9IWuK35PRlJ"
Content-Disposition: inline
In-Reply-To: <df65a2de7d4afc2471846c02b73e8bbdc4f9a743.1391274628.git.moinejf@free.fr>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 5/5] ASoC: tda998x: adjust the audio CTS_N pre-divider
 from audio format
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rXXdS9IWuK35PRlJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 30, 2014 at 12:08:06PM +0100, Jean-Francois Moine wrote:

> -	if (format == p->audio_format) {
> +	if (format == p->audio_format &&
> +	    params_format(params) == priv->audio_sample_format) {
>  		reg_write(priv, REG_ENA_AP, p->audio_cfg);
>  		return;

I find the above confusing and probably deserving of a comment
explaining the logic.  I think it's trying to skip noop configuration
updates?

>  	}
>  	p->audio_format = format;
> +	priv->audio_sample_format = params_format(params);

You should be using params_width() for the number of bits per sample.

--rXXdS9IWuK35PRlJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8SzOAAoJELSic+t+oim9H5QQAIRbYIjNbLCbAiCQ4/Qq9eQp
1rgLxCPjVG6XATgn3QMAk9zuAwOoRjk+fjSjMyb1GlG0zjVs5LqJ66KDz76ekUpU
PYb2XlFJgaI6ETDGN3Nx+ooVPPxzOEvbpc2KTW/GeVNHUQdpVm5W7luSxFhepNy3
uYW8Mgw+iyL6IGXW4L4pf+qnq+RfAb7rKy/TvtLwhST/WoJAe4otzlRE9UduEek7
sriGv4NzvKbi+s46Zz1y5LTqQU5WTaYl+DROkoCmXAaSwTB9MYx28ZgxLb0H3pxF
TxYO4sfMASbo4TAMOLbtF0dpXWzasvDAOPg/0n/XzeSlKG8xaW76KW7afq0mbw6L
utUT1I2EUMktZjLFVIOKO9U3gIXTDyV4OxwS66qn0wMNtSXWK2Jezu0zLxDxgJm/
JTtmbuvYRBtoVu0p+SNAXeOaVsnFbsxFLyp16TuBs2daTVL2wKndPs6oKd0he9M7
YkV9t2g+xmYq1uhuYad5ST84kmp9XhZ0acV32ccYVIXjsGX4xtrBbAp6FZcPhVyF
4M65WD8JWOHt9FFogZkIPfMgVXGsd6xrFiPP3CuJX/P4taZl7lN5pJT3etaqFXur
H961qTcyzVv2LNxss6q3B5YAtutYhFru6ofoBN+vGhZcmyD6d2Ugy7tzGSl7X3HU
xVToPVJ+y8W1nn+nMHu0
=8agD
-----END PGP SIGNATURE-----

--rXXdS9IWuK35PRlJ--
