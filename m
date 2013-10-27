Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab3J0VyV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 17:54:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:59357 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755388Ab3J0VyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 17:54:20 -0400
Message-ID: <1382910856.2994.51.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH 7/8] rds: Pass pointers to virt_to_page(), not integers
From: Ben Hutchings <ben@decadent.org.uk>
To: Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, rds-devel@oss.oracle.com,
        netdev <netdev@vger.kernel.org>
Date: Sun, 27 Oct 2013 21:54:16 +0000
In-Reply-To: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
References: <1382910437.2994.43.camel@deadeye.wl.decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-80YuffHdy/BwCL6uL+by"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.2.102
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-80YuffHdy/BwCL6uL+by
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Most architectures define virt_to_page() as a macro that casts its
argument such that an argument of type unsigned long will be accepted
without complaint.  However, the proper type is void *, and passing
unsigned long results in a warning on MIPS.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/rds/message.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index aba232f..1913fc9 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -257,7 +257,7 @@ struct rds_message *rds_message_map_pages(unsigned long=
 *page_addrs, unsigned in
=20
 	for (i =3D 0; i < rm->data.op_nents; ++i) {
 		sg_set_page(&rm->data.op_sg[i],
-				virt_to_page(page_addrs[i]),
+				virt_to_page((void *)page_addrs[i]),
 				PAGE_SIZE, 0);
 	}
=20


--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-80YuffHdy/BwCL6uL+by
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUm2LiOe/yOyVhhEJAQrn9A/+IrG6+cmRsnwMPVCG/j2GRnJ3fhTYL3Hq
HZbxTKojCDfzLvlLrOVd+Mggtk8QCZXfZQrrUnz9/wUfysoGQEcQ/0Z1iVR7vEC7
K7ouGl3FbEJnIdGG376aSZJjN+OZ6hA1o/ue9F5tE09lu0Dw/8Snrs+9gFyIZEf1
stw6KoVPDQ5eI7HuHdbhiaT6yPLAoelQa3xIe7q+EIuoLOGs7DgXqv3A26VSMAOC
VdsJdRv+nxPo0fVzJpOHrJQz3Cz8J/+BF+FB6L+3x4lHiUQQlIH51LuPggiLe/fG
yO0hvP5EDOcWhWHKWu6W1XE1J4O0rZ0DbajNcBzpWjlYIYy4SQ+sLdjvj3V1wf4Q
K5dqd8xyef1ZTG5VdPCG2lwSMgLDvNWJ1G1IP1JC5IhWoSgqzl90Hrp+P2boMgL+
1k60Agz3zyDgJENZq8gCvn5FhGElCFiTWvxzduwafGIcaW4PXCj+RXQJEmEC/R92
L5x/M6Jnd8HeSr9kKjVci6yr/oXpKGu72LTH5xzKR8eif3TF9e4Lxe34KfZNDZaY
EF78S/9mrBzvLPqb+FGrS3/4mFySx/k0fQAwKPIbznhELr3BgyHezUkHNr3d5ZQl
j4vf/Na/Q9dWhr7wweKANSs89ttERqEA25vR0y/nk6G+JgokmbSRI3dnpLJd2qe4
XPhJu9cWh4I=
=yOzY
-----END PGP SIGNATURE-----

--=-80YuffHdy/BwCL6uL+by--
