Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaCMONZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:13:25 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60227 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbaCMONY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:13:24 -0400
Date: Thu, 13 Mar 2014 14:13:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Message-ID: <20140313141317.GX366@sirena.org.uk>
References: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CRrRoVXEpX/Dc4YP"
Content-Disposition: inline
In-Reply-To: <1394697961-4440-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: irq: Set data pointer only on
 regmap_add_irq_chip success
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CRrRoVXEpX/Dc4YP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2014 at 09:06:01AM +0100, Krzysztof Kozlowski wrote:
> After setting the 'data' pointer (wchich is returned to the caller for
> freeing later) the regmap_add_irq_chip() could still fail for various
> reasons (ENOMEM, regmap_read or regmap_write failure). In such case the
> memory under 'data' was freed in error path and error value was returned
> but the 'data' variable was not changed.
>=20
> This could lead to errors if the caller passed such 'data' to
> regmap_del_irq_chip().

If the user is calling regmap_del_irq_chip() after the add failed then
I'd expect things to break anyway...

--CRrRoVXEpX/Dc4YP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIbz6AAoJELSic+t+oim9EJUP/0ERAVdJ0n6mLp3unf84hrZA
WPQmtTKqBGJvmIknbu2TExEmlqoDdVXdDvJYwtQ7w8Jqx8MkRTi2PHu6Mh6zFGN5
i8aacQU3Ix4RzEKUW/7+RIVT1wHd7xmuh1MvDGzow5u+6qwvGQDpnzVJzZ5oUs2R
cCWhyMR5KjwEaiGF/TLpe9aoF4GGkvOZ6FxqrvKrzTfJlbipUeDAt453kmgV6cks
dQPAz8e+dw9gGABGCykkvpSLrVSJmCiVues3B49j9qRdULq5OWRre1pRhMI6uw+z
D+bH2HTE6fDEW0t3mm0ccJG5x+94AATEVtPlJrHG5G6FPNJSIQagHn+ScpmwowWD
pfAkUKzgUMMR53Ngv8OuWhLHICYJB94mTA7QWrcPp8htmUHcaOIHeDosydb69wXf
zmW++jtiE8xPNLb5nitcVbehpC1IqQQ33AL9dY5g9jUZ938zVjnEhN2zFjpcoEVl
ksoKm/sTjjIY3ulyxfNlz15ZmyhQ6wyOkTQsYOjdJtAJRzDlmGwA1u/nbHqMwTN8
rfEAEN9a9IRQBoiesSxGtnkCb8yqJg79qwUh4VmcRwtTeztukuGXiJ57xBrwloQd
y3Af6EUS6bjefxrc3Ljh86ZvFdMy8Boae6sVxcdvePyGUV8rVl/oR3tcqJ12h3ua
qxUXqzPsn2eN/D1Xtj/u
=a2KB
-----END PGP SIGNATURE-----

--CRrRoVXEpX/Dc4YP--
