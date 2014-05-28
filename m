Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbaE1CHi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 22:07:38 -0400
Received: from ozlabs.org ([103.22.144.67]:49585 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911AbaE1CHg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 22:07:36 -0400
Date: Wed, 28 May 2014 12:07:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfsd tree
Message-ID: <20140528120728.2bce9521@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/Io+ayc36Y16Us68S.PMbrBc"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Io+ayc36Y16Us68S.PMbrBc
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Bruce,

After merging the nfsd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:


fs/nfsd/nfs4xdr.c: In function 'nfsd4_encode_security_label':
fs/nfsd/nfs4xdr.c:1945:15: error: 'pp' undeclared (first use in this functi=
on)
  __be32 *p =3D *pp;
               ^

Caused by commit 8ea0abf0a992 ("nfsd4: use xdr_reserve_space in
attribute encoding"). "This is a cosmetic change for now; no change in
behavior" :-(  They are the ones you have to be very careful of ...

I have used the nfsd tree from next-20140523 and for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/Io+ayc36Y16Us68S.PMbrBc
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJThUTlAAoJEMDTa8Ir7ZwVbi4P/0JnIVS3XQ8K3kIJXNqA92gy
243kIh7rmAJKAD6u4cB6c9xTdOxhzTpGEMly+PP9nGyzdglp3+/H9g3KUnZdncIZ
FVTtegZS9JZ6iR1+nBJcyy0yGe4AFLMxIc0sEQd3AFsOEHIQcKBqTliZI9ABm7lG
YXoFsXYTi0s23Jh6O86+wHp6Z+GYXHHSfJvh1xxVDCzX0R3av4KbnCKSKlHD+3sN
VOKhOLXpyF3eptCgPGddfquolcJXxD7o4MI3IKLy2Rf91tufhWL8boIxqd3YiuyM
Jgqw2kQY2cDyf+/e9vSd6CL7EArsE/krzWqF9wdcNuTzF81VPk8ubdwMZNeyVwIH
3kpQdzP8/+7dWSocql0FibiLv+VuXkbauTtJpbgEZVNVPHBI3vcXODlVieW9b4Cf
u2Xlhr7O0UmS0PF9dp+r8iYd7eO2lld4EncGUrYtc9oAS4Vl6LUHPYda/KPPaOzc
yXiCKwLYOdNw4I9Un2toggSSYtlMZkF6MIJ/GHaWGvhspJR4a812zVAsC7x9Rg8I
cTKlNLVwjJ6OflOnnEuFfLeIl5bQ/VDXmKx+Zx7nqgHa/8KtBw/n6ACcZs0/T4zJ
ct1Sk5mmVI52iqRbppNQa8hEo1MDmC9DkRn37fa8S9IQD6sv+870MXtUJy18VcNH
hT9FZTv+36A94kS/T4uE
=DoIs
-----END PGP SIGNATURE-----

--Sig_/Io+ayc36Y16Us68S.PMbrBc--
