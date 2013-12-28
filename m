Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3L1PyR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 10:54:17 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53772 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754677Ab3L1PyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 10:54:16 -0500
Message-ID: <1388246039.26981.87.camel@deadeye.wl.decadent.org.uk>
Subject: [PATCH] firmware_class: Fix the file size check
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 16:53:59 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-FQnqVILPGx7o2DLZVGwp"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 151.217.234.213
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FQnqVILPGx7o2DLZVGwp
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

We expect to read firmware blobs with a single call to kernel_read(),
which returns int.  Therefore the size must be within the range of
int, not long.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -270,21 +270,21 @@ module_param_string(path, fw_path_para,
 MODULE_PARM_DESC(path, "customized firmware image search path with a highe=
r priority than default path");
=20
 /* Don't inline this: 'struct kstat' is biggish */
-static noinline_for_stack long fw_file_size(struct file *file)
+static noinline_for_stack int fw_file_size(struct file *file)
 {
 	struct kstat st;
 	if (vfs_getattr(&file->f_path, &st))
 		return -1;
 	if (!S_ISREG(st.mode))
 		return -1;
-	if (st.size !=3D (long)st.size)
+	if (st.size !=3D (int)st.size)
 		return -1;
 	return st.size;
 }
=20
 static bool fw_read_file_contents(struct file *file, struct firmware_buf *=
fw_buf)
 {
-	long size;
+	int size;
 	char *buf;
=20
 	size =3D fw_file_size(file);

--=20
Ben Hutchings
Kids!  Bringing about Armageddon can be dangerous.  Do not attempt it in
your own home. - Terry Pratchett and Neil Gaiman, `Good Omens'

--=-FQnqVILPGx7o2DLZVGwp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUr70F+e/yOyVhhEJAQou1w/9Gp/54xRrWOR5mVki+8lYLzdUFWv35qMo
1ukDkIKlIxcuM8lX+Tvhw6GjW/BLS4FPHnp3gDECjFxPvQa4VONjsCfFsK22CpzG
oXeIiD192T/eZ2eaK4wG72I+I/p5lgBqIJT+bfo88nbgE+edp8KcMOv2FzBAg1IT
jKGSOwWTe4ETd6+o0YMSs8OnwuEmx/Qw/aoC08QYkitoLOtoTVCiBmtUtXCr74vF
N/Z0jTx8KYyky+UqfgcRnpCfaKVPSODnCCoTtSe46X4Sb528ZCmurmwZoASC+htO
Ky46E7CLPcp0L3RDQSNT+AThOq598v01/bbKEgyqG8VcTOofQQ1ZVufczrrpYZul
rA8LEAXs0LDUGFmucz5nnmX2vkVIwVyRHBGWscn3INYPO7WwhGONUeVga/UUr8iq
DFKdupJKcW9yZAOQo7aVIHfz+/8kfRomSGYb0ecioxzASbYxGI8u9x8/20wQppyT
kEGJknBNVx3xu01jcArQlBsxBG6z2xJc/ynb5/LxQK8h9pdhDgieoEmSQr/j87mY
nXa5B6ktBg27ysjzkr+H5TwEtJPS7fY78yVoqyuB31559PSSo3s8ulgOvtl+8MAj
gD2hUfNICgXRNIfMUAwRiWLDaBvJ363StYYY3ahcvGukxzZA+uH2//0GntH4IdPa
4wa/nKY1FWA=
=bpLh
-----END PGP SIGNATURE-----

--=-FQnqVILPGx7o2DLZVGwp--
