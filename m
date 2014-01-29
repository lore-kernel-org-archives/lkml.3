Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbaA2QvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 11:51:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60938 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaA2QvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 11:51:18 -0500
Date: Wed, 29 Jan 2014 16:51:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Simon <horms@verge.net.au>, Magnus <magnus.damm@gmail.com>,
        Linux-SH <linux-sh@vger.kernel.org>, linux-kernel@vger.kernel.org
Message-ID: <20140129165105.GD22609@sirena.org.uk>
References: <87r47r6v48.wl%kuninori.morimoto.gx@gmail.com>
 <20140129124516.GZ11841@sirena.org.uk>
 <52E92943.8010401@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <52E92943.8010401@codethink.co.uk>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: About gpio-regulator setting on DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 29, 2014 at 04:16:03PM +0000, Ben Dooks wrote:
> On 29/01/14 12:45, Mark Brown wrote:

> >of_get_named_gpio() just looks up the GPIO number, it doesn't request
> >the GPIO.

> I think you've just run in to the same problem that we've found
> with the GPIO regulator code for the vmmcq on the lager where the
> DT probed version is getting 1800mV for MMC whereas the platform
> probed version gets 3300mV for MMC (and thus works better).

> My view is that we should really add an initialisation voltage
> setting to the regulators so that if there is >2 states we can
> select the state it starts in.

The drivers using the regulator should be doing that if the regulator
has variable supplies, the expectation is that trying to provide
something outside of a driver that's actively managing this is just
going to give more opportunity for the system to become fragile.  A
write only driver like the GPIO regulator may want to provide something
but it's not clear to me that this would help for generic regulators.

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS6TF2AAoJELSic+t+oim9oxkP/1cbaeUt41RPMJr+fx6910ZT
lT/sPTV/ADZXwh4n/XlUwIsni7VQuX7MbhNKJ3vLL6hglY8iUBgeW8WZeG2C7NTe
Zrl9H+kBVsAv2xI4Od1TPMt2rLQET5C3zCxjTY/ol5bjHeBYv3ca0koRLnPYhy5U
o6NEOW5nzsG3J+kAbndKETLDPl52RTqpSIjwj3FBIr+n9w7U4jjvFCfmmqk3ivWC
EBBr2J0dFluRQ3v+Q+8kjskxIO1Td0SM5TB+wz/bflSZ7KCKY2SqN9FspCELus9c
HjrGc2h/h5z695OPvxlte1nWRhReauCOqM0Gu2JaJpF4aeMCh6LUDyO0AbrELZXV
YxzntMh/g4m23LeUY4jU+PySts5eQ86qJakEzcWPwzQckKe4RwMA69YblrqxNVwh
yvp/a5vQhl8855Wv7Adds/c/GXD0Cq8NHhhvO9VuUpGf0hR3aI8bnAlSnDvIehBb
+TRrMctq4i05glTSP9YMxDo6GVqH7LUs++0zXS0U/zWD+ORvsq+KYwu/soa7k6Y8
R179RPI4aecAEN7CT460Isk8LDebbKdlDpK2qTzhzFkrJjVKZ6AeoUI1vMkfyTJ0
SQRAuoyKaoDOJ7JafbnSf1vO6EcRLO+hlUSnblS8iePFj0yxEtpI/2GVjfETYMUg
QptjXgpRPfPiN0mgxrFz
=4sgu
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
