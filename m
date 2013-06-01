Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3FAT2K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 15:28:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43099 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959Ab3FAT2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 15:28:07 -0400
Date: Sat, 1 Jun 2013 20:27:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Hebbar Gururaja <gururaja.hebbar@ti.com>
Cc: khilman@linaro.org, grant.likely@linaro.org, linus.walleij@linaro.org,
        rob.herring@calxeda.com,
        davinci-linux-open-source@linux.davincidsp.com,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, vaibhav.bedia@ti.com,
        sudhakar.raj@ti.com, spi-devel-general@lists.sourceforge.net
Message-ID: <20130601192726.GS16790@sirena.org.uk>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
 <1369995191-20855-6-git-send-email-gururaja.hebbar@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jesV4P1FjH8FXPjZ"
Content-Disposition: inline
In-Reply-To: <1369995191-20855-6-git-send-email-gururaja.hebbar@ti.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/11] spi: omap2-mcspi: enhance pinctrl support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jesV4P1FjH8FXPjZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 31, 2013 at 03:43:05PM +0530, Hebbar Gururaja wrote:
> Amend the spi omap controller to optionally take a pin control
> handle and set the state of the pins to:
>=20
> - "default" on boot, resume and before performing an spi transfer
> - "idle" after initial default, after resume default, and after each
> spi xfer
> - "sleep" on suspend()

Looking at this code I can't really see what's OMAP-specific about it -
exactly the same flow should apply to pretty much any SPI controller,
especially given that the code will happily ignore missing states.
We're just setting the idle state when not actively transferring data
which seems sensible and generic.

This suggests to me that we should be adding this code into the core,
probably joined up with the transfer_one_message stuff, so that any
hardware which has an idle state will be able to get the benefit.  Can
anyone think of a reason why we shouldn't do that?

--jesV4P1FjH8FXPjZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqksbAAoJELSic+t+oim9YPkP/2Mh8qGtSUuoR0QFZSiQ4T0V
1Dw8LcOQ6mUYD9jvhF/pQDV92oLx3nTHJc/Nj0uJ4dk5gxDgVe8ubndW6xAS1ICs
GbbN5y72QjzUwi3S2EI3Ucfe0M9TlvUIRKzgdox8rBIm3BS+JSNj4r+UYu++o+7G
qvzyURyiwvje/9/BBcAo8iGlzVOq/QIvKog5lxZPZX64wXjNgINoZ4dMRU8c8FM3
dlPRkab1PpIlTUGZ9FdTUKdLwe4/NZ3TwVEQsyrU1/zcssNsW4t++ihObZpyz9nS
74VSBvbnOdqxFTUOUQ9y54uGjET8PwJ7DBK+Kx9o8/IRg00X15JCbsU2lh2ddqly
flQ9IWz5il0e9B9O9zz6bjOOQAXUWeeuf2ss9Y1CGXHHfLANLHIJPD66hvwPfwUu
2GZPEE+njNWVJK2UKXmtCXHZ6j27n6ce2vJWYm01uQgEfkwb+CO/MgGn/h4b7EdT
d9LSK4INXQXtLhrpJ2G4BovRAuz426EjGe5dDYZPwc/NEuASRNEEIKnkP7fZ4wrj
sYUVIK3aO+T+z7Mi51IGN4OFdfC0iyDOCwCvRjL1fJOl58lzA5gFOimI38mvdvq6
moZpOV4sXJ/rNIR7px23rFvA5w08DgJhzOEleHN9fSqek4jnpx10veTRhj4Oo06o
l33gdt855JQlLuOqEa7m
=IGvf
-----END PGP SIGNATURE-----

--jesV4P1FjH8FXPjZ--
