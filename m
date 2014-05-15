Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaEOEok (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 00:44:40 -0400
Received: from ozlabs.org ([103.22.144.67]:44440 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbaEOEoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 00:44:38 -0400
Date: Thu, 15 May 2014 14:44:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] of: fix CONFIG_OF=n prototype of of_node_full_name()
Message-ID: <20140515144430.11ab033b@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/UxigP4DD7CwC=XUAkFNnrC_"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UxigP4DD7CwC=XUAkFNnrC_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Make the CONFIG_OF=3Dn prototpe of of_node_full_name() mateh the CONFIG_OF=
=3Dy
version.

Fixes compile warnings like this:

sound/soc/soc-core.c: In function 'soc_check_aux_dev':
sound/soc/soc-core.c:1667:3: warning: passing argument 1 of 'of_node_full_n=
ame' discards 'const' qualifier from pointer target type [enabled by defaul=
t]
   codecname =3D of_node_full_name(aux_dev->codec_of_node);

when CONFIG_OF is not defined.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 include/linux/of.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/of.h b/include/linux/of.h
index 3bad8d106e0e..e6f0988c1c68 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -349,7 +349,7 @@ int of_device_is_stdout_path(struct device_node *dn);
=20
 #else /* CONFIG_OF */
=20
-static inline const char* of_node_full_name(struct device_node *np)
+static inline const char* of_node_full_name(const struct device_node *np)
 {
 	return "<no-node>";
 }
--=20
2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/UxigP4DD7CwC=XUAkFNnrC_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdEY0AAoJEMDTa8Ir7ZwV7CgQAJC+DHrbp8juWA80O8To80qS
jkbBBOcL/xH4c3uTcsviSv1KaRsh51nbBiuYAYtYdjrXnuhLYzjG+14TlhIb+b3d
Dy9eK+VKw+EAViEfQMI9jGxiT8AMTh+ZnnPQjmCE5gn1GXTfJEd5dSWoQb7H/tFV
yfVj5CeX/HGQryFciTzRV6VD4Blh3lBE0lgrJJSgcn6As7GG25rQgb+Rq0Sfc9li
6sfcH9wsuoVygpeupMJpROAcj3Jk4/EC8y8jbwBDlh9icYSelUfRjnjWyCd2lkgk
jJubUhchEAMrZN2n5uiuFn5QPc528B6Whv8ztCzrjy2qVEHKKHSD0MB3s0gAsGSY
Gt2FGkKmKI0IgAJIjWd1bU0CZoygFCs+LiJA8IsHH6CnbSXtFZkBZCi4fq/CBCF6
6ZK0ixse49wwcRRsihsIPVk4vs+lTUgXOV4a4fepow4w8PAslHwEzuLijbVlPc4E
c0M1y1vhyyRXazh0POkzGDgE3HIx486RPJVi9hGmD28HaClxTRj+nxxYJ+78TW9w
mJNPW+LJ0GgUG5v+pLdZm9ggkZtzWnyYnV5FliVkDemCocY24PqHv2PTfFeh/ft3
H8MAWxN1aRnDXN7rYUNdWnDkV4k/bcCF7JtTrEorJqcX0n/DHrAvqGAZihdW81Bk
BUvVDICq6qQUdunf6zGC
=SydC
-----END PGP SIGNATURE-----

--Sig_/UxigP4DD7CwC=XUAkFNnrC_--
