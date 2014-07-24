Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758715AbaGXF4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 01:56:42 -0400
Received: from ozlabs.org ([103.22.144.67]:52871 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904AbaGXF4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 01:56:41 -0400
Date: Thu, 24 Jul 2014 15:56:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jingoo Han <jg1.han@samsung.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: linux-next: manual merge of the driver-core tree with the drm tree
Message-ID: <20140724155630.2727ad65@canb.auug.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/5S4K/cFVN.atIrqQi.WIpm2"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/5S4K/cFVN.atIrqQi.WIpm2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/gpu/drm/armada/armada_crtc.c between commit d8c96083cf5e
("drm/armada: permit CRTCs to be registered as separate devices") from
the drm tree and commit c9d53c0f2d23 ("devres: remove
devm_request_and_ioremap()") from the driver-core tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/armada/armada_crtc.c
index 3f620e21e06b,3aedf9e993e6..000000000000
--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@@ -1064,11 -1039,9 +1064,9 @@@ int armada_drm_crtc_create(struct drm_d
  	if (ret)
  		return ret;
 =20
- 	base =3D devm_request_and_ioremap(dev, res);
- 	if (!base) {
- 		DRM_ERROR("failed to ioremap register\n");
- 		return -ENOMEM;
- 	}
 -	base =3D devm_ioremap_resource(dev->dev, res);
++	base =3D devm_ioremap_resource(dev, res);
+ 	if (IS_ERR(base))
+ 		return PTR_ERR(base);
 =20
  	dcrtc =3D kzalloc(sizeof(*dcrtc), GFP_KERNEL);
  	if (!dcrtc) {

--Sig_/5S4K/cFVN.atIrqQi.WIpm2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT0KAWAAoJEMDTa8Ir7ZwVc/kQAIv6yh06PvzuUNglARTJudhZ
4l+oWaHGBQw9kHnNGO2T/0qK2WEpJe/wJaaaZrTKEL4jarKzdim3DTc+qOWNUnDZ
Pcxxxas8xhLcmLf9xI1/8P/R529UR3+7YgBZJDIKzgMzxU7yj6gx1wBhV/j4OCcw
epCSeCMRdPN4dSJCcNwLRxfDJPxt1Sc1cdyM1GNBAv3WeDwP6yXRBgLJpe1nu6eN
Dh1RM+S8v3R7RuLVGw86XHeogMOXc/rE6hldsSGifR8nrP6s/iTFF+Dnx1XeuO6w
r6SkiYv7LTEGFsDEf04BS5tu2CDmVUwVb1VsJ7MPZRV41COsIeWo9BdEvt6auZGc
ddJ5KL2Ol4Lx8PpQhCDO5J/EaZ0IHUSntYyyOwdAVWON4j6rdyQFkTo1Vktl/rkE
TLMXl0+Zt2t5Tx4twx8RzoI2iNd5VXbSy1GkFOQIs64BVTRg/UXJLg6p6c7ZMTXH
YBz2L2gOpjseBfV+F8w5njB7TvVDrujwQcdNu61xFO61UFqAcL2nCD3Z6HB4V/wD
Rx7HzHBZQz3RFd6F8wyVkBuXscXalUMkpmiHJo8atoQmtUtmYA2+lQFdHgjJVGe3
XsTFfBxOxjwnH/GGGLgq1hmv5PBRppmfdt4hZuJSf/2FxKNFsnx/XF/qu7ZhT+4r
RAqp4odNVAK7IoVLqAxV
=AQGr
-----END PGP SIGNATURE-----

--Sig_/5S4K/cFVN.atIrqQi.WIpm2--
