Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab3K1IOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 03:14:42 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:44631 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3K1IOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 03:14:40 -0500
Date: Thu, 28 Nov 2013 09:13:53 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stefan Agner <stefan@agner.ch>
Cc: swarren@wwwdotorg.org, sameo@linux.intel.com, dev@lynxeye.de,
        mark.rutland@arm.com, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kai Poggensee <kai.poggensee@avionic-design.de>
Subject: Re: [PATCH 0/3] regulator: tps6586x: add version detection and
 voltage tables
Message-ID: <20131128081351.GA26502@ulmo.nvidia.com>
References: <cover.1385508112.git.stefan@agner.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <cover.1385508112.git.stefan@agner.ch>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 12:45:42AM +0100, Stefan Agner wrote:
> This patchset adds version detection for the tps6586x mfd family. This is
> required because some regulator versions use different voltage tables. The
> regulator driver now uses the right voltage table according to the
> version.
>=20
> The required voltage for the SM2 converter on the Colibri T20 is 1.8V,
> however, the device tree states 3.7V right now. Newer versions (>=3DV1.2)=
 of
> the Colibri T20 module use the TPS658643, whereas old ones (<V1.2) use the
> TPS658623. Both of them have a different voltage table for SM2. The
> current device tree contains a voltage which results in 1.8V for the older
> TPS658623. Since the regulator driver has correct voltage tables for both
> regulator versions now, we can request the correct 1.8V from the device
> tree.
>=20
> Tested on Colibri T20 V1.1 and V1.2.
>=20
> Stefan Agner (3):
>   mfd: tps6586x: add version detection
>   regulator: tps6586x: add voltage table for tps658643
>   ARM: tegra: set SM2 voltage correct
>=20
>  arch/arm/boot/dts/tegra20-colibri-512.dtsi |  4 +-
>  drivers/mfd/tps6586x.c                     | 41 +++++++++++--
>  drivers/regulator/tps6586x-regulator.c     | 97 ++++++++++++++++++++----=
------
>  include/linux/mfd/tps6586x.h               |  9 +++
>  4 files changed, 110 insertions(+), 41 deletions(-)

Adding Kai Poggensee on Cc. There was a variant of the Tamonten board
with one of these versions of the chip (or maybe it was even yet another
one).

Thierry

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlvs/AAoJEN0jrNd/PrOhxGoQAILCaV106mkH4E+n3s6k7uBA
D50v7aWnVyQjKs8SWpiBsy1OtDc0Ji1D0eVUDE4XA0NtIfIaL3WoNXGk+umkhdT0
xswjdxMChP9UQr/Tm6yVjSrA66C95CjUVQmTVLn7vrnuy9zlmJQdwi5XBjP1WtFN
ZzX9acVNnBBp0omwbhggIZGE9awD6Gtgja+uElgZT/5FYWrHKOPYbQqWTGZU7jYk
6q6UtTu9ItYjr2TPi/MkBxwyhGIKBpCDY6EX7ajo/7omUhR43UajKHXNrZ9a+Kim
Kx6jaPvHR0ymKAT3SIajycMdBuy0ZW/VbkQpPxpvSDHcKaneqmS2sT+6NaR3Cgyy
o8dB06kSEduKFBOAv6zaM9Io3JAA+W5Xt7nCqpuoQIezpU/tA9uq/LlxwJeLvv0R
yFpmuc3HZYkgkZXNNA4sGThjnYxY3bqcGiQvfib0zOtugU9PWjJfrUsxtj3uO240
alBRP7bVdwn+ICcxUwCg1TWLp9CBN+htzxQkV5FJYIGyVNhyiVTqgY0iGoVaZN89
AyZ6dTjuYEGf/kk6mQaJorkSTS2sWUZc0m+TJMIr69TDE0Ubwl6A2l8ACC831g/K
FBVDIn4PP+meoN7ZnlvyuyxMglrOYbqWi6mluVPBRwTxFY2nlozRNVeeE9UnAIJ+
vzXgnaXT6hGA1VdEneUi
=DGa3
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
