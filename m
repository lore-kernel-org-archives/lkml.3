Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756010AbaA2DqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 22:46:17 -0500
Received: from ozlabs.org ([203.10.76.45]:55176 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236AbaA2DqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 22:46:15 -0500
Date: Wed, 29 Jan 2014 14:46:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        =?UTF-8?B?IlBhbGkgUm9ow6FyIg==?= <pali.rohar@gmail.com>
Subject: linux-next: manual merge of the akpm-current tree with Linus' tree
Message-Id: <20140129144600.772e7be42998c947203146b1@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Jan_2014_14_46_00_+1100_xuo5PaKfDKlNgGpO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Jan_2014_14_46_00_+1100_xuo5PaKfDKlNgGpO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/afs/proc.c between commit b42d570c9fbe ("afs: get rid of junk in
fs/afs/proc.c") from Linus' tree and commit 1a3459681f5c ("afs: proc
cells and rootcell are writeable") from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/afs/proc.c
index bddc5120ed40,276cb6ed0b93..000000000000
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@@ -130,9 -147,13 +130,9 @@@ int afs_proc_init(void
  	if (!proc_afs)
  		goto error_dir;
 =20
- 	if (!proc_create("cells", 0, proc_afs, &afs_proc_cells_fops) ||
- 	    !proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops))
 -	p =3D proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_p=
roc_cells_fops);
 -	if (!p)
 -		goto error_cells;
 -
 -	p =3D proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &af=
s_proc_rootcell_fops);
 -	if (!p)
 -		goto error_rootcell;
++	if (!proc_create("cells", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs_pr=
oc_cells_fops) ||
++	    !proc_create("rootcell", S_IFREG | S_IRUGO | S_IWUSR, proc_afs, &afs=
_proc_rootcell_fops))
 +		goto error_tree;
 =20
  	_leave(" =3D 0");
  	return 0;

--Signature=_Wed__29_Jan_2014_14_46_00_+1100_xuo5PaKfDKlNgGpO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS6HmFAAoJEMDTa8Ir7ZwVmO4QAIxEhdrS+2GhJCKNtHF59oy8
9j+6EUKTvklQf08o2SNS/WBw9D8ZBeEieUxsurB8sLRRIcs/AS8/KrCf40JuMOYe
6XeweO4IHopJIsvGq5A7L841IgXLKhuVdLuHBzoh/aSKuDGZmCklFTjcKTBE0W4j
HgD3hYi3WNDwI6ToMNb4n7x7D00ZLyVVirup+j7nyh+8yO3cmt3Mj55IgY/LnnLs
rX9jNJStG8ges1AlKNbny34XPTkPlROPaL6RteIAv5UYsvvPp1TsvABpibc1AdgU
hRjjsDk358+5E2O+KeYfTD5NY9qWnDQJnU8hhmrQ8le6J4v/VOjRyC+af9P8gGOW
An+Ga811uVrCSBEqnmBcn3JkQSdEnPvScxzBS5CVNnjlepJBAdTiB8kdbCNv4v6r
Sqfmj5+5eW54+nNziJc0yZxW92zHrMYz74lNi/sNz2Ek7pYgOEUBzyO4eSFJ+FRV
kDpCmDkb6XcTeA2K0HndcGDD/Cye+mGMkDFoChcm8RrOrqmQPZ/uciatjtHLZgiB
ILqeZx0SExCx+tpvZPNOc3ShnBO1/Q8eQS5atc1xUd6k7Wn6eNcVu6b2hD94FErC
Ymx95YwUH5VhlL5L3MDqqEtTe8jDV0qLZPlDdRGV1dumnUZXwSN5fLnl2EYpEzZY
EV+RqbGcq86hSUpX/PlT
=n5f5
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Jan_2014_14_46_00_+1100_xuo5PaKfDKlNgGpO--
