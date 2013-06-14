Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab3FNPWc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 11:22:32 -0400
Received: from sauhun.de ([89.238.76.85]:47463 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3FNPWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 11:22:30 -0400
Date: Fri, 14 Jun 2013 17:24:30 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-i2c@vger.kernel.org,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>, linux-kernel@vger.kernel.org,
        Zbigniew Bodek <zbb@semihalf.com>
Subject: Re: [PATCH 1/2] i2c-mv64xxx: Fix timing issue on Armada XP (errata
 FE-8471889)
Message-ID: <20130614152430.GF2929@katana>
References: <1370620140-17177-1-git-send-email-gregory.clement@free-electrons.com>
 <1370620140-17177-2-git-send-email-gregory.clement@free-electrons.com>
 <20130607182500.10593e73@skate>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FoLtEtfbNGMjfgrs"
Content-Disposition: inline
In-Reply-To: <20130607182500.10593e73@skate>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FoLtEtfbNGMjfgrs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2013 at 06:25:00PM +0200, Thomas Petazzoni wrote:
> Dear Gregory CLEMENT,
>=20
> On Fri,  7 Jun 2013 17:48:59 +0200, Gregory CLEMENT wrote:
>=20
> > +/*
> > + * 5us delay in order to avoid repeated start
> > + * timing violation on Armada XP SoC.
> > + */
> > +static int mv64xxx_i2c_errata_delay;
>=20
> This should probably be a per-I2C controller variable, i.e in
> mv64xxx_i2c_data.

Yes.

>=20
>=20
> > +	if (!mv64xxx_i2c_errata_delay &&
> > +	    of_machine_is_compatible("marvell,armadaxp"))
> > +		mv64xxx_i2c_errata_delay =3D 1;
>=20
> I am wondering whether it should be done this way, or using a separate
> DT property.

Need to think about it. It is similar to the sda-hold-time issue, I
guess.


--FoLtEtfbNGMjfgrs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRuzWuAAoJEBQN5MwUoCm2M8cQAJepjpVlRj7NGrxK0gWpZ08C
6X5SNTywQWxOi1yR64huBo2gx/J2ku361l9KWY932HXEDVKNGtEY4zbPHu/DKLSk
MsvbIkxNFKf9TCeJIUVQfQpH4qQt41gP/HIoOeRd8AVzEe3V8LrcGhSjJlv4xojs
rvXt2CdD+oMzrwnaphhG+U6oJTprRLpgcuPjs7KqV5jc3mdnB7e8ivMF+sj8aNUs
ucmtb0V0CGGvUUD9GWE3txRB0MfXgmTYYBKoOQza0I6bkRbkakIHz9xk2b/zBDRC
CyNmR6TU/Twu4k+edrwymFdMc9WUM5w2ntJV0STaTgnqRy9UT3lmPdbhPbpBBK9E
0iyCe/yV4A/Iy3ZvFdMc1h1iKenSPKRFSMoIC7D/YpqMP3eo01WRb3eaOOpPHW4T
Y6zyGPC7F+wkigYOdqOab48otFz6bJCZXMee/jp/zZZnfO05KybP9YTq+4g43+uU
1U/iV2ARR54Z7W4lpObdMAdU6FRDf80IjuNEx58l0EZStHYv85Viqz8pX/LXPKqZ
GP+rDiYcKVy8Trz0lDdDtja2u5KhJh0+BT/K8jmrqWOc2UkIRqnoiqaSLZxkBAIJ
F4JwHgHUf2stMDZvnzGcUbXtNjMiylH3jV5QmUoQ5Rl9z/0oON4xc4SEn9Re7Esq
ZA++QwCyZ2uNAUDMlYXs
=87T6
-----END PGP SIGNATURE-----

--FoLtEtfbNGMjfgrs--
