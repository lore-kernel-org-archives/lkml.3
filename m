Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab3GOPWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 11:22:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52410 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757831Ab3GOPWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 11:22:41 -0400
Date: Mon, 15 Jul 2013 16:22:28 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree-discuss@lists.ozlabs.org
Message-ID: <20130715152228.GJ11538@sirena.org.uk>
References: <1373559359-31607-1-git-send-email-richard.genoud@gmail.com>
 <1373559359-31607-2-git-send-email-richard.genoud@gmail.com>
 <20130712114551.GD24508@sirena.org.uk>
 <CACQ1gAhmp-i7vzPKuTMxqs9Ytjynz9NTvrQk9R08U9Fo-cVzMg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SBT+cnFS/G3NVgv4"
Content-Disposition: inline
In-Reply-To: <CACQ1gAhmp-i7vzPKuTMxqs9Ytjynz9NTvrQk9R08U9Fo-cVzMg@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 1/7] sound: codec: wm8731: add rates constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SBT+cnFS/G3NVgv4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 15, 2013 at 04:53:46PM +0200, Richard Genoud wrote:
> 2013/7/12 Mark Brown <broonie@kernel.org>:

> > This isn't going to work with systems which have a variable clock as the
> > input to the CODEC.  If it's imposing constraints the driver needs to
> > allow setting the clock to zero as a way of removing constraints (and
> > any existing drivers should be updated to do this if needed).

> Maybe I'm wrong, but I didn't find any system using variable clock
> with this codec.

The driver should be written with that possibility in mind even if there
were no users; it only takes a couple of lines of code.

> The sam9g20ek (soc/atmel/sam9g20_wm8731.c) is not using a crystal, but
> it's using a fixed clock anyway.
> But there's soc/pxa/corgi.c and soc/pxa/poodle.c that puzzle me.
> They seems to use a crystal, but they are setting a different sysclk
> depending on the rate.
> That seems wrong, but as I'm a newbie in ASoC...

Note that the CPU is clock master for those - it's going to be
outputting a clock based on the sample rate selected automatically.
These boards would be broken by your change as it stands.

--SBT+cnFS/G3NVgv4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5BOxAAoJELSic+t+oim9mKYP/3FqVkMHE7LlCZvs78y1TbuF
yFKdyZvXODyi/OI6I3Znyb8oNk+zwuaf+GI0dq4L2ON+Zl+Z9xRknjRLocP0nR/D
QMQjowH6Dt903ENbmYnRTJLyMow3AHp25s2HtM4rTesJPY+Xq8XU9JPU0eL5UVfd
zQ4VL3ctfJZk3b24NP96i+euTWvZdZ970J+8tNaqFi0+z9aAGN2lkRr/OI0sXtoT
356PZsfcrxKOmF5KQqB73Zrt7U03JoiZicc8SfOv1RuZAUmr5fpCei6OH7Rxo9+B
IovW/Vmu9dDV7cfgaGauFIEwcSgjyxA+bXM1WxiEVUfLirCxGyaMYh/c7QHG0c1D
fi65o+y5uH/OUiWDciFqnCfea2uQDq3imnplMM8nF0DDyeLiz44NCNG8PPl0Dhl4
VcTwRE0Tdel0XY+Fv1nBtcT8+NviQuizS7n1MfepWjpql9L8JBAoCF9zyzjS/7BN
ErIqW+HT0mqPEBgq7Arvsdd1n94w3BYpps7g8aV6EJMnN24MYibaZIcrC4MZMB/o
N6WKIYv5C7Bi00+gedZ4SCkLIesJL9L09oVM8kJFz1LFYHzLpMQoHqpdGvD703TV
wHCKcDFukTBnyC/wz67qkqgQzy8RcY56sLuTpj44j2kA+LFVRUdaJChZ7OHzoun2
5dvRqIzZg/hCXtUo8W9G
=L2ww
-----END PGP SIGNATURE-----

--SBT+cnFS/G3NVgv4--
