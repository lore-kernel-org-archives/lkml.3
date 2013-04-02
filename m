Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759967Ab3DBDRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 23:17:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:61000 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759353Ab3DBDRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 23:17:50 -0400
Date: Tue, 2 Apr 2013 14:17:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: linux-next: manual merge of the virtio tree with the rr-fixes tree
Message-Id: <20130402141739.0d0b45f519be505a7da471ac@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Apr_2013_14_17_39_+1100_Bg6sJc_xXjuk0_k8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Apr_2013_14_17_39_+1100_Bg6sJc_xXjuk0_k8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next merge of the virtio tree got a conflict in
drivers/char/virtio_console.c between commit 9ba5c80b1aea ("virtio:
console: add locking around c_ovq operations") from the rr-fixes tree and
commit 6797999d9958 ("virtio_console: use simplified virtqueue
accessors") from the virtio tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/virtio_console.c
index ce5f3fc,6d59f16..0000000
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@@ -570,9 -569,7 +570,9 @@@ static ssize_t __send_control_msg(struc
  	vq =3D portdev->c_ovq;
 =20
  	sg_init_one(sg, &cpkt, sizeof(cpkt));
 +
 +	spin_lock(&portdev->c_ovq_lock);
- 	if (virtqueue_add_buf(vq, sg, 1, 0, &cpkt, GFP_ATOMIC) =3D=3D 0) {
+ 	if (virtqueue_add_outbuf(vq, sg, 1, &cpkt, GFP_ATOMIC) =3D=3D 0) {
  		virtqueue_kick(vq);
  		while (!virtqueue_get_buf(vq, &len))
  			cpu_relax();

--Signature=_Tue__2_Apr_2013_14_17_39_+1100_Bg6sJc_xXjuk0_k8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRWk3TAAoJEECxmPOUX5FEmXwP/Radxu4t/N68pKe1mmz2tbOF
sXDS/1fOaYajWWcE+LaNXZR26qndpBUaSaSW4llg0iGbB0TEYQx+o1nZaRfVQmmi
VghfxQvc4CVjypkH1BQkk4r+Q3Gfc6rB0ZM9H3DHadRjdjYSTe0ljznWKSgv0uKQ
gUkj42Kbakwc2brudjz4POIEzkgS6v0quVjwwPqwj2PK3SmBXm/9Dyt14WYbU/65
1I/zkZFxzmGqnrlzPDqa15/AzBIomPVpM3xORDASnLiKHpn4xNNYZ/qtfrxQ7Fes
yHDsyUzdIzd99RSTI3UBCmWgSkVQu0bh9Gog0olvm5rZoJq1flokV5JLxkyCiLrG
70Wimgs9i83QJsYeubH0QLo3I2yJ/HcMwtIutJ1kacVHpSUZwA8AzzfrXmEvqMUl
5DsMp6I1wRi6bRkj9M9mEO/rdF++mB/kqBOlwnhBhZxpY2v4vcPs8BMVFA+H7X//
Tt8fsbwBGpjjnpIlvHWlrzSDCVcQZ7Xu3BHBCe8eSrITg8vwdn1U5Ixmr8iKTnr7
Ie8i1QsN7PS6er1PjhkpZtrqKwlZ83xQrndZaX88lpFqWH24xM7V3/hXt/RCi7Oa
YX3n34ZMT1s7eV5cuu2l2IXJmjiyAVM4R7WueeGXNDj6WAFqyTf4a5SpKb4aR4uP
AG8Zg9b4x/Na1xHFwLAN
=IinT
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Apr_2013_14_17_39_+1100_Bg6sJc_xXjuk0_k8--
