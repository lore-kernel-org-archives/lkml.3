Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaKYNUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:20:31 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38101 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbaKYNQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:16:07 -0500
Date: Tue, 25 Nov 2014 13:13:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141125131351.GC7712@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmojth4sdaU3VRJa"
Content-Disposition: inline
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: Remove 'const' from the device_node pointers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmojth4sdaU3VRJa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 12:14:48PM +0100, Jean-Francois Moine wrote:
> As Russell King's explained it, there should not be pointers to
> struct device_node:
>=20
> "struct device_node is a ref-counted structure.  That means if you
>  store a reference to it, you should "get" it, and you should "put"
>  it once you've done.  The act of "put"ing the pointed-to structure
>  involves writing to that structure, so it is totally unappropriate
>  to store a device_node structure as a const pointer.  It forces you
>  to have to cast it back to a non-const pointer at various points
>  in time to use various OF function calls."

So, we're not holding references here (we're just doing comparisons, the
references need to be owned before we get into the core) and I'm not
seeing anything here removing casts?

--cmojth4sdaU3VRJa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdICOAAoJECTWi3JdVIfQcggH/jVqi1O/AWH3tQmTsDEkFXT4
et8yGx03au/zpgWbEr+UFD5jFLTep1StgnZD5kgAmpzierEAkxbYf0/GJ68QKSzl
8zZgniyrhHsZosYwfId9d8hk0OuXLEAtX2U9F4LjPrTKOjebd/vzzaTmloaBVfXI
DlZmVYv2U3qaxDhD5tnG0qClG3ae86cSkZLKu99F4ktSmKPex5PCVn3bR/y1vwgP
2uc+n1q27Va9NF2fS3E3IJxdtJbvv1itlpTcNE7F6Z+8ydtUX3pbbSCYQbEA5Uud
V1vlEzZZvrkINEQArmho90MZPzs5ba13o/t2Bd96Rvss5vURvQSQQ10pB6BZjgQ=
=Hdvy
-----END PGP SIGNATURE-----

--cmojth4sdaU3VRJa--
