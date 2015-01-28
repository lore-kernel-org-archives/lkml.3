Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbbA1BCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:02:23 -0500
Received: from ozlabs.org ([103.22.144.67]:41156 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932361AbbA1BCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:02:20 -0500
Date: Wed, 28 Jan 2015 12:02:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>, Daniel Borkmann <dborkman@redhat.com>
Subject: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20150128120214.3307aed8@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/v5QETUCmRZ_IMpURaH4AOKB"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/v5QETUCmRZ_IMpURaH4AOKB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net-next tree got a conflict in
net/sched/cls_bpf.c between commit 7913ecf69e24 ("net: cls_bpf: fix
size mismatch on filter preparation") from the net tree and commit
33e9fcc666e2 ("tc: cls_bpf: rename bpf_len to bpf_num_ops") from the
net-next tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc net/sched/cls_bpf.c
index f59adf8a4cd7,1029923f9e86..000000000000
--- a/net/sched/cls_bpf.c
+++ b/net/sched/cls_bpf.c
@@@ -179,12 -179,7 +179,12 @@@ static int cls_bpf_modify_existing(stru
  		goto errout;
  	}
 =20
- 	bpf_size =3D bpf_len * sizeof(*bpf_ops);
+ 	bpf_size =3D bpf_num_ops * sizeof(*bpf_ops);
 +	if (bpf_size !=3D nla_len(tb[TCA_BPF_OPS])) {
 +		ret =3D -EINVAL;
 +		goto errout;
 +	}
 +
  	bpf_ops =3D kzalloc(bpf_size, GFP_KERNEL);
  	if (bpf_ops =3D=3D NULL) {
  		ret =3D -ENOMEM;

--Sig_/v5QETUCmRZ_IMpURaH4AOKB
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUyDUbAAoJEMDTa8Ir7ZwVuRAP/ie41nenjL9DDo2tInUFgOUo
JHndd8fflr3OD8YYxe/n6gmH3e2OvD6x+aSddf1eIinEOQBUxn6e6KgubJkACBol
N1Ngqe/3UW0lg3I5RiXa8bW1JHgZ1P6kRcpzcZewQLKVRFlE61Xtu3ZvViRJfTGM
q6EX3MiW8Ix8EeLQrguwT+ZzkzzD+h9Sh1UJ0COK89y77rYEa7/D3o7wehkn8ske
10EaORLlQ5S9xsUyeUmZs4sB5IRokCYobsnXnOmBpyTLutwvAxIlO5jPDXk/LH+T
az9/7cOGfrPvgRNNU5QF34IP2ra6iVroqAsi4xEDOxR+QqHpDU87NRSAoZfWZKIq
338wyepUn7GDeB4VBjdOHpcBYvuKnFiO9+sggV+zQgFq6X+hmmROaqH6m4iMbhsw
U2o+5BJOXuIxXzEmYmgD/CN+dnJBGbSvX8QgC1NA9hzs814d86MZstYyHoAkxKET
PybimCeF11GkGvQtvcNEfgXZb8NiKMBgeHCJYNp/5ioBf59+yUGXvJ6ZdN3VzoLd
oaj2Fkoyg1jj1XTK0v7QeUKDNItfhr61Z5XJWW/D1g9yvnJxFbqjc0M7VSMEEFkB
eQirXrF5wE701c1LQFxBbJ1vK7BPaqy1arSvg16yM45yDOlI0DHyed3I+OoiHCF+
WO2DkQXuuD/luwVmbhtX
=6kyK
-----END PGP SIGNATURE-----

--Sig_/v5QETUCmRZ_IMpURaH4AOKB--
