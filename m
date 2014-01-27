Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402AbaA0VBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 16:01:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60409 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875AbaA0VBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 16:01:51 -0500
Date: Mon, 27 Jan 2014 20:59:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, plagnioj@jcrosoft.com,
        linux-sound@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Linus Walleij <linus.walleij@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
Message-ID: <20140127205925.GE11841@sirena.org.uk>
References: <1389669956-2304-1-git-send-email-voice.shen@atmel.com>
 <1389669956-2304-3-git-send-email-voice.shen@atmel.com>
 <20140114203650.GX15567@sirena.org.uk>
 <52D7366B.1030909@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KPK+YGx+4g/J2wGm"
Content-Disposition: inline
In-Reply-To: <52D7366B.1030909@atmel.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/3] ASoC: atmel_wm8904: make it available to choose clock
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KPK+YGx+4g/J2wGm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 09:31:23AM +0800, Bo Shen wrote:

> >Shouldn't this code be in the DAI driver?  Otherwise this series looks
> >fine to me, though the DT folks might have something to say I guess.

>   For audio on Atmel SoC, it depends on three device nodes, one is
> SSC node, one is the codec node and the sound node.
>   The sound node will parse by machine driver, and machine driver is
> mainly for hardware connection. As the "clk_from_rk_pin" is decided
> by hardware, so, I put it here.
>   If I move the code to dai driver, it will parse the sound node in
> dai driver, I think it will make the code a little bit not explicit.
> What do you think?

I think it should just be a property of the DAI device.  It's true that
the card defines the connections but if something is going to be an
option that's there for most if not all systems then putting it in the
device driver means less effort on each integration.

--KPK+YGx+4g/J2wGm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5siqAAoJELSic+t+oim9MHkP/RFle2mFJCWuNpUqfkcVIDF4
JAqbH3k+5X1gmw5SE8/NQLuwsXb1jfp4AKQBPnw8uu3M6BbVohCavIO8Q8FAYvZq
XBIlOjoGrgRLjgoCpiC//RXd49IkMW4G7JhbS3mRtaPkVh37JP84kY3hKiQuSvjL
hZd8I+6Jc0jMfpf+GJE4Sndi0XMOPw1O+h8sIdy8r6ufdcfLz8KVtYpqJ8H8i7Tc
bUiO2Wto9ntPWOeAThIkqESnAwOvTfHBkQ6JPnpzGn6XyjdnAw5MeNuYcYuBE6wZ
+vu/7IOwAIA2KUMmlq2v+9w+pmeMYYDvmUNyA3sh0hUlqYrZ36Su+le+cimTW2o0
szdKywT2G8sJp6nWIDDMiab0e54A8qeYX0KW+ptJR8FoyDYCqUxLVKdT5W1UplHV
r/F7XcbSmQen8B1uCSsflSqvQFJy5of8kioaPQTsCaaDEM0ZYxyW4o/uRf/0mH75
5zZG6Ic32iJ2/346+DZehoYgEYCcZh49bNR1mVh4cYzjztHprojYSqwQYij+b6PA
s+3kxTz9pr6wqsmh4ahwy7NTSMAU/kQDMQSvYyIXHWvgdVRAYbJWGVhyVjzf+ldA
3KTJGr/NKzUH2nAvLrsYugDf167sgcLhvazVw+GkPLSN9WxKIYq/5wHudZvlEpX6
aREgA0c+Djq7lLUzpGX9
=S9B2
-----END PGP SIGNATURE-----

--KPK+YGx+4g/J2wGm--
