Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaFMFRV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 01:17:21 -0400
Received: from ozlabs.org ([103.22.144.67]:57380 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750886AbaFMFRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 01:17:20 -0400
Date: Fri, 13 Jun 2014 15:16:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140613151652.69bb6961@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/S.itoS1wE4mYrbk5B0niN5n"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/S.itoS1wE4mYrbk5B0niN5n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm-current tree, today's linux-next build (x86_64
allmodconfig) failed like this:

mm/memcontrol.c:6674:3: note: each undeclared identifier is reported only o=
nce for each function it appears in
mm/memcontrol.c: In function 'mem_cgroup_move_charge_pmd':
mm/memcontrol.c:6906:37: error: 'ptl' undeclared (first use in this functio=
n)
  if (pmd_trans_huge_lock(pmd, vma, &ptl) =3D=3D 1) {
                                     ^

Caused by commit ce1c26c7ca47 ("memcg: separate
mem_cgroup_move_charge_pte_range()") - uncovered by my previous reverts.

I have reverted that commit and commit 2fba70f78e45
("memcg-separate-mem_cgroup_move_charge_pte_range-checkpatch-fixes")
that depends on it for today.

Which lead to:

mm/memcontrol.c: In function 'mem_cgroup_count_precharge_pmd':
mm/memcontrol.c:6674:3: error: 'skip' undeclared (first use in this functio=
n)
   skip->control =3D PTWALK_DOWN;
   ^

Caused by commit 7170d5e9623b ("mm/pagewalk: replace mm_walk->skip with
more general mm_walk->control").

At this point I got fed up and just dropped the akpm trees completely for t=
oday.

Was this stuff really meant for v3.16?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/S.itoS1wE4mYrbk5B0niN5n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTmolNAAoJEMDTa8Ir7ZwVzjYP/i+QPlcDgq3rFA59G6/9l39d
btB2K7BFphLQt6WS/wUFBXmkeR6W8zRZvUZzBx0yGpElODOHS0PDq+QvKItqDrNC
YZQX1eTlpDuir58Y2wFvRFFFnzmyN7mdzc+Jaf1tQd3JWfZWPfk8W+g+fiP8uXU8
Fx9xgv2oIuZjspkxcz66Z/sqHTtFHWgYYpjoYUEfNotiQCq5MIdjbtgHptnO+wQ6
iScJ5fZ2xQlEhLItHIYOxe7GvPHXy206/eSjvylfKr8VZVFA3vJpCAuxgFPWb67I
aBdwYm+nzZGJUZvr5BMOVQieW99kWgwoXsQhy3tzUT02dMcZbBDAPz2r6D3oczBQ
+CO26XQHUgWo7oTZOlYZ0OePSLgKalH1ENY1NIN5plbFtlPBydlRSlvxN3WYv9XS
mnlN/jWqeAX00gpeOMx6dlF714uTy5ycTXj6cXDJud6tOqTenAgSs0qGu6XlX+f2
M96EfcNrX52X2MzsGKcCkOdFYH9pWSkqGpep4CGshy1IM4iLTGBv3EwhdRCNOD8u
d+ooHgN1qJsXv5UjwGRTRC/zXN+AEr+IvHus9wtbFxIKzOMRHfzRtK2WFyoVOsMW
+jYNJeDtqrMJ9X4YFh5NRfQhzoXAQr79kydg5JRF6LlFSBUF4wtaxOEbi/Y/OBaW
XcR3fN1HhoevTwyvSZsr
=vYnd
-----END PGP SIGNATURE-----

--Sig_/S.itoS1wE4mYrbk5B0niN5n--
