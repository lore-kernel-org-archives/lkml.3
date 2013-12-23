Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab3LWD0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 22:26:00 -0500
Received: from ozlabs.org ([203.10.76.45]:52406 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756497Ab3LWDZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 22:25:58 -0500
Date: Mon, 23 Dec 2013 14:25:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Grover <agrover@redhat.com>
Subject: linux-next: manual merge of the target-updates tree with Linus'
 tree
Message-Id: <20131223142550.2a138347235da28ee0f51e96@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__23_Dec_2013_14_25_50_+1100_USUHAyXBNz3UYcO4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__23_Dec_2013_14_25_50_+1100_USUHAyXBNz3UYcO4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Nicholas,

Today's linux-next merge of the target-updates tree got a conflict in
drivers/target/target_core_tpg.c between commit de06875f0896 ("target:
Remove extra percpu_ref_init") from Linus' tree and commit d344f8a15637
("target: Rename core_tpg_{pre,post}_addlun for clarity") from the
target-updates tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/target/target_core_tpg.c
index 2a573de19a9f,d1df39a05d88..000000000000
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@@ -656,9 -658,15 +656,9 @@@ static int core_tpg_setup_virtual_lun0(
  	spin_lock_init(&lun->lun_sep_lock);
  	init_completion(&lun->lun_ref_comp);
 =20
- 	ret =3D core_tpg_post_addlun(se_tpg, lun, lun_access, dev);
 -	ret =3D percpu_ref_init(&lun->lun_ref, core_tpg_lun_ref_release);
 -	if (ret < 0)
 -		return ret;
 -
+ 	ret =3D core_tpg_add_lun(se_tpg, lun, lun_access, dev);
 -	if (ret < 0) {
 -		percpu_ref_cancel_init(&lun->lun_ref);
 +	if (ret < 0)
  		return ret;
 -	}
 =20
  	return 0;
  }

--Signature=_Mon__23_Dec_2013_14_25_50_+1100_USUHAyXBNz3UYcO4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSt61CAAoJEMDTa8Ir7ZwV6ugP/jbUMpuEIkV7eLv3XkyAWx7F
upikEBzbydG/GvUni3HajobSqlp1SDDipae40Ib+scYPcTAdPE1Iec+yOQeorfOG
wJnC1N+p3H2lxiQU0PYE7W9ZMqUoXOPaA8Qieqt/uckZbfM1BuVuRa1681zyNWsP
e/1UECvLRaQoYLK+B/9laqHxECorDyWrJiLKH3OdchRfldVasAblO4n3xq9i8qTx
eWXkdLCNq/ao7jIROrFNXsjkiuVbbF8+msW20nxXXJrbkXA9F2DuGG7zkJhXUMub
TDxY/RwbSaKuLPqaXo7vTmwNhVyoTuDiLXkNm9ZsJpYXvcZ0gjMX08G7o9ZKsQrk
36XkY7Es7FsXN0hMEQmdkv9HJf/6UR539aRCw+iciWyGPBJupcqUXlhtaDPQIxKR
I6lX0vVgfS9zq013blQ9dF6qa+nYFqz+yPsSb7nif+UK1CuPQaUk998VcfHfxu5h
saWQmv16A6vZ0b24nzO0CgIdEA4D9hciqn4/AP9hdmvwPhfTBsoTHge3NCgjiPXO
30ALVJpz3wl1vITR8+3RfEPUDkkod+Qi/7Ztk1c1uFFqn3uhNfGs943a1pG7UWD9
xFt/fDlf+AYOpiWiUawi1J2wT0SBJ7UGKmZQXpHggzaNNrrwrUqYOo2grrn7FJRh
cy4/l5N1XnE7DNSi5RnE
=mP9n
-----END PGP SIGNATURE-----

--Signature=_Mon__23_Dec_2013_14_25_50_+1100_USUHAyXBNz3UYcO4--
