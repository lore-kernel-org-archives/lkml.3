Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbaHFCwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 22:52:35 -0400
Received: from ozlabs.org ([103.22.144.67]:53208 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753763AbaHFCwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 22:52:33 -0400
Date: Wed, 6 Aug 2014 12:52:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>, Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: linux-next: manual merge of the security tree with the mips tree
Message-ID: <20140806125226.6c6e60d1@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/soj63ZE43i1fEDi5byzXE.j"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/soj63ZE43i1fEDi5byzXE.j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next merge of the security tree got a conflict in
Documentation/kernel-parameters.txt between commit fd1bb4c9fc2c ("MIPS:
Document the cca=3D command-line parameter") from the mips tree and
commit ffb70f61bab1 ("KEYS: validate certificate trust only with
selected key") from the security tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc Documentation/kernel-parameters.txt
index 00d5a756152b,90c12c591168..000000000000
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@@ -566,12 -566,11 +566,17 @@@ bytes respectively. Such letter suffixe
  			possible to determine what the correct size should be.
  			This option provides an override for these situations.
 =20
+ 	ca_keys=3D	[KEYS] This parameter identifies a specific key(s) on
+ 			the system trusted keyring to be used for certificate
+ 			trust validation.
+ 			format: { id:<keyid> | builtin }
+=20
 +	cca=3D		[MIPS] Override the kernel pages' cache coherency
 +			algorithm.  Accepted values range from 0 to 7
 +			inclusive. See arch/mips/include/asm/pgtable-bits.h
 +			for platform specific values (SB1, Loongson3 and
 +			others).
 +
  	ccw_timeout_log [S390]
  			See Documentation/s390/CommonIO for details.
 =20

--Sig_/soj63ZE43i1fEDi5byzXE.j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4ZhvAAoJEMDTa8Ir7ZwVYggP/ji+an3f8dVJQORCwfmEI2wp
KtLKSnZOZ1VreqUGqcXfsd7KQuoR+/LKSbeC8Dv4ZjWcXAsU4pMec8vPE3JuPYMg
F2NJ9vZvKRsmZyap6I8m3iwHABjWDl610Xi+F7x9tNTcBBJzS8+N68nQclfSZnJT
zhnU5NIiVOvffF9WE5HecWGXQ7cEeI4aKqGVKCQvR/sepTfiSJ3+NFpvnJiDmXFy
uclT6LePLl46eDCyBU0o8JEr3pYt/nhe2oY87TZDCUM0d4l/LKqZLdRRUccgZIVs
CAbYp0E1XMw90uY7RwF+iSss3YA1n0a/zVUgI23bEU7wll8tAOtgUjLDAr2dvMd/
tBWZdCP73JjR5biBZgvUzMNTA9tM4BIfnuHt0mVdi8gcqaEAkcZLwu1Bodj4mt7u
eQ9S7trbVeNIsQoKtr7LwWXYnmkctE6WUYuF5baxvFLfqBxer3ckpd44Dmjl4fWW
GHWK/qZWIhQ7eE9VgYtSaKUbZejWQUXVOOeGIhZ6Z6+qSqvOPVS9NUq/lnVcvJtL
U5JE0F/1mB+wE2IQyE4ySzVvbgPhdq3U0Ts4k1IVdVApRN5g7Q5No9AtjTVQPkzE
oJUbW0pCN4/8OhChbkrb8Mso2nH4dpESx+O3s0v91ooXDeAyJ9ARFRf0Fyo5Flss
OIYrMY6PCvihMWqTk343
=BefD
-----END PGP SIGNATURE-----

--Sig_/soj63ZE43i1fEDi5byzXE.j--
