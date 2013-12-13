Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LMEBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 23:01:13 -0500
Received: from ozlabs.org ([203.10.76.45]:42265 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751715Ab3LMEBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 23:01:11 -0500
Date: Fri, 13 Dec 2013 15:01:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Subject: linux-next: manual merge of the pinctrl tree with Linus' tree
Message-Id: <20131213150102.47de4cd579163889dd364297@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__13_Dec_2013_15_01_02_+1100_J95uBBYrwdz1D+I8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__13_Dec_2013_15_01_02_+1100_J95uBBYrwdz1D+I8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next merge of the pinctrl tree got a conflict in
drivers/pinctrl/sh-pfc/pfc-r8a7740.c between commit 5d27619498ab
("sh-pfc: r8a7740: Fix pin bias setup") from Linus' tree and commit
5b46ac3a7723 ("sh-pfc: Rename sh_pfc window field to windows") from the
pinctrl tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell <sfr@canb.auug.org.au>

diff --cc drivers/pinctrl/sh-pfc/pfc-r8a7740.c
index bc5eb453a45c,a189b962a1eb..000000000000
--- a/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
+++ b/drivers/pinctrl/sh-pfc/pfc-r8a7740.c
@@@ -3720,8 -3709,8 +3709,8 @@@ static void __iomem *r8a7740_pinmux_por
  		const struct r8a7740_portcr_group *group =3D
  			&r8a7740_portcr_offsets[i];
 =20
 -		if (i <=3D group->end_pin)
 +		if (pin <=3D group->end_pin)
- 			return pfc->window->virt + group->offset + pin;
+ 			return pfc->windows->virt + group->offset + pin;
  	}
 =20
  	return NULL;

--Signature=_Fri__13_Dec_2013_15_01_02_+1100_J95uBBYrwdz1D+I8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqoaCAAoJEMDTa8Ir7ZwVwmMP/Rvx7ebZ7uQuchjSYUxfIJJH
8szWXN2mBKlFFNjM4B04wKfny8SI8DAZGY8UIeQO+vpQP7Sk4u6pM1vZS8u9nv5/
H7hXBvEkMLEKNaYGQJmAFcaeSl7yF3rEkyuNrqgVVfvY7s4Lbrc1bBIcrLcOezEj
XU/YBmjBvxvdpx+JMXJI1qFZZf3mSvzgYp7+FXGxOLftmTsjNXpJ9+gElj+EiLxk
zuCKnBPWHE+fbJ1GEh66adxD0nz6VZO9YV/u8/uf1V9TXPDydjD1TXr+hDYATJVH
vmFAN1KyaN74OH3ChT+JDwdPrOaEOXC6+zDtRd2wZ9tNxa7TznW/ZgMVvIKve+vh
IhrNFoiEDRR25lE/R8Y+wVHe6JbNX4S4Q+BNc+3D3lurxRghwLgNP0in3DJEJIpv
/3WRpSURi38TaaFYFN6BIQZjMQhRqhgtb8dhS9D4TAb1gcxHGMKdnsy74C8kzBZf
gV9VeV+Mf4neObFz9K3xu1D9fiYy/bFBR6q8gzSVHASytUQPnWHlcRSEeQcT/+PI
sCf3OwMKAc8Z+34RmLLzpaW6XZmTSFShQHczSLu0UGfc3qnNsauYkQH6AMHB1AFY
Ek74QUXlFxKle1ow6t8VSNjCGlwzQi8YVQJXySanq3fpSOvNBI5ChlDWCb7C0sKB
qqVoyGv1AJa5nK6ggOoy
=autl
-----END PGP SIGNATURE-----

--Signature=_Fri__13_Dec_2013_15_01_02_+1100_J95uBBYrwdz1D+I8--
