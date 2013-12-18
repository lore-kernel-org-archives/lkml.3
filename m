Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3LRGKG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 01:10:06 -0500
Received: from ozlabs.org ([203.10.76.45]:47977 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab3LRGKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 01:10:03 -0500
Date: Wed, 18 Dec 2013 17:09:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: linux-next: manual merge of the usb-gadget tree with the
 usb.current tree
Message-Id: <20131218170956.ac1f118ee4928654af340c3c@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__18_Dec_2013_17_09_56_+1100_Q.lqJB1TuUS3vZwK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Dec_2013_17_09_56_+1100_Q.lqJB1TuUS3vZwK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

Today's linux-next merge of the usb-gadget tree got a conflict in
drivers/usb/phy/Kconfig between commit 7cd0c298f6e0 ("usb: phy: fix
driver dependencies") from the usb.current tree and commit e1d2e31975e1
("usb: phy: Add OTG FSM configuration option") from the usb-gadget tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/phy/Kconfig
index 2b41c636a52a,54bebba39e91..000000000000
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@@ -19,9 -27,8 +27,9 @@@ config AB8500_US
  	  in host mode, low speed.
 =20
  config FSL_USB2_OTG
 -	bool "Freescale USB OTG Transceiver Driver"
 +	tristate "Freescale USB OTG Transceiver Driver"
- 	depends on USB_EHCI_FSL && USB_FSL_USB2 && PM_RUNTIME
+ 	depends on USB_EHCI_FSL && USB_FSL_USB2 && USB_OTG_FSM && PM_RUNTIME
 +	depends on USB
  	select USB_OTG
  	select USB_PHY
  	help

--Signature=_Wed__18_Dec_2013_17_09_56_+1100_Q.lqJB1TuUS3vZwK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSsTw4AAoJEMDTa8Ir7ZwV8/0P/RaoMJbvG57xFQPxc7BI5lJy
lFWkGy1XFTJ6/OW+//nVkZ9M/C7zUecNgYwmXecso3AWMr5WxLk/CgnjOsAUAOsc
yGhFNmYG1qRSQ6KDkzrw37Mhc8lqStHw/fPs+mr4cMfpcafIytK3Ijp2zhDuyMJD
A95Y1q+DqDXRbXBUME9IN9/OcPQbFIfORR27gQk8mc101oODj3oIK3grk9Ye8ebj
galiSyDxfILenezTzMZKfa6rzuUs298rStAoVK9s2+D/7n1+OEv4SfdUZR06yAt8
aNw3sYBo03xUUxzgD8ed615VYXBbz+KmCl6/zf6KH453yksXjLuWb2CZ+275C4+R
vDsYb44MOB4ACueeLHszLPKG+99mJbw8I9DD5iTgBwvhi+PBowCS6P+BW65ncSaC
KtQ2mut/AkUraqnZxnHtSPH3GNwscFhe17kaTOVJ5+hWFb7ZHHdzSsMRY6/temDw
2k6TpHYrFF3+nkt9a/jDrvMwrfS17DOySM/rNK4CEl1YZlUUHbGE6C6rkG+mbLwW
A4s+bWwLe+d6OuX6wrQeyJsv6mizU1H/NO5fhccVV5oNiRUvAczBQgozAjVm3/Hl
HMjFt8R5Uv1rStR1RtA/Fdy3SLRa3sCbRf+Vq3Lg7qTZ/o6F73kGGMBvOiiUggeB
vFVC/SNlrXZN9i2A5GuZ
=acNP
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Dec_2013_17_09_56_+1100_Q.lqJB1TuUS3vZwK--
