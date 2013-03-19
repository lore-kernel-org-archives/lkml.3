Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757076Ab3CSDjc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:39:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54410 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab3CSDjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:39:31 -0400
Date: Tue, 19 Mar 2013 14:39:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xi Wang <xi.wang@gmail.com>, Felipe Balbi <balbi@ti.com>
Subject: linux-next: manual merge of the akpm tree with the usb-gadget tree
Message-Id: <20130319143922.f60895f782e5c8e9824c447b@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__19_Mar_2013_14_39_22_+1100_m.geIte5gfJvMpEB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Mar_2013_14_39_22_+1100_m.geIte5gfJvMpEB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/usb/gadget/amd5536udc.c between commit 6c39d90393a2 ("usb:
gadget: amd5536udc: remove unnecessary initializations") from the  tree
and commit "drivers/usb/gadget/amd5536udc.c: avoid calling dma_pool_create()
with NULL dev" from the akpm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/amd5536udc.c
index f52dcfe,142616a..0000000
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@@ -3232,6 -3235,12 +3232,10 @@@ static int udc_pci_probe
  	pci_set_master(pdev);
  	pci_try_set_mwi(pdev);
 =20
+ 	dev->phys_addr =3D resource;
+ 	dev->irq =3D pdev->irq;
+ 	dev->pdev =3D pdev;
 -	dev->gadget.dev.parent =3D &pdev->dev;
 -	dev->gadget.dev.dma_mask =3D pdev->dev.dma_mask;
+=20
  	/* init dma pools */
  	if (use_dma) {
  		retval =3D init_dma_pools(dev);

--Signature=_Tue__19_Mar_2013_14_39_22_+1100_m.geIte5gfJvMpEB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRR93qAAoJEECxmPOUX5FEmYMQAKW/2p3gxB6qoYUR5TC276a1
yvCc12vvXGCloezM/VRDgHjWGbzmaw/tCccq6BIxKAtTldyPo+Tux2wkKnPd6apX
+DFauL0/uJdSezoq9R3VIJhg6EfS/2K67W5qHAlZ7HP1LQb+z56xgxy9SoXQ5T9e
fZ/5l9zEdgwGpDD62go5lD7aUuEcxgvBLikQC4anLK/96sl4XDnoVISIR+5XZMwm
c+grHW5djgydKkISZXHecocCBzgy0cAziZkDw/sxGPoKJh83H0vFk154cRRCPY5P
Oo66+gGCezy0KP8rr1fVsTO9s3cMMJI/7bd/g+Dcmo7fN4ue0p6/4yk3ESzOvlrZ
B4vusW0hr9c2i3gy/JW8aB6oaxFCi2y6N4YGGdIUmYDGZy+38mhFiYiRp2GdIDGF
EE47Zck3G501vcdwtbKjaYB//EuKoSSeNJqxPjHX6u1IXvRCpddGLs+gaLLtMI1M
huCwhBGJUrzuAdHyncXF0g9RetYBw1dGuCMAmBzlLxJnUi3JhN+zVHeLEPfSvrDL
ICbJ86xIiMscBniQg4jcKGGds6L7sBDm+xUVitsk32dMlKZGknv6GP20bxnsMGgd
gj1kbxYc2Msd7KsNFiUKQWfmWUj5UIfB9h3f4/feekppgOuzF1knqrZ99uZ0axXn
2MgF84e5iOm7PhPJeiFN
=iG+M
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Mar_2013_14_39_22_+1100_m.geIte5gfJvMpEB--
