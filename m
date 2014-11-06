Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436AbaKFDZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:25:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57026 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750975AbaKFDZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:25:51 -0500
Message-ID: <1415244343.3398.47.camel@decadent.org.uk>
Subject: [PATCH 1/3] i2o: Fix DMA mapping leak in failure path of
 i2o_cfg_passthru32()
From: Ben Hutchings <ben@decadent.org.uk>
To: LKML <linux-kernel@vger.kernel.org>
Date: Thu, 06 Nov 2014 03:25:43 +0000
In-Reply-To: <1415244281.3398.46.camel@decadent.org.uk>
References: <1415244281.3398.46.camel@decadent.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-zA3967wS7pRnXbLNFIcQ"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zA3967wS7pRnXbLNFIcQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

If i2o_dma_alloc() fails then we don't free any DMA mappings already
allocated.  i2o_cfg_passthru() does not have this bug.

Compile-tested only.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/message/i2o/i2o_config.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/message/i2o/i2o_config.c b/drivers/message/i2o/i2o_con=
fig.c
index 04bd3b6..274235d 100644
--- a/drivers/message/i2o/i2o_config.c
+++ b/drivers/message/i2o/i2o_config.c
@@ -630,7 +630,7 @@ static int i2o_cfg_passthru32(struct file *file, unsign=
ed cmnd,
 				       "%s:Bad SG element %d - not simple (%x)\n",
 				       c->name, i, sg[i].flag_count);
 				rcode =3D -EINVAL;
-				goto cleanup;
+				goto sg_list_cleanup;
 			}
 			sg_size =3D sg[i].flag_count & 0xffffff;
 			p =3D &(sg_list[sg_index]);


--=20
Ben Hutchings
Beware of programmers who carry screwdrivers. - Leonard Brandwein

--=-zA3967wS7pRnXbLNFIcQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAVFrqOOe/yOyVhhEJAQqUuQ/+MZ9RnBkiR8gutLi8xX8gLKIIgHSYw/KU
FvI4zQIS/O2EaKzn3FJpkah+FWL49+6MGoil0LVMysqv3hlbzknZ0kt0nEKf8Luc
844AW9YgPu/yalLFckKOf2n96R34WdXJNebdf89oxrvj9vSRX2F1YlBK7SWqidwp
aH3m0u88GSyy3m7NOp51o8DyOX09Cmi3BLE60eF9o0+gMH7DiDC02uhhT69RrddL
e/7HcoLzxUkrORQ1KSFL/QcVdKhl4HYo4Zt3H0CukvIiybCEENXI+K8PBS0dHfJV
nvUMTZbboUIeguiM+AnPzrrmCIYofFtFlt8Nn2kXo/xcxFUPGzNO+ytJ5Ptf+/AE
Y0kkIXoBJARrI9ssfNHTdtWT9w1YNkefIXZdK06sEf4AIUxNha17K5FRVIqnGU/t
yYw9xs+upGj9nViXFAz80KFA9W5iUUNDZCiwBAHFcGQhxdJTbdcyCmlo8DSXZVyc
YrC1WvQtUCUZG3QK5axrafmJazfo7+RxsyklXaw0XQe2sFNSqI72KAraQXt16ZfV
S33wyo5vD4fXUuU1YwVCOESnq7ULpgk2oBuBDftPjB3CbGgYfvYnfPmBzclQbTzj
PGBdSVCAjnVg2pju9N0jfTIfKKB84dp/8VM7WY+AatYR2yVREsbH/l2WMnq0KMOu
CAKOkJ0lVmI=
=vp0p
-----END PGP SIGNATURE-----

--=-zA3967wS7pRnXbLNFIcQ--
