Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab3J3Qa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 12:30:57 -0400
Received: from sauhun.de ([89.238.76.85]:52862 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab3J3Qaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:30:55 -0400
Date: Wed, 30 Oct 2013 17:30:51 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
Cc: Peter Korsgaard <peter.korsgaard@barco.com>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] i2c-mux-gpio: use reg value for i2c_add_mux_adapter
Message-ID: <20131030163050.GI3663@katana>
References: <5257CE75.5000607@nsn.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oxV4ZoPwBLqAyY+a"
Content-Disposition: inline
In-Reply-To: <5257CE75.5000607@nsn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oxV4ZoPwBLqAyY+a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 11, 2013 at 12:09:57PM +0200, Ionut Nicu wrote:
> The i2c-mux driver requires that the chan_id parameter
> passed to the i2c_add_mux_adapter() function is equal
> to the reg value for that adapter:
>=20
> for_each_child_of_node(mux_dev->of_node, child) {
> 	ret =3D of_property_read_u32(child, "reg", &reg);
> 	if (ret)
> 		continue;
> 	if (chan_id =3D=3D reg) {
> 		priv->adap.dev.of_node =3D child;
> 		break;
> 	}
> }
>=20
> The i2c-mux-gpio driver uses an internal logical index
> for chan_id when calling i2c_add_mux_adapter() instead
> of using the reg value.
>=20
> Because of this, there will problems in selecting the
> right adapter when the i2c-mux-gpio's index into
> mux->data.values doesn't match the reg value.
>=20
> An example of such a case:
>=20
> mux->data.values =3D { 1, 0 }
>=20
> For chan_id =3D 0, i2c-mux will bind the adapter to the
> of_node with reg =3D <0>, but when it will call the
> select() callback with chan_id set to 0, the i2c-mux-gpio
> will use it as an index into mux->data.values and it will
> actually select the bus with reg =3D <1>.
>=20
> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

On Fri, Oct 11, 2013 at 02:17:10PM +0200, Ionut Nicu wrote:
> Some gpio chips may have get/set operations that
> can sleep. gpio_set_value() only works for chips
> which do not sleep, for the others we will get a
> kernel warning. Using gpio_set_value_cansleep()
> will work for both chips that do sleep and those
> who don't.
>=20
> Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>

Applied to for-next, thanks! Added to stable, too. Also, please write
the changes since last time. This really speeds up reviewing!


--oxV4ZoPwBLqAyY+a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJScTQ6AAoJEBQN5MwUoCm2OY4P/iZapF0vXWyREsVscBsWcghP
ilBJJ43af0QkUbrQWzlIhhfjfis3T1uv4YbGFdBTtVG/0cXt8G3Ncaxy/vmJbl7d
4gv33dT5uPSvvTE+LlzFiVwHRi3Epg6n7Guu+TYXUDgJ9MvYv55r4VYdzlP3Ql0E
+T2fQ1/67AaSMzlQvyEGaHxtqpSjG8WAh87f0yf8YGXPWuiJIMKjYClI+Y1m98WJ
mFP0mpdmcPoFy9pIwEhIelem98eCK04SfG9802QO22B+w8dAWkIR7gdE33PVP8fW
77zFyI0XgzhEVG+3PD8ysI8GmIoxt1TyNIFEWka1XcI1nNIypPgIb/Pj0JbF2t6q
v7HBRs6Q9rGH/kHjmoL+uxafbKa0AlOYUjUvPoIOAWQ3UsPqsOLX4At9pbVR8Wrr
UUhrlx83Gei3LtGP0lulgG/EJpbCU5MiNoUcecDrQ8KQD+GbIeN7GFHvC2v3j5GP
ORwlLJrcB8SjtLvrWOW+Qak6uQ3JWw6Yf0tPi2DEI2dalTBSaUgz3SdoLyIxouWH
tWAgmbdTxLPCX4t8x20qpDerluEjxl9sy7PGDKMARsL4j0ogdxcjDAgN9YedJ98S
iE8ll4xWE19ciXYHBfgiGYdboKbpKgSmEddK5INrqA9auNM7vn6RZoQNZvyUnkfU
yreDb/4htBpbfOyxescD
=M5/8
-----END PGP SIGNATURE-----

--oxV4ZoPwBLqAyY+a--
