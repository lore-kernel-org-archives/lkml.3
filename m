Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbaEOFeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 01:34:12 -0400
Received: from ozlabs.org ([103.22.144.67]:54615 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbaEOFeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 01:34:10 -0400
Date: Thu, 15 May 2014 15:33:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Amos Kong <akong@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] virtio-rng: some small tidy ups around kmalloc
Message-ID: <20140515153342.14a5d34b@canb.auug.org.au>
In-Reply-To: <20140515153140.49b8028b@canb.auug.org.au>
References: <20140515153140.49b8028b@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ewr4rQ8xjK_ZXhr/uZyaM1j"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ewr4rQ8xjK_ZXhr/uZyaM1j
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Include slab.h for kmalloc/kfree declaration and check the actual
allocations succeed.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/char/hw_random/virtio-rng.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/v=
irtio-rng.c
index 6319b133b7aa..73d7fc42d1a7 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -24,6 +24,7 @@
 #include <linux/virtio.h>
 #include <linux/virtio_rng.h>
 #include <linux/module.h>
+#include <linux/slab.h>
=20
=20
 struct virtrng_info {
@@ -97,7 +98,13 @@ static int probe_common(struct virtio_device *vdev)
 	char *name;
=20
 	vi =3D kmalloc(sizeof(struct virtrng_info), GFP_KERNEL);
+	if (!vi)
+		return -ENOMEM;
 	name =3D kmalloc(40, GFP_KERNEL);
+	if (!name) {
+		kfree(vi);
+		return -ENOMEM;
+	}
 	vi->hwrng.name =3D name;
 	init_completion(&vi->have_data);
=20
--=20
2.0.0.rc2

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ewr4rQ8xjK_ZXhr/uZyaM1j
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTdFG6AAoJEMDTa8Ir7ZwV/pcP/j+LaTorXu88LHXy92M570fr
1/SW1EUESb2y5DLbNCO2O3h/CFX3yqmcG+KYBSSxdpeqH7/7vPytzXr5N0/59GHs
LifVkHMBjmSDgBgJVT2DokBKeudTeDu9/zU1pCAlbrunKEhTz+WiDtPbbLWChv1C
Lu8iCqk7XtMqsi5EkcMICRrx0CpGbwO54sEpuEyuCM1e9l1rAlhVdODQlBW2cSLb
hEm/D9eGbNMLVORrit+aDVvWYO0j6DhzxpVE849Id0+lSnOiZBxG3METsx8ciW/G
lwjxfZdxy65D716gXX/OFkX0AmKxCwLex1lhD/oOIqymiyYGj7UO2xnJIbc11vrB
QbAO2f4U2uF/THvJKnWhXshcyCQjWdBTW2BT2OJJyuHbl8ZTRUWQxTYoIckzvm+G
5raElw64BjBwyv7clc2F2FVJG554BuhhmJjfXvhOt2VhrTSEVEQjW22lOzuiFOeh
p/4IGBgAijbEkYBUEvik39X5VzVKWwULTqHQo9j/xkzC0TO6ynViVrCID9hAiwxS
mLe50uEnPjfrAHIXX5C4ihmXw+ovr+72Su+UPjaGkPYpn7zpaig27fqu57gaYiIU
NJ1bZV7DTDRcAAOTFSLvfTdqbee7OtGeuS6V8tpIIK3mNACtLkGrcl5TEjzN503j
fWCnMvSimWTDJWDgXEu+
=TYkq
-----END PGP SIGNATURE-----

--Sig_/ewr4rQ8xjK_ZXhr/uZyaM1j--
