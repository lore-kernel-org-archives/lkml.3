Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757935AbaKUEFS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 23:05:18 -0500
Received: from ozlabs.org ([103.22.144.67]:52360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757438AbaKUEFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 23:05:13 -0500
Date: Fri, 21 Nov 2014 15:05:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Rob Herring <robh@kernel.org>
Subject: linux-next: manual merge of the devicetree tree with the
 devicetree-current tree
Message-ID: <20141121150506.3f7b873d@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/8RKq390i=WoXzF1Q1tMmG=e"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8RKq390i=WoXzF1Q1tMmG=e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/of/address.c between commit 746c9e9f92dd ("of/base: Fix PowerPC
address parsing hack") from the  tree and commit a0212ae0be5b
("of/address: Don't throw errors on absent ranges properties") from the
devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/of/address.c
index 06af494184d6,78f02f65fc48..000000000000
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@@ -490,10 -475,12 +490,10 @@@ static int of_translate_one(struct devi
  	 * This code is only enabled on powerpc. --gcl
  	 */
  	ranges =3D of_get_property(parent, rprop, &rlen);
 -#if !defined(CONFIG_PPC)
 -	if (ranges =3D=3D NULL) {
 +	if (ranges =3D=3D NULL && !of_empty_ranges_quirk()) {
- 		pr_err("OF: no ranges; cannot translate\n");
+ 		pr_debug("OF: no ranges; cannot translate\n");
  		return 1;
  	}
 -#endif /* !defined(CONFIG_PPC) */
  	if (ranges =3D=3D NULL || rlen =3D=3D 0) {
  		offset =3D of_read_number(addr, na);
  		memset(addr, 0, pna * 4);

--Sig_/8RKq390i=WoXzF1Q1tMmG=e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbrn2AAoJEMDTa8Ir7ZwVTCgP/277IrqoCyfS6FIHOSAkrsrG
kGRkFSRSHfPVUCmWYYE4S9KyVXM9RQl8cSdBlK1Fgd+03EiEVmNUfs8QIn33yUXV
WTAbwTDAXeSeTxvsGjc8h/BXpSfhapcAYlrtLL/doyPuyN2hUM2pDtZW4/X/wSEO
2mw2i1iUfLN8Nj/T/LqvMtFLlg/u2TjaeLlPjKnk75ixTEwCfMLBPgG3APIirRWg
E548LX4+T67kzt+7p//UML0Z+vJTmIwrG/G5kVZIQ7FDw96PHIcbCtJNaoG5NCcA
b15WTJKZ0PkugYo0pZFNQ7w9UQtA+WbkdLS0QQbl7LfX8VxOJ13d9+UIty1ESlEz
oyBW8UMMfH+4lczfUqjNURlOyt+GftsyPxqwFJvCimCINlBN3+IYgMay/tnDIt6t
v39XPOVLT9+m2e/8C/1XHY1AeJS8V+jJkdSXxom6CO/kOrgZydD+5sg3mStV/kTp
UBC69ulK1NRSjHNBtC8Zzg5bXA81Omvn9mHjhPlZ88TNXyfK/DKyBLle+dIJeOoS
SIUp20jNO9nF/yiS+dugBDQXTAcW5iMdW77GBHX0npGwz4OOqcet5Q0YoovjY7ih
0hDFXQG8T2CW9VQHi8e3aEMQG2qhYTArpiGnKU8RGGdZfu2LUcDJB5Ryhx+do6pS
eBtscWIezIvinGESQDkC
=6DuM
-----END PGP SIGNATURE-----

--Sig_/8RKq390i=WoXzF1Q1tMmG=e--
