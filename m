Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaKJFIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:08:32 -0500
Received: from ozlabs.org ([103.22.144.67]:51560 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaKJFIb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:08:31 -0500
Date: Mon, 10 Nov 2014 16:08:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Robert Jarzmik <robert.jarzmik@free.fr>
Subject: linux-next: manual merge of the usb-gadget tree with the
 driver-core tree
Message-ID: <20141110160824.50addb94@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/WXbalkUE_wB0k4Vm=k41yj7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WXbalkUE_wB0k4Vm=k41yj7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/gadget/udc/pxa27x_udc.c between commit 6d3f5f2d895b ("usb:
gadget: udc: drop owner assignment from platform_drivers") from the
driver-core tree and commit 1803fe15ad54 ("usb: gadget: pxa27x_udc: add
devicetree support") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/udc/pxa27x_udc.c
index 61bceedf515d,69e7b816d880..000000000000
--- a/drivers/usb/gadget/udc/pxa27x_udc.c
+++ b/drivers/usb/gadget/udc/pxa27x_udc.c
@@@ -2614,6 -2589,8 +2589,7 @@@ MODULE_ALIAS("platform:pxa27x-udc")
  static struct platform_driver udc_driver =3D {
  	.driver		=3D {
  		.name	=3D "pxa27x-udc",
 -		.owner	=3D THIS_MODULE,
+ 		.of_match_table =3D of_match_ptr(udc_pxa_dt_ids),
  	},
  	.probe		=3D pxa_udc_probe,
  	.remove		=3D pxa_udc_remove,

--Sig_/WXbalkUE_wB0k4Vm=k41yj7
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUYEhNAAoJEMDTa8Ir7ZwVVAEP/0jH0nGhfG2HL5Tqv5o4xfpt
6vU9SmWcxRwDzCzYdvYOOaUbVIHQ1ZYSAowYZsIJ9YqvzCorJatKV1PAK/fIGHVR
xnJnZw/KdD5iQ4/ZiPRRxWG+KjvHxE34WGQBT30haNTLEYJfuVdmvEnDO+fsDsTx
5i3Kk3ov/CEIIU3Tgw8v1nQ43/LOVr1aItZVCCO4SBkfFUEoAd84WkIW/aQ+OV5D
G/H9hjU1IDo/RXKJQ64YbQVu2G90DZZ7pO5v5IGkid2cn16+C8L2zvcozIIyg94w
wu4PWyveXfBsfeihhEDr82y8CrN83v7q17Co4+ckyICkS4Vuy/ywz/blOLIv2qg5
UZzOt/n5J9YmyOOynGLlwDmPwBx5SUabAYJn4er0p0sM8DfmOF8Smu/3MqmHJ9r5
g7udAjt5UFPAuVj3Dzo9B1M0GAtLO6O4dZCRXq3t+0wvY1sf/Ws247h7l9l+pdYA
AyofCrJfSWK93bQxFtSdk5QbxZPIL3PHe7WsR8PE1Qtt/rdyd0QNgEVaoGFncxHY
UyrVBvMtZ6zHa4Ps5Va1+gyxIXw83XglcjYtDK77/Z3ouPpVqQ5Bry+ArYjyS54X
EhqldHQx9itRdJzqQUjx2lFvoU4hGhbuHyKwG1/QRYsykST4tEKI0TmMpJ2KN/n5
2H9qPtd10n1BRgdplDkC
=0YuO
-----END PGP SIGNATURE-----

--Sig_/WXbalkUE_wB0k4Vm=k41yj7--
