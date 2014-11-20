Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbaKTDu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 22:50:27 -0500
Received: from ozlabs.org ([103.22.144.67]:45708 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753096AbaKTDuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 22:50:25 -0500
Date: Thu, 20 Nov 2014 14:50:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the devicetree tree with the
 devicetree-current tree
Message-ID: <20141120145016.19160b8b@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/_Qvz6Dk5iHeMy2SR+/A0eGH"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_Qvz6Dk5iHeMy2SR+/A0eGH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the devicetree tree got a conflict in
drivers/of/unittest.c between commit 817d2001c709 ("of/selftest: Fix
testing when /aliases is missing") from the devicetree-current tree and
commit 5063e25a302e ("of: Eliminate of_allnodes list") from the
devicetree tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/of/unittest.c
index ae8b75904104,082bb2b6a5ad..000000000000
--- a/drivers/of/unittest.c
+++ b/drivers/of/unittest.c
@@@ -853,19 -858,20 +858,23 @@@ static int __init selftest_data_add(voi
 =20
  		for_each_of_allnodes(np)
  			__of_attach_node_sysfs(np);
 -		of_aliases =3D of_find_node_by_path("/aliases");
 -		of_chosen =3D of_find_node_by_path("/chosen");
 -		return 0;
 +	} else {
 +		/* attach the sub-tree to live tree */
- 		rc =3D attach_node_and_children(selftest_data_node);
- 		if (WARN_ON(rc))
- 			return rc;
++		np =3D selftest_data_node->child;
++		while (np) {
++			struct device_node *next =3D np->sibling;
++			np->parent =3D of_root;
++			attach_node_and_children(np);
++			np =3D next;
++		}
  	}
 =20
 -	/* attach the sub-tree to live tree */
 -	np =3D selftest_data_node->child;
 -	while (np) {
 -		struct device_node *next =3D np->sibling;
 -		np->parent =3D of_root;
 -		attach_node_and_children(np);
 -		np =3D next;
 -	}
 +	/* Make sure of_aliases and of_chosen are up-to-date */
 +	if (!of_aliases)
 +		of_aliases =3D of_find_node_by_path("/aliases");
 +	if (!of_chosen)
 +		of_chosen =3D of_find_node_by_path("/chosen");
- 	return rc;
+ 	return 0;
  }
 =20
  /**

--Sig_/_Qvz6Dk5iHeMy2SR+/A0eGH
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUbWT8AAoJEMDTa8Ir7ZwVmQUP/i/F5x1K8Ws2PdfoWFdOhmwK
i1B5R3NxVxc6ku2bHsBFAh+Jvd8NP0X6SMPhM92PtBJNOZweLZ3autoHhftkQQo/
nK1HUeCRrdu067eR8ZNRjB63smbgs/7tTpnyZt1upfmM5jWBvf+PYr0US4C0azpI
ulnSbWcZkkGNyw+y42VdsnHzabFw1BvbALdB6MK54QLb9uxcMP6v+nPc6iNXPuKF
lSeGBfhZfDMgsGdzH5izpPhoUJy0pUKzBUpuilYWXeqBGHtbbEibK6Mqd4QhSFOq
EAXQ1KkEf/ZocsAISktU7GF0xsRoDqTQqH3NK7KuhBSPeknEweKZg1Qhp9bOQyzP
oB1alXMPr8D7REVUm+VeCnZxYG2L/lxfb/WcmsHt9cnL+5AE7u4incH1k51ezVJG
LBX3oM7WUTHKgRN0r7Qazs6maMtrOqEMXePdOrUSyrKNxEdK2dd/Z8LxgzBH9n4+
lY5u4s6ZkvxkBRp7VpYFgDfvhlnduTnB/XZfKMzR9xfrmoQaluJ5jva7cHaP85yn
GBilJfZCvhiE4a7cewrLfupJUHrpIhq4juLJLPSj6mKLKqJVat+lCm6Kj4VUOxzP
w9igRQ1GDTdg/A3aIGlJBZknZBfdIaFDsCanoMPQIJFeEgdjTUhK5Fm++rpjNyOu
vBJZwvxMVw0FQirQDr0k
=kQwB
-----END PGP SIGNATURE-----

--Sig_/_Qvz6Dk5iHeMy2SR+/A0eGH--
