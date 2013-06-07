Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab3FGExd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 00:53:33 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50102 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751779Ab3FGExa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 00:53:30 -0400
Message-ID: <1370580807.4021.73.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 097/184] Bluetooth: Fix incorrect strncpy() in
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Anderson Lizardo <anderson.lizardo@openbossa.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo.padovan@collabora.co.uk>
Date: Fri, 07 Jun 2013 05:53:27 +0100
In-Reply-To: <20130604172134.330397379@1wt.eu>
References: <20130604172134.330397379@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-AouGhxGzD19NEkP6fqHx"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AouGhxGzD19NEkP6fqHx
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-06-04 at 19:23 +0200, Willy Tarreau wrote:
> 2.6.32-longterm review patch.  If anyone has any objections, please let m=
e know.
>=20
> ------------------
>  hidp_setup_hid()
>=20
> From: Anderson Lizardo <anderson.lizardo@openbossa.org>

This is missing the upstream reference.  It was commit
0a9ab9bdb3e891762553f667066190c1d22ad62b.

Ben.

> The length parameter should be sizeof(req->name) - 1 because there is no
> guarantee that string provided by userspace will contain the trailing
> '\0'.
>=20
> Can be easily reproduced by manually setting req->name to 128 non-zero
> bytes prior to ioctl(HIDPCONNADD) and checking the device name setup on
> input subsystem:
>=20
> $ cat /sys/devices/pnp0/00\:04/tty/ttyS0/hci0/hci0\:1/input8/name
> AAAAAA[...]AAAAAAAAf0:af:f0:af:f0:af
>=20
> ("f0:af:f0:af:f0:af" is the device bluetooth address, taken from "phys"
> field in struct hid_device due to overflow.)
>=20
> Cc: stable@vger.kernel.org
> Signed-off-by: Anderson Lizardo <anderson.lizardo@openbossa.org>
> Acked-by: Marcel Holtmann <marcel@holtmann.org>
> Signed-off-by: Gustavo Padovan <gustavo.padovan@collabora.co.uk>
>=20
> [backported to 2.6.32 jmm]
> Signed-off-by: Willy Tarreau <w@1wt.eu>
> ---
>  net/bluetooth/hidp/core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
> index 49d8495..0c2c59d 100644
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -778,7 +778,7 @@ static int hidp_setup_hid(struct hidp_session *sessio=
n,
>  	hid->version =3D req->version;
>  	hid->country =3D req->country;
> =20
> -	strncpy(hid->name, req->name, 128);
> +	strncpy(hid->name, req->name, sizeof(req->name) - 1);
>  	strncpy(hid->phys, batostr(&src), 64);
>  	strncpy(hid->uniq, batostr(&dst), 64);
> =20

--=20
Ben Hutchings
Theory and practice are closer in theory than in practice.
                                - John Levine, moderator of comp.compilers

--=-AouGhxGzD19NEkP6fqHx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUbFnR+e/yOyVhhEJAQoTEBAAwIH8/IQ8q8QQHcQqOKrKAFLIebQmOvoI
TD2lyhayJZFVqjuonMzmS/rsTb8KbNlTyrXgc+IJjOLvMXXycpr1MdK60XTb7wcQ
SoUiaeGfOB9FhUuQw7P725nGP9lI/93g4DT/LsqfGhhPUBbPvosFF96Fm9cMabVB
0h5wK24P0/H8QgdYzgxMp/smIzxsru1AptMJ3oqneBbb/tZiP/gfsG9vznGLreai
9MFf0HWh4dHC/8ar8m2+0sXSuK2avGghNR/+SsdeIAkkiUz74McxxxUzP+pxZPD6
Z4aMZC2MA6ufaZ8WDNzGL3QFSrvN+E6Q9rpcThq/vwTlMfHX5PcXgJlZypGRUla8
U5Sh7i8zxmgpxdmLxVy4NpgWBgAIGMPZFKOEzY6+tMuW0Aie9Tx1uFaKK85FbbMx
r62fFCPyJFdvbqc6bVGg/48iZ2QIrqCp6V1bLi6nTnQWnol0Kxjm2kyRUwk4g3B/
kSAq8/mXqTRGzE3WmyqhXIbBN4UT9c/0fjthIt3dlISaMU8UUI83yV0X23bzsCrv
a0N8EQglO3M9J/qqwcssQCSsIqFYv2VqIYvbwKFjE8JpFeY8s3fF6/nQ+ne+cWOo
3qKGZCFegMKv4SyuG1EAKZhvFfct3nY9jeHynDsXKQL7PxLd/AYmAzzkTIWvHPJS
w8v8D/rmtPo=
=TDnK
-----END PGP SIGNATURE-----

--=-AouGhxGzD19NEkP6fqHx--
