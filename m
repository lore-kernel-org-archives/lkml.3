Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab3BDDGw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:06:52 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40318 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826Ab3BDDGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:06:50 -0500
Date: Mon, 4 Feb 2013 14:06:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Subject: linux-next: manual merge of the security tree with Linus' tree
Message-Id: <20130204140641.076d7621651d346448fc58f7@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__4_Feb_2013_14_06_41_+1100_N9+k/iDxKIEb.chS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Feb_2013_14_06_41_+1100_N9+k/iDxKIEb.chS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
lib/digsig.c between commit 7810cc1e7721 ("digsig: Fix memory leakage in
digsig_verify_rsa()") from Linus' tree and commit 26d438457ed1 ("digsig:
remove unnecessary memory allocation and copying") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc lib/digsig.c
index dc2be7e,0103c5b..0000000
--- a/lib/digsig.c
+++ b/lib/digsig.c
@@@ -162,13 -152,9 +152,11 @@@ static int digsig_verify_rsa(struct ke
  	memset(out1, 0, head);
  	memcpy(out1 + head, p, l);
 =20
 +	kfree(p);
 +
- 	err =3D pkcs_1_v1_5_decode_emsa(out1, len, mblen, out2, &len);
- 	if (err)
- 		goto err;
+ 	m =3D pkcs_1_v1_5_decode_emsa(out1, len, mblen, &len);
 =20
- 	if (len !=3D hlen || memcmp(out2, h, hlen))
+ 	if (!m || len !=3D hlen || memcmp(m, h, hlen))
  		err =3D -EINVAL;
 =20
  err:

--Signature=_Mon__4_Feb_2013_14_06_41_+1100_N9+k/iDxKIEb.chS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRDyXBAAoJEECxmPOUX5FESBgQAJ8SRDnb2sCO62ZgwIUIMGGl
C7h+x2w5hpwkJCr4yg20gf1rqe//F+uEU1b2/SuFBQ6Yy5LrfIER17Xtv0erqUzS
wW3SdtmAMYN4EEb3atZMRI/Me9CGqTghuHJf20DXF53UAXrJ4osCBUKXPGEijH9D
iXSxGjCGDH72kPSeHwNwqwDejXCz1Og25HcCR3ciFRgIBeSzxGFHWTnQteb4GRxJ
VI4ymjAy5KaGd2d9xGOjArJeCS9skpEAu+VBSl7Enuo+DFB+buTKWMmKQ8ct9cSS
Hvpj2ZqdxR5fYLXlsw5quMwhhtIaMCrX6CB2OT4dPJmEu7XPlxKbvH1QAh4F7fZD
Wtz2sOURfAjcaXSF82j91bNgN8+RGtYzXmRAEA7L6m4d6iZrGWxwWT5j7+ZW0e82
zmBPpVJ2Z9PQES6E3R8asDz/gnRpNH/pw7JLXSjYL3G4+m85dtzMT4vo15aBw/8B
1VJexiYIB0qNkTdcOv8VzGzWrjCS0yrF87ptglRhwhmMB1qVHBvkOzbuYz3M5jgI
ao6a7lD9fdrOHtK5iu1//ASngehYXxDjbyDxDggAYq+k32eXNB/eDJZ4I/pHFOkB
hmerO88GDOk5Shzp90lU7lv6WeGOlyct+cKxcxwwZJDuMFZS7EhkOl0U0hRIrYIp
yji5rUXsjZJKNuQH4xrE
=qjoU
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Feb_2013_14_06_41_+1100_N9+k/iDxKIEb.chS--
