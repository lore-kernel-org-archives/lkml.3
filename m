Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab3BTFvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 00:51:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:60604 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756539Ab3BTFvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 00:51:17 -0500
Date: Wed, 20 Feb 2013 16:51:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?IlNqdXIgQnLDpm5kZWxhbmQi?= <sjurbren@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        =?UTF-8?B?IlNqdXIgQnLDpm5kZWxhbmQi?= 
	<sjur.brandeland@stericsson.com>
Subject: linux-next: build failure after merge of the modem_shm tree
Message-Id: <20130220165109.6263fb39deb8d761d0c63e5e@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__20_Feb_2013_16_51_09_+1100_Qm3AAUMDo3foTC_B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__20_Feb_2013_16_51_09_+1100_Qm3AAUMDo3foTC_B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sjur,

After merging the modem_shm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/remoteproc/remoteproc_virtio.c: In function 'rproc_virtio_new_vring=
h':
drivers/remoteproc/remoteproc_virtio.c:234:16: error: 'struct rproc_vdev' h=
as no member named 'dfeatures'

Caused by commit 624f8ef43b6c ("remoteproc: Support virtio config space")
from the modem_shm tree interacting with commit 414a13c3d236
("remoteproc: Add support for vringh (Host vrings)") from the virtio tree.

I applied the following merge fix patch and can carry it as necessary:

=46rom 66e8d9a9dc648db6abc27b7e9b6d99840b25642f Mon Sep 17 00:00:00 2001
From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 20 Feb 2013 16:47:58 +1100
Subject: [PATCH] remoteproc: fix for dfeatures change

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/remoteproc/remoteproc_virtio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/remoteproc/remoteproc_virtio.c b/drivers/remoteproc/re=
moteproc_virtio.c
index 33ca91f..dba33ff 100644
--- a/drivers/remoteproc/remoteproc_virtio.c
+++ b/drivers/remoteproc/remoteproc_virtio.c
@@ -231,7 +231,7 @@ rproc_virtio_new_vringh(struct virtio_device *vdev, uns=
igned index,
 	rvring->vringh =3D vrh;
=20
 	err =3D vringh_init_kern(vrh,
-			       rvdev->dfeatures,
+			       rvdev->rsc->dfeatures,
 			       rvring->len,
 			       false,
 			       vrh->vring.desc,
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__20_Feb_2013_16_51_09_+1100_Qm3AAUMDo3foTC_B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRJGRNAAoJEECxmPOUX5FEQnwP/2TXV0C3zDSkeY8NC4rzqa+Q
lW0CNueIWsBZEC0Ey+tMr9gxLuqQINJbfd4wqhe5ARdohWegHyvw7S1tVxzgZaEZ
rt9Al3BDT9kOU5BV0pglLrb3QP5EWkL4OPfHR8Ga2bMGf9lkFyxnHtw+Gz3wfk4v
uD2+b5HM+9Zm41jEDtd8dq0AmMaglXTUmDc4DU8Xoo8w7lzBy0b76CoDTX/PX+Sx
tshwBQ1oZyBoO3GyfmxKXh5PXJ0xHJb/S2jA0z89rLVeZk+WN+FE8ByPQ36UXgTS
2Rry9PCdBwXn6mzF6eeHWyDSKJri0UGE2TubXKxx089pgqKDh0dqyLiPcp1JZ3EU
IKeeFp+RgDSVv5APEYSPTOHPBkfhc3XnXFNyw8xHvvNsUpqG3/5UQpraaWu+UNf2
X6YnqIB/4kEfRByzumlkGgv0Kibp1pnp4EgEAbiai7CN13jixfazajZs8UYNkcOk
1LEvUDwuYMTM9RLb4uOBYyquxdqZVeAY7AjuaO6ym1OFedgRsLAN4C4Aq6AzWjmR
gRqPOxWEwY/kBwiDc8HkewxyO5fuPee4rEZ3JZSsE9wc7Haw+aVc4WUENAikn6hX
t1P30jkwXQRAwCYQoBZWpb2Wp0/+tTkdeSOT6FxttjPXBkrHyiDiQUr1qD04zNUc
bwcvqp08/kZ++KWkbzxK
=KWUB
-----END PGP SIGNATURE-----

--Signature=_Wed__20_Feb_2013_16_51_09_+1100_Qm3AAUMDo3foTC_B--
