Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935261AbaKNQxc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 11:53:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:33406 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161065AbaKNQxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 11:53:31 -0500
Date: Fri, 14 Nov 2014 17:53:24 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tony Lindgren <tony@atomide.com>, Pali Roh?r <pali.rohar@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, khilman@kernel.org, aaro.koskinen@iki.fi,
        freemangordon@abv.bg
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141114165324.GA12250@earth.universe>
References: <201411052137.31452@pali>
 <20141105203918.GA29199@amd>
 <201411052206.05379@pali>
 <20141105220359.GA32052@amd>
 <20141105234555.GA7097@earth.universe>
 <20141106124711.GA26944@amd>
 <20141106180335.GA21513@earth.universe>
 <20141113162155.GA8512@xo-6d-61-c0.localdomain>
 <20141113174534.GO26481@atomide.com>
 <20141114073756.GA5336@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20141114073756.GA5336@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 08:37:56AM +0100, Pavel Machek wrote:
> I'm using nfsroot (no modules), .config is attached. Debian v7.7,
> ofono installed.
>=20
> To launch ofono, I'm using:
>=20
> rmdir /dev/cmt
> ln -s /sys/bus/hsi/devices/n900-modem/ /dev/cmt

At least with Debian as base you can add this to your /etc/rc.local
and be happy, since the link will be created before ofono starts via
/etc/init.d/ ;)

I did not send ofono guys a patch to use
/sys/bus/hsi/devices/n900-modem/, since the kernel is supposed to
handle the PM, so there will be another, simpler interface (I plan
to use pm=3D2 for that).

> killall  ofonod
> sleep .1
> ofonod --nodetach --debug &

or just use "/etc/init.d/ofono restart". The above is mostly useful
for getting debug output from ofono.

> [...]

The short description for .config: CONFIG_NOKIA_MODEM must not be
disabled. It should depend on everything else needed:

CONFIG_PHONET
CONFIG_HSI
CONFIG_OMAP_SSI
CONFIG_OMAP_SSI_PORT
CONFIG_SSI_PROTOCOL
CONFIG_NOKIA_MODEM


-- Sebastian

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUZjOEAAoJENju1/PIO/qafiYP/iuHB/im26FmFvUT+RxPkuIt
3pbxDcdCaRtr/5m5NLuHWBv6NH9qRT3y9bYjmsKFCEykYm25LNq/yIYIUdNv6UM8
xAvCxpAntt9oCSVdqWBiqKD9HAc3hj1vqBdn2FbVEBNiCtTpTCMn1DNHgMtlZzyt
BQuq612eGeGVba20sRtswM3aVAktzbn3nw46YP1IUhasnD/6+BfgoVHebeJBUu6W
PaK5S0bIFjyQ04qN18ea9hDaa7Spa2qz4T9uHUZO8RzelQZnNpkVYQfEKe+BDEel
3wUGg+NLK/w2NUspzkZVx39s8U/ePSxMfPQMx7ta3mFGj0AlTzGI0qLR/RQc4otC
0nbdGFdTMC2UZLAfZl9Am2FweE/PuY4EMNPLb75b/8fS4CVNA/+ObCRse00f1d58
kyle/gewxZoce3YhKSkdWPYZHtRV+O54p5D3jFPJGWu+KPI6zAvDpSuk4vMXPa/A
DfIKDUN2kKJ7OIFvSqtOVLpMQ1KUOwhZPxlawU5VruDAYgjIBvD8HVAHSVAm3dne
kvXhS9FYm8luUCjpp8NrjybnQF6EFMODBo/codYVutNVGaOQ+DbdVHKz063L1psJ
WA2Qq1ZjKAANX3mKbsqMQmHiy30qsNih9N2ZIe9K9xp3u70frFI4lhVp6yWGLtLG
/zYp14EHFS17XmpiE6Z0
=SQ8H
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
