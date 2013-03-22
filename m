Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3CVDbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 23:31:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60688 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab3CVDbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 23:31:37 -0400
Date: Fri, 22 Mar 2013 14:31:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-Id: <20130322143135.8f9c42c298fd86e4084ca397@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__22_Mar_2013_14_31_35_+1100_vopINZ98lp3bxeTZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__22_Mar_2013_14_31_35_+1100_vopINZ98lp3bxeTZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/gadget/net2280.c between commit 8119b55aed81 ("USB: gadget:
net2280: remove leftover driver->unbind call in error pathway") from the
usb.current tree and commit 68abc94f8de8 ("usb: gadget: net2280: don't=20
touch gadget.dev.driver") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/net2280.c
index 3bd0f99,691cc65..0000000
--- a/drivers/usb/gadget/net2280.c
+++ b/drivers/usb/gadget/net2280.c
@@@ -1924,7 -1920,7 +1920,6 @@@ static int net2280_start(struct usb_gad
  err_func:
  	device_remove_file (&dev->pdev->dev, &dev_attr_function);
  err_unbind:
- 	dev->gadget.dev.driver =3D NULL;
 -	driver->unbind (&dev->gadget);
  	dev->driver =3D NULL;
  	return retval;
  }

--Signature=_Fri__22_Mar_2013_14_31_35_+1100_vopINZ98lp3bxeTZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRS9CXAAoJEECxmPOUX5FERbsP/RRWyeyyF5jTzeA4p8oAP58x
IcirIqiOlTwSRa73sa45Phg9vJCzHpo6Wb7FR0jOUjI2VEVkTUd5PaxyUuvAw9KF
xElegGI+Rsmj8XimGLDL/hOujFancuKSXTD/ncNrhWmXcKoCUgRENRhnrsFX5Gqm
8HG3MmH5LuC2Udx6p+kMYO/Se1gJlFQfoJp6sB8j5Dw09fNUyCm3sAZgf+ME1/Fn
xW7BU9LsoGRUyqQ2e+MmnFaNxFCcm+S2hUn3ZpjkSk2J7ye9/GA18v5v5VpMYOcJ
XgiMmz52fDLsFEjmdjZsL2qlLKIBmSdQhnoQPR5zA4t0+9fC5c0KhdmgH+dDj79W
03v56cKL+I6SD0lYHSJQ3iHLntiuEAVF6jyraPdorp0nIqaazXBLT0FVG150vNVK
nf0nSJsjRj2YHk313TeAtqSUsu5UJoy5wsgtv24SXWxKN94teBmCNx0QQ5OVcXbv
YzeQTYb3aG9kJVWxj88YPLWvwsv0dBTt0Z2YmFro2rG62arh0FyCAy/a/mihN7uj
Ejp6SatL0xP+7kWIQI1Hj++u3TEPkYyAQxcchHYjoXcK8fEsZDMi/wxMCImC071f
+NSuQ40zwx1fnrI2hdWJ5x46T12cQTO01H28TuStNWpAwBNVAHTx9Z4blsT8nz0w
xyk6kQRGlB6qbOwMrkhS
=1n6N
-----END PGP SIGNATURE-----

--Signature=_Fri__22_Mar_2013_14_31_35_+1100_vopINZ98lp3bxeTZ--
