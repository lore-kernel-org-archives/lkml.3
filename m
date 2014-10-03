Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175AbaJCKqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 06:46:11 -0400
Received: from sauhun.de ([89.238.76.85]:38364 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107AbaJCKqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 06:46:04 -0400
Date: Fri, 3 Oct 2014 12:46:37 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@vodalys.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        mark.rutland@arm.com, srinivas.pandruvada@linux.intel.com
Subject: Re: [PATCH] i2c: Add generic support passing secondary devices
 addresses
Message-ID: <20141003104637.GC1349@katana>
References: <1409925739-28188-1-git-send-email-jean-michel.hautbois@vodalys.com>
 <20140922104555.GQ1786@lahna.fi.intel.com>
 <542023C8.8080802@metafoo.de>
 <20140922134535.GZ1786@lahna.fi.intel.com>
 <54202E28.80500@metafoo.de>
 <20140922144144.GF1786@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20140922144144.GF1786@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > Ok, looks like there are two main differences in the two implementation=
s.
> >=20
> > 1) The ACPI one uses a integer index and the DT one uses a string index=
 to
> > lookup the device.
> >=20
> > The problem with the index lookup is that the order is binding specific=
=2E So
> > it might be different between e.g. the devicetree binding and the ACPI
> > binding. This makes it quite hard to use the API in a generic way and y=
ou'd
> > end up with hacks like:
> >=20
> > if (client->dev.of_node)
> > 	index =3D 3;
> > else if (ACPI_COMPANION(client->dev))
> > 	index =3D 1;
> > else
> > 	index =3D 5;
> >=20
>=20
> Indeed.
>=20
> > So we might need a extra translation table which maps a name to a ACPI =
index
> > and then we could use the name as the generic index in the driver.
>=20
> Good thing is that ACPI 5.1 _DSD finally allows us to use similar naming
> as the DT has been doing. Problem is that we need to support both the
> new way *and* the older index lookup somehow :-/
>=20
> > 2) The ACPI implementation returns the i2c_board_info and the adapter, =
while
> > the DT implementation returns the instantiated I2C client device.
> >=20
> > It might make sense to have both. I image that most drivers are just
> > interested in creating a new client device and will simply pass the boa=
rd
> > info and adapter they got to i2c_new_device(). In this case it makes se=
nse
> > to have a helper function which already does this internally to avoid
> > boilerplate code duplication.
>=20
> I agree. How about making that helper a wrapper around the function that
> returns both i2c_board_info and an adapter?
>=20
> > There will probably some special cases though in which case the driver =
wants
> > to get the adapter and the board info and then manually call
> > i2c_new_device() after having done some additional steps.
>=20
> Yes, if the alternative address happens to be on another bus. That
> should at least be possible with this API.

Thanks for the discussion so far! I'll wait and see if some patches come
out of it and mark this one as deferred for now.


--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJULn6NAAoJEBQN5MwUoCm2YEwP/11ViOkhThM2kLwKNS1THzCQ
L2nq9phTK5LHNRB7tKc3FWn0MYivJ5dFyxsookGEB5UpmGeYpL1cUUxwhhHNrc4W
mmNHFsknuuwnHhylHcrgp0ssrB6/I5dwN1n3EHehgGrDjc7AbtXIxXLUCszvFLxw
fwhk/qKzyFYCflZiJrWJCZE3oSlWGzw7ZNoZOLyh+xpdEVmvAAV3e4uHkltkmTuC
X1cQHA5I54FQ8C/J4/qquHhNck7ygfR5dJPFmBKeqA264FKse6IB8/f8Aql7JwKm
vFJoFxeejtJlPdvM9MtLB/2Y70l8OdxxP+uXRhkZ2y2PJu/XPm2bqW4aLaeiy28q
PUPLQj2s16A7Wjum/PRdnMs7pfcHLgb0idwj2XGknKN8Z6ez4W+P4X963sqY+4QA
VrbpoGLmxmJ9jTJ/9vaZUHA/CNwGTcWs6fMVPExczCjU7grbdrcEL7gXkGjJtu2c
bU7qa6SxgYnYi4nu1FQYbLEj9N2O2sPVoHgSoZXqqxxD2DkXsQWALeVlEYIE9GJ8
qQr2DyHFC3puHvNjdLPpNN9iis99iMqWqaliE6nIPrg5+BmIACx9AX7ET4JyaW5D
0MxuBT0BPV6Key4A9f9S3zlfczn7Qx/iq5v6uZKAoE5x8DKG0ewHBFS/hWGQu92u
qFrXhdTfZyaX0V0wd7Nr
=h8Hu
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
