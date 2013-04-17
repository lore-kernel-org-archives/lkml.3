Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab3DQFr1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 01:47:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40768 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074Ab3DQFr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 01:47:26 -0400
Date: Wed, 17 Apr 2013 15:47:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the gen-gpio tree with the usb tree
Message-Id: <20130417154715.cd3036b3cc791800938119c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Apr_2013_15_47_15_+1000_sGrzGt7DDRPQma=_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Apr_2013_15_47_15_+1000_sGrzGt7DDRPQma=_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexandre,

Today's linux-next merge of the gen-gpio tree got a conflict in
drivers/usb/otg/Kconfig between commit a0e631235a04 ("usb: phy: move all
PHY drivers to drivers/usb/phy/") from the usb tree and commit
76ec9d18b897 ("Convert selectors of GENERIC_GPIO to GPIOLIB") from the
gen-gpio tree.

The former patch removed the file, so I did that and then applied the
following patch and can carry the fix as necessary (no action is
required).

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 17 Apr 2013 15:44:53 +1000
Subject: [PATCH] gen-gpio: GPIOLIB merge fix up

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/usb/phy/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
index 3a7fec9..21153d1 100644
--- a/drivers/usb/phy/Kconfig
+++ b/drivers/usb/phy/Kconfig
@@ -128,7 +128,7 @@ config TWL6030_USB
=20
 config USB_GPIO_VBUS
 	tristate "GPIO based peripheral-only VBUS sensing 'transceiver'"
-	depends on GENERIC_GPIO
+	depends on GPIOLIB
 	help
 	  Provides simple GPIO VBUS sensing for controllers with an
 	  internal transceiver via the usb_phy interface, and
--=20
1.8.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__17_Apr_2013_15_47_15_+1000_sGrzGt7DDRPQma=_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbjdjAAoJEECxmPOUX5FEtwgQAKqDlM9TFr+zX8cYk/ECpF5u
5bRmyJEGeuBO2VFjEd8GyNH3KzV3rTFiJo1kBxY65qVAcJqKctk43mKOgooPbWo0
nIQec2sp4w+Evlr5krsGKhkKhJZLWso4HosRFawGdU/KGrlZ/1vRGZ+3rtMXx/n5
t6PUeIMA3nVE5qQQd+MzdiksjneuXnq8fg+5+GD5iBh0unQV41KJJ8qAzFVASIH6
SNl6VdcbqF7qA08nL3yohlaRLnm8W4ewyMoPjNEjsh5z+yBmXgo8neb28gljSsqb
J5oh0oysrAwUeSixy/kpdHOihx3jyO4ZO4h40Ml+xgJM8t2reCSvav37IpvFfB4d
QPxWwzzytKfTsg2VbXElcTWySRAiEou7YyWHL2RDrQdsE+3wcZlPKur9/TUsBP5t
ei5HoQSALrNCaM6v8iDRWqApBGILb8AR5rzCQfmmaX5xiGK9buBMAif1q57FfSo6
FR8me5ovXVb8NvVMYZXUu/Mckg7ZOugQDHFtrYylyr3pPYuCY5owTnVkdjdCtbxM
qaUGrK008ELtASFo86TB1bNuhRsX5d+tUz43s1nKneE4KqvSAV82dSujr5zTzN47
xOtlxgLyxJPYJcDTRa8vTamjDde0mN8Tl3UtBd2nu1Ytglbv7tGHCFpyLGiSg3Tx
3MFr/X/i/AvWKrps2jl1
=lBdX
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Apr_2013_15_47_15_+1000_sGrzGt7DDRPQma=_--
