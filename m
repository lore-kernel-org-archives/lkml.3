Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaKJIz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 03:55:28 -0500
Received: from ozlabs.org ([103.22.144.67]:42912 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaKJIz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 03:55:27 -0500
Date: Mon, 10 Nov 2014 19:55:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>, Johan Hovold <johan@kernel.org>
Subject: linux-next: manual merge of the akpm-current tree with the
 driver-core tree
Message-ID: <20141110195519.10cef790@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XftjK14EULK=GZH7=donj1="; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XftjK14EULK=GZH7=donj1=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm-current tree got a conflict in
drivers/rtc/rtc-omap.c between commit 0929ae376ef3 ("rtc: drop owner
assignment from platform_drivers") from the driver-core tree and commit
700abe25a31a ("rtc: omap: remove DRIVER_NAME macro") from the
akpm-current tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/rtc/rtc-omap.c
index ae444a8bd602,fba13e53c278..000000000000
--- a/drivers/rtc/rtc-omap.c
+++ b/drivers/rtc/rtc-omap.c
@@@ -568,7 -718,8 +718,7 @@@ static struct platform_driver omap_rtc_
  	.remove		=3D __exit_p(omap_rtc_remove),
  	.shutdown	=3D omap_rtc_shutdown,
  	.driver		=3D {
- 		.name	=3D DRIVER_NAME,
+ 		.name	=3D "omap_rtc",
 -		.owner	=3D THIS_MODULE,
  		.pm	=3D &omap_rtc_pm_ops,
  		.of_match_table =3D omap_rtc_of_match,
  	},

--Sig_/XftjK14EULK=GZH7=donj1=
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYH18AAoJEMDTa8Ir7ZwVT8MP+gOgT0hkhk5kL97dDg+vFjXV
hvxIbIIhUdO6QWjI5pjhWdpVcTMX2xPV1gfPj0mflWU/r6Z3yjekZtknIMPe3Aee
d9fHRL71byGTAMCmraeIbQ9DQIEJIdLfmZFNuTopK7dD+N8LR1SitZOK8nPAnZIX
WBLf0NLqADwsNmurfzFVmzosN5ugadhsK6FfQtQK3swJxcHH8ymQyRZ0NwXild4j
wmHzNh9vIKh8rMb+ueRU0VV4HfE6UN1xOgtLZutjrs9mRgjGj89IrcU+FNOqD99P
HQ87UAu9bwSHwg6z+3XtZXTtTl1f+x0RHHLDZh8uyCrPo2ge6gT+bvZIAY6XhR5i
mkv+adxscjE4IGpcmCv6EkGqrWhg5MexNzisJKJZSwBD7NP9rZQR8TGOudJWcww9
YrGJhTmKYG7bwZZEphLxU3tk8lOEBOHhZ4BOajmUDFbvgUPApqYnyuqFG+a6COiC
4uzzAXYa6r+/ofY7+F5wozAtn0r8yfKv+YhrAAOGEK4Cu39PiqVTa9a0wwi3Pr5b
YicDEAtYq4dNuUY+iuqQ3B2F2UlFBnXGxtoDoQMmPI+Lpct8x/svoAR/XGhqNhih
rGCNqkNfBwOtS8ffzOgDKDSB1+WUALdhwUHn7F3FJGpozaF4B30674IWLXeCO+Jk
9qSunYmAvqVpHB8O9v1O
=HzvC
-----END PGP SIGNATURE-----

--Sig_/XftjK14EULK=GZH7=donj1=--
