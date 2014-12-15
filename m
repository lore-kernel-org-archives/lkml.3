Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750755AbaLODLa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 22:11:30 -0500
Received: from ozlabs.org ([103.22.144.67]:47169 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750868AbaLODLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 22:11:21 -0500
Date: Mon, 15 Dec 2014 14:11:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiubo Li <Li.Xiubo@freescale.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the driver-core tree with the watchdog
 tree
Message-ID: <20141215141114.575b8767@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4w2V10G0Tnc1fQNEYD4vbfu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4w2V10G0Tnc1fQNEYD4vbfu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/watchdog/imx2_wdt.c between commit 6dc21678dbd9 ("watchdog:
imx2_wdt: Add power management support") from the watchdog tree and
commit fa21a580dea4 ("watchdog: drop owner assignment from
platform_drivers") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/watchdog/imx2_wdt.c
index b333283b24a7,65b84d8c0b93..000000000000
--- a/drivers/watchdog/imx2_wdt.c
+++ b/drivers/watchdog/imx2_wdt.c
@@@ -383,8 -337,6 +383,7 @@@ static struct platform_driver imx2_wdt_
  	.shutdown	=3D imx2_wdt_shutdown,
  	.driver		=3D {
  		.name	=3D DRIVER_NAME,
- 		.owner	=3D THIS_MODULE,
 +		.pm     =3D &imx2_wdt_pm_ops,
  		.of_match_table =3D imx2_wdt_dt_ids,
  	},
  };

--Sig_/4w2V10G0Tnc1fQNEYD4vbfu
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUjlFXAAoJEMDTa8Ir7ZwV7HkP/39HDUeUT70ina7o0gj9Nt6u
0+sdnm/QHTLYGwCmOFUmS+zgCeRaM4H7GANeMLGKt+0oIBpcaGmncOjfVyXi9hwH
4iNZ7yShMxw6V1PeqDTsipwjRkAHytZC+3pIWI13iZFqZlodLqnOEYQ5kPlZNA6P
Vp7FNfXi5YDelQC98BUhUjpIVcFUnOAie/mdERL+OiyVywuw7HUcXgMKakvuD/uL
J2AzXozvVBxs+hFnM6v0PinlBqXGjle7eAENMKO+fqxp2mLVn6/nG+6UgCdLJ7TY
scaQGrezJdqUZJM8ElmUzjhKbi/i8KeLTFjzFFCyDhB6LELLfmoI31w6RTFVF8HQ
7UXMah2Hr+y+0kTQrYU56UNESrU3HsXzpQEBmGd66NvNs7mx7ICuJlo1qBcKc+ZW
aaKKfNnApFpKuhlY+WaljJCSf2EB+ll82db5kl/G6SLHvv62WKRzpP1wac/9QuM2
X38g6KNX5BI1dReTXvDkhNwi/AEwy9ZulM8r25USYkq7KeRwgmT1BauyJB8EWCRu
w41GNwRJeg7oXrNVyH8CvAoIoewGOej6Vd9BpGnG6bsqeEiVPAjqLAG32Ugvv3F1
WlnhF/DWHIUxBGGrXVAXvO2fWXfEhEum+FnkAB6VPLVjwwzI8BHPUoL2OQ4itwpT
6mvLGfv+HxtNv/yCslMt
=6YFO
-----END PGP SIGNATURE-----

--Sig_/4w2V10G0Tnc1fQNEYD4vbfu--
