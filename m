Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965Ab3FRFp3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 01:45:29 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42313 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3FRFp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 01:45:27 -0400
Date: Tue, 18 Jun 2013 15:45:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: linux-next: manual merge of the irqdomain tree with the  tree
Message-Id: <20130618154515.828365d615bbe6b93169e706@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_15_45_15_+1000_kyU8PQTMQm4tDb.5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_15_45_15_+1000_kyU8PQTMQm4tDb.5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
kernel/irq/irqdomain.c between commit c5cdc67a58a2 ("irqdomain: Remove
temporary MIPS workaround code") from the mips tree and commit
bd4641e31e90 ("irq: fix checkpatch error") from the irqdomain tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc kernel/irq/irqdomain.c
index a341b3d,13f2654..0000000
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@@ -665,8 -475,20 +475,8 @@@ unsigned int irq_create_of_mapping(stru
 =20
  	domain =3D controller ? irq_find_host(controller) : irq_default_domain;
  	if (!domain) {
- 		pr_warning("no irq domain found for %s !\n",
- 			   of_node_full_name(controller));
 -#ifdef CONFIG_MIPS
 -		/*
 -		 * Workaround to avoid breaking interrupt controller drivers
 -		 * that don't yet register an irq_domain.  This is temporary
 -		 * code. ~~~gcl, Feb 24, 2012
 -		 *
 -		 * Scheduled for removal in Linux v3.6.  That should be enough
 -		 * time.
 -		 */
 -		if (intsize > 0)
 -			return intspec[0];
 -#endif
+ 		pr_warn("no irq domain found for %s !\n",
+ 			of_node_full_name(controller));
  		return 0;
  	}
 =20

--Signature=_Tue__18_Jun_2013_15_45_15_+1000_kyU8PQTMQm4tDb.5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRv/PvAAoJEECxmPOUX5FERSEP/A9HFMnUvVaXPGPmf9hFHzv2
b+H0cXxnWDjFlq/dXUZmnxv2hmL/oEx1ZmkHAr3by1X9FJ1OkaMVFgb9ecc+oC24
Id3iGBTHjmCwsqob+4cRyeYJ/5pwLjxKhglHeKuZ8SDsRqLIIUc6ApZHSjJwHyDA
/gQCZ0n11pq/RMi9s5LcetSDuK6BkCKGGaiJ1LR9NJ7LJ+EQ68gXxLgQeggx1xOJ
kVSB4NxSo8G18fhbgVSrcN0wNHs9I8siBvgfIYdn5Qu20he9TLepd/N+XfwsU4kM
NIR5+ag8sDVxYh4uS8aKVb5gmpmPtFE6kMI4Eqx+v3xmJ2xvXmm/mF4BMusWBNy+
O6f0CwVUVG64CsjewF0dfA+OFOosgOiFMiJ9kOCr9aQ09utKyukDZGw+xXEaCf0N
+MosZYihyH8Yh6e9OZtH7ydceKlVMh4gJizG1ZNPkjFfjQQetqZA7BP1iulfi6aK
y0mKRzVZFtVdlKDpbdsnM3WwYR+XKMDGXCtivAGEvoOCGeRS85nLHnK3ARhLSbjk
6xcP7zpzNl515bkqXcZgI9IJ3nfIh6hVeYEMt3rAHSJS6ifQUV9WL2V/C9c8a+Gk
S2SoR/2iUQxKuX6hFJDTGwnX4G2xsf3tXEgfPJHfjzR4Us7tYu1z5Rp36wZvTUhF
TZol188Z9LEsAH2HGvS0
=ujxc
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_15_45_15_+1000_kyU8PQTMQm4tDb.5--
