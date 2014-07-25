Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759956AbaGYJV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:21:26 -0400
Received: from ozlabs.org ([103.22.144.67]:51823 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaGYJVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:21:15 -0400
Date: Fri, 25 Jul 2014 19:21:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>
Subject: linux-next: build failure after merge of the security tree
Message-ID: <20140725192102.1ed8f391@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5YEmx5QNUFBW8d/aiDryuPU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5YEmx5QNUFBW8d/aiDryuPU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security tree, today's linux-next build (powerpc
allyesconfig) failed like this:

crypto/asymmetric_keys/pkcs7_key_type.c: In function 'pkcs7_preparse':
crypto/asymmetric_keys/pkcs7_key_type.c:36:2: error: implicit declaration o=
f function 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
  if (IS_ERR(pkcs7)) {
  ^
crypto/asymmetric_keys/pkcs7_key_type.c:37:3: error: implicit declaration o=
f function 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
   ret =3D PTR_ERR(pkcs7);
   ^

Caused by commit 22d01afb210f ("PKCS#7: Provide a key type for testing
PKCS#7").  See Rule 1 in Documentation/SubmitChecklist.

I have added this fix patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 25 Jul 2014 19:17:04 +1000
Subject: [PATCH] PKCS#7: include linux-err.h for PTR_ERR and IS_ERR

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 crypto/asymmetric_keys/pkcs7_key_type.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/asymmetric_keys/pkcs7_key_type.c b/crypto/asymmetric_ke=
ys/pkcs7_key_type.c
index c2091f7bd15d..8605ff6cf869 100644
--- a/crypto/asymmetric_keys/pkcs7_key_type.c
+++ b/crypto/asymmetric_keys/pkcs7_key_type.c
@@ -10,6 +10,7 @@
  */
=20
 #define pr_fmt(fmt) "PKCS7key: "fmt
+#include <linux/err.h>
 #include <linux/key.h>
 #include <linux/key-type.h>
 #include <crypto/pkcs7.h>
--=20
2.0.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/5YEmx5QNUFBW8d/aiDryuPU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0iGIAAoJEMDTa8Ir7ZwVfsYP/jGW8rzpTPkw2rSHAIXp5CCp
WjT39nYYZ1xTP8l1khqVhlAwU3rDtyDESc14tCTDXnNa9UM/YIDGZCl8bEIbJC/y
wPxUK1VxiYSsHpBfqLvITboA1KlKwhqjcv/cCMqY92OSMyLgTPcV6ARGEHpgA91U
mm5fOieSBGJftxah5K9mke60ZUQodSsobyLTi4IUQ0d8g2nbpVMfbczYlSB69H5F
4j9ILg0ZPr9Zp7wNj2RtqGGjW0ykKzDKJcn7KJQG6+QiqJZqGhy6jL8udlmNOTgt
aGOWv+DM/uFgZXDSXYFtuIHhR1ohpoFji9xNxEKYmvkMof+viVmt8eQnjsyKMUpI
pgWvDkyHiuRhEoROgY+7vO/UrxPb6s6vDg4g6t3FTzDJqCCNkb3uDCHI0yaVN6En
mHinfAWE2QlvcVkU/oje8I/HfQHy7w9cQ0wk/h84x7zx7HtT9P9Qe+LXL66TJvwX
50Oaj31wUrJwL+3T6xv+xmnBVfm1lrCDqqJvnV0PeuC0E7hn6uX4GncHWrogVy53
WSKnp/ZqynSYwHtJroik044e/fvHRTqqRKth4EIAfF2Zp/HIWcpCpN0+lLj1+vNI
N//cPxDlzQsMD7l1xWZyb4gs3hDNPAxzOrG3mnlzv9KVkXiu8wmLgXnhcbTxEBdZ
DJ489a7CMjzicV9xSCuD
=Hh2O
-----END PGP SIGNATURE-----

--Sig_/5YEmx5QNUFBW8d/aiDryuPU--
