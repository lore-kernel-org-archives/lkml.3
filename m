Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416Ab3CMFjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 01:39:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38786 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab3CMFjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 01:39:46 -0400
Date: Wed, 13 Mar 2013 16:39:35 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>
Subject: linux-next: build failure after merge of the final tree (staging
 tree related)
Message-Id: <20130313163935.ea2f414d3ccc6ed1434d92b8@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__13_Mar_2013_16_39_35_+1100_.0pMb7Ui3yRz3xKY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Mar_2013_16_39_35_+1100_.0pMb7Ui3yRz3xKY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/staging/dwc2/hcd.c: In function '_dwc2_hcd_urb_enqueue':
drivers/staging/dwc2/hcd.c:2387:3: error: implicit declaration of function =
'bus_to_virt' [-Werror=3Dimplicit-function-declaration]
drivers/staging/dwc2/hcd.c:2387:7: warning: assignment makes pointer from i=
nteger without a cast [enabled by default]

Caused by commit 7359d482eb4d ("staging: HCD files for the DWC2 driver").

=46rom Documentation/bus-virt-phys-mapping.txt:

"[ NOTE: The virt_to_bus() and bus_to_virt() functions have been
        superseded by the functionality provided by the PCI DMA interface
        (see Documentation/DMA-API-HOWTO.txt).  They continue
        to be documented below for historical purposes, but new code
        must not use them. --davidm 00/12/12 ]"

See also Documentation/DMA-API-HOWTO.txt.

I have added this patch for today:

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Wed, 13 Mar 2013 16:35:50 +1100
Subject: [PATCH] staging: the DWC2 driver uses bus_to_virt

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/staging/dwc2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/dwc2/Kconfig b/drivers/staging/dwc2/Kconfig
index 610418a..bc4cdfe 100644
--- a/drivers/staging/dwc2/Kconfig
+++ b/drivers/staging/dwc2/Kconfig
@@ -1,6 +1,7 @@
 config USB_DWC2
 	tristate "DesignWare USB2 DRD Core Support"
 	depends on USB
+	depends on VIRT_TO_BUS
 	select USB_OTG_UTILS
 	help
 	  Say Y or M here if your system has a Dual Role HighSpeed
--=20
1.8.1


--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Mar_2013_16_39_35_+1100_.0pMb7Ui3yRz3xKY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRQBEXAAoJEECxmPOUX5FE5LAP/0hWxoGreZatMzg5y1YWgbtM
ZCNglayaoczB8K6h3XDsGP1vI0n3pNxhNmQUP0tHZKxB2wFTBhcy9dOjdtXZ2P97
v5p6Gk4Y/FjFzV3Nj/c80ApSOs7DIZRalu5+grD4H8SjWkg9xK7/f3CUjX3LGOQV
Epn0TMJr5J7aCcFOlBLBXalR20sLK0v2XunmxFU3ZWwA+Akl3GyBD4c7gilpfUjD
+8h9TJW0Y+wrTpQhKYmT/iNNtyiB9aVL7QZOyJWiOheaqc7jJWY0NBvyA1JOqdlD
UxNVdlFGX0KU/UV/IxWMoZpO6YZjHv96Vv2NzlsdcQiPGPW+JE9b6Eqqvr1Kj1kX
0ZGVmN1P0iyZDRrgZ3Pn7t6pv818cusAV8DXTttAvVR1h7rUPnlRVF5dsXTppsDW
PMS3KeuKiSU6DvHMF6c+5SiFTx4W9n/15CPdVBCGTSNxyHB+yg/1CDnW4eHxDz9E
YceMORHYX0HkXtj5x2OrUKPr9g4Iucq57shrWtpV/KihSt+gww/hm2EDvhqqzmJ9
a5MHW1YfvIjJJT3p/1kPyXuNLMFbElOJBvJoHhbc9tLm2GTy0RnwYWzADW2WhF+z
e+8dI/H0nuthX3EMUAtG54ZsTi0N/WP16vmkFptWP9aX8bmlmCtr1n3/qqxc5vh7
x4DG4PFa889PISYXkkp2
=8QMp
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Mar_2013_16_39_35_+1100_.0pMb7Ui3yRz3xKY--
