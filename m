Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870Ab3B0CAS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:00:18 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:32802 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859Ab3B0CAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:00:15 -0500
Date: Wed, 27 Feb 2013 13:00:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: manual merge of the akpm-current tree with the vfs tree
Message-Id: <20130227130007.ffaca3220a5a5e87d9f50f2b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__27_Feb_2013_13_00_07_+1100_aDNaTOsWM0_SChu8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Feb_2013_13_00_07_+1100_aDNaTOsWM0_SChu8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
fs/proc/inode.c between commit d3d009cb965e ("saner proc_get_inode()
calling conventions") from the vfs tree and commit "fs/proc: clean up
printks" from the akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc fs/proc/inode.c
index 70322e1,b4625dd..0000000
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@@ -495,7 -499,8 +496,7 @@@ int proc_fill_super(struct super_block=20
  	pde_get(&proc_root);
  	root_inode =3D proc_get_inode(s, &proc_root);
  	if (!root_inode) {
- 		printk(KERN_ERR "proc_fill_super: get root inode failed\n");
+ 		pr_warn("proc_fill_super: get root inode failed\n");
 -		pde_put(&proc_root);
  		return -ENOMEM;
  	}
 =20

--Signature=_Wed__27_Feb_2013_13_00_07_+1100_aDNaTOsWM0_SChu8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRLWinAAoJEECxmPOUX5FE3w8P/3FKBsi64pmdpq6tDFQyzao7
Pd4MbzmVCGPKFrCSU13vwFZ30Pr+56+rZ5dbE8TQwKPUfMfZ2G3YW5QTyuRSco8e
Pff7dWAKPsrSfoXgXtaRktMRb9Ll79/fOTsfERVs8ae4PcLl7SnD5Fb2P+HGAkVy
txWXECPwVZdDTybIAuCGF3tRfOhQzn3OlLq2kBQdVAcPLtrJDEceqUCGDy0+WJHc
c/ExWNzmtMfL4R47k/Xj0BJbzdSQN7vDnV99ECn2GXHKJ4KPpnmsKGzOoQkqRV6t
cqzqi4ZcJUATSKVLXQpdojiMLZST6JbnM3fbImarvNaI6EorHGLvAARal3BnpCSw
YYfQ4zSsooi/o4IRRXiWZLXEVwVf+IXlhjCAkhNTCCdkp7VARMbyPglYik3pAkAA
G6FN8IGF5FW0ZcNSbwk4t5TQyqZrLPxhS07AqHHTmq6diXqMdKVPA4ZmmYUcsg6K
wVbUWxirkWcj3ducR9SI0yIJMUSgNJuCg5EhDikPoA643+U3MShdiGWRiGpTxArx
QrnBCKtTsag47S7J2R34EDWP27UgqOFRsUzaEbzPs5CR5Wf592dlkx/tD4hfjSqB
Cny37617ip95CpDmEqh9PYR4xbqW/OEn3BX/SKoKwAdUtxKvPHqN7d5T5PFwTHTS
OfnVP58UYzL3PxUwkib7
=sjGQ
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Feb_2013_13_00_07_+1100_aDNaTOsWM0_SChu8--
