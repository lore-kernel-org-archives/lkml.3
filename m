Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab3KZAqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:46:11 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46066 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3KZAqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:46:07 -0500
Date: Tue, 26 Nov 2013 00:46:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, linux-kernel@vger.kernel.org,
        thierry.reding@gmail.com, Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20131126004603.GU14725@sirena.org.uk>
References: <1385416655-7859-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jwSnfOBD38i7UC9C"
Content-Disposition: inline
In-Reply-To: <1385416655-7859-1-git-send-email-festevam@gmail.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Use
 postcore_initcall(regulator_init_complete)
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jwSnfOBD38i7UC9C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 25, 2013 at 07:57:35PM -0200, Fabio Estevam wrote:

> Calling regulator_init_complete via late_initcall can be too 'late' for t=
he=20
> regulator to be available for the pwm backlight driver.

> Call regulator_init_complete with postcore_initcall level instead.

That's too early for some of the other functionality in this function
though - I'd be particularly worried about the code that goes aroud
turning off unused supplies running before drivers have a chance to load
either breaking things or causing user visible glitches (and of course
the goal here is to get have this run before that happens...).

I seem to remember that there's also some one initcall per object
limitation so if we are going to try to dance this dance purely in the
regulator code it'd probably need to be split out into another object as
well as another function.  The other options that were suggested were to
either have the DT code push out the announcement or change the callers
to check of_have_populated_dt() as well as looking at the flag, of this
lot changing the callers is probably the cleanest.  I'll probably do
that tomorrow if a patch doesn't turn up before then.

--jwSnfOBD38i7UC9C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSk+9IAAoJELSic+t+oim95gsP/iGbdSsQgm289bXlgQq+Yh9/
Ap5XEfisYJOy1KICSKYQLGdv1YxINZCttq0OUYF6BOVW2KQaGQUTMVzdIPvMeIrk
EjYLA0J9vmFIzqgwCnOSHYjNiYYtnd/qgegy8H9hE/QO0zGhzlrK6fS6Y91DSLmy
iz5KmAyH49BCrx5N22MzRbvZ9DL3QrDJ/5bUYqW95ggDrg3iqALMlgQ8dp6u9T5X
9HFWl5DuPRs617+WGd3IbX5SezpNoKjeBbspMDB9pmTsdxaabbWNAuS/0pCKeFYw
vgJdv15juGw51yv6C4Foj1lO5Np+cF7DLzy1sEPhi7Oz9dRmpyB3U2YmsPKc3QEg
wDeR7yftpXQe1nQ84zb4CkD0Pu3o90bdHCugY/MjzQbQWNKSHt02jXZhdvgwFB5F
wgQuH1mOf7hTWfABd67+BXOcNowoGjXvMsx055qL1obACQdQDxys2hYdIXBCPI0r
a4AVJPqFA6XWNFycC4QfRBAbXdzQUrxWMmq7sbaKtUI873Ub16uD2nqmJRC8cw9C
rUj55MJXqUJ+HAccKl3UJjo0M2bCyWyGpV0iTzXusJTOhBgie+fJK3EA0ZLoT3eR
IC18fK/nPg2vHPkGrLuU1FvIpJ3AksU2iMSxa5ytnlUP15vGtCIuFrabZL9a6JUI
1S/a02A29vnsNaZqTl7U
=3y60
-----END PGP SIGNATURE-----

--jwSnfOBD38i7UC9C--
