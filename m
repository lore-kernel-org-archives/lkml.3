Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaEOFeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:34:10 -0400
Received: from ozlabs.org ([103.22.144.67]:39584 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaEOFeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:34:09 -0400
Date: Thu, 15 May 2014 15:31:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amos Kong <akong@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] virtio-rng: cope if struct hwrng.name is changed to
 const
Message-ID: <20140515153140.49b8028b@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ey+Q_2BD200qr1PaOic8wMb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ey+Q_2BD200qr1PaOic8wMb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/char/hw_random/virtio-rng.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Based on the current virtio tree in linux-next.

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/v=
irtio-rng.c
index 12e242bbb0f5..6319b133b7aa 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -94,9 +94,11 @@ static int probe_common(struct virtio_device *vdev)
 {
 	int err, i;
 	struct virtrng_info *vi =3D NULL;
+	char *name;
=20
 	vi =3D kmalloc(sizeof(struct virtrng_info), GFP_KERNEL);
-	vi->hwrng.name =3D kmalloc(40, GFP_KERNEL);
+	name =3D kmalloc(40, GFP_KERNEL);
+	vi->hwrng.name =3D name;
 	init_completion(&vi->have_data);
=20
 	vi->hwrng.read =3D virtio_read;
@@ -117,7 +119,7 @@ static int probe_common(struct virtio_device *vdev)
=20
 	i =3D 0;
 	do {
-		sprintf(vi->hwrng.name, "virtio_rng.%d", i++);
+		sprintf(name, "virtio_rng.%d", i++);
 		err =3D hwrng_register(&vi->hwrng);
 	} while (err =3D=3D -EEXIST);
=20
--=20
2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ey+Q_2BD200qr1PaOic8wMb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdFFAAAoJEMDTa8Ir7ZwVpk8P/1w09Qx8pFezuBTEdEzUrRoC
4U2IdqQDNazWg+7rxaRRul1pPLfH0vEeHjUGCX8Jx9jBEZ8HzKAfcGJ7fK+cwgWs
l2digEVGLireoZIlF0XvhKgOL12X5LWpe3f20T6TuZ7JmGRzmLaUxalJnGVC5f2S
ykuFpDmLFWiDn0+SBA9yYXMUR+89aSmFlafppZe+2OgiRmgQJidRSO2K1g33tqAK
FXYDlMMSwhQ2uq+/0ODfKh8I8xDySA26MYsLcgppclidLu7UMDEFU9ae2Sj927mo
prdKaukCA9R51fGx1bPcQmOIUNn8X/Lwf99ZojQQoM33+7aCr7jUTG2xZX7DJwx9
uzeaNfKV1ti3K8q4I8c92Wvewlfvb9xWwkqh9n9FN8jA4uuGX8XsJjxFiyrDYBsm
lnNGu1OmIKbHlA9FeEKtUGIC/1gSDverA9/64O2pqsn4hjHRKd+sR//o4dYvgSO0
piE4Bu9rjedyM2nx+jSzmxgo4Za7WYrXgjYhaUvaqEzXUMPj7N/oZ8zwDdxQYkAu
2hyU4ScnRCVutxUJ9aKfLJtyO3JGXnWu8k5VsHO1Q2VrScwgjweTvq8NsHeW1rwf
eX0ZPNJuswoxkkGkRJ3sjykcMPLn4L1IpsX7s4hQuadOs7QEFUszZAsAKkGmC/ef
E6+W8FJRKf57lSl9+lVi
=8V6F
-----END PGP SIGNATURE-----

--Sig_/ey+Q_2BD200qr1PaOic8wMb--
