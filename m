Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757848Ab3KMCFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:05:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46582 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab3KMCFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:05:25 -0500
Date: Wed, 13 Nov 2013 13:05:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <jbacik@fusionio.com>
Subject: linux-next: manual merge of the aio-direct tree with the btrfs tree
Message-Id: <20131113130507.b4a99df2f2c2a860bc320bab@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Nov_2013_13_05_07_+1100_KUgmAW8=PQr2cebe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Nov_2013_13_05_07_+1100_KUgmAW8=PQr2cebe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the aio-direct tree got a conflict in
fs/btrfs/inode.c between commit 0ef8b726075a ("Btrfs: return an error
from btrfs_wait_ordered_range") from the btrfs tree and commit
921057174f1c ("dio: Convert direct_IO to use iov_iter") from the
aio-direct tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/btrfs/inode.c
index da8d2f696ac5,6feae86d24df..000000000000
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@@ -7234,10 -7233,8 +7247,10 @@@ static ssize_t btrfs_direct_IO(int rw,=20
  	 * call btrfs_wait_ordered_range to make absolutely sure that any
  	 * outstanding dirty pages are on disk.
  	 */
- 	count =3D iov_length(iov, nr_segs);
+ 	count =3D iov_iter_count(iter);
 -	btrfs_wait_ordered_range(inode, offset, count);
 +	ret =3D btrfs_wait_ordered_range(inode, offset, count);
 +	if (ret)
 +		return ret;
 =20
  	if (rw & WRITE) {
  		/*

--Signature=_Wed__13_Nov_2013_13_05_07_+1100_KUgmAW8=PQr2cebe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSgt5XAAoJEMDTa8Ir7ZwVD34QAIW4tsOZ1moR1hnX7AnjqGWG
fOxSxprxBbwKav4vZ1Gx+VTQmMnxuKEgq7NYcVD1AleGo8wfiCVk1EMEKJrK/0Cy
h8OBlsG9K91yT3fEpGQJ5eNKF5VnZcjYRGqEQFNNtd/0qL8KLNyjfP+yUf2Jv2lo
tZIjRcl6Ot+yh0T9bwtQ1tRZygKV/btHpdOdlykXTHZBSwzkO2MYYWWQkoVXfBrq
zdk+QDp34NsiMNvHMhf8+bl+6x2GYZTU2I4fn9H1kc/kj9APdjAIxCKDHZk+VxGJ
TJiJGoaQRmOxZMgum1Q1NclUA19PgQvM6bvOL824pZkuEMxncxz/KQs3UDMgVDwC
zI6+8NgXkyUkyuPb3Xkuu1AdG1e9kgsky5ddELqQen3N56AA1pxISxSVKfttlO+C
tRLnC2tPPYDRUe41aY1V/i7paiOdVLpJdNGxyo5ODtqXbBXjylWHBk12TnpmtM56
kPmG/ITTh0/kM24NgqJQSTkCpeXECuPJ6HQIbBJZHtbV1MG6HWHmRlzFDShgMbTu
AK/EB4meVxYSGCz2NqCKwzm2gFfeInsUggaZHVp+kTj6tJkuFikA+k73UqQLJibm
nJq5r2bvQ0Wpg6Tvc48NBkaHavgJbR5oaKjvTdBNCnQ0150Zctk9GWDK1QWLQNYD
ESh4C2C7smlP/l3koEpn
=5HuB
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Nov_2013_13_05_07_+1100_KUgmAW8=PQr2cebe--
