Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab3H2ITH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 04:19:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46085 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3H2ITE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 04:19:04 -0400
Date: Thu, 29 Aug 2013 18:18:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Simon Horman <horms@verge.net.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Vladimir Barinov <vladimir.barinov@cogentembedded.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: linux-next: manual merge of the renesas tree with the v4l-dvb tree
Message-Id: <20130829181854.e380fb3508d41d88eb98f15d@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Aug_2013_18_18_54_+1000_.AiSYS=Q4akC=Tt5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Aug_2013_18_18_54_+1000_.AiSYS=Q4akC=Tt5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Simon,

Today's linux-next merge of the renesas tree got a conflict in
arch/arm/configs/marzen_defconfig between commit e0c332c671e7 ("[media]
ARM: shmobile: Marzen: enable VIN and ADV7180 in defconfig") from the
v4l-dvb tree and commit febedc9c9fe3 ("ARM: shmobile: marzen: Select
DRM_RCAR_DU in defconfig") from the renesas tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/configs/marzen_defconfig
index 000e920,26f30be..0000000
--- a/arch/arm/configs/marzen_defconfig
+++ b/arch/arm/configs/marzen_defconfig
@@@ -85,13 -85,8 +85,15 @@@ CONFIG_GPIO_RCAR=3D
  CONFIG_THERMAL=3Dy
  CONFIG_RCAR_THERMAL=3Dy
  CONFIG_SSB=3Dy
 +CONFIG_MEDIA_SUPPORT=3Dy
 +CONFIG_MEDIA_CAMERA_SUPPORT=3Dy
 +CONFIG_V4L_PLATFORM_DRIVERS=3Dy
 +CONFIG_SOC_CAMERA=3Dy
 +CONFIG_VIDEO_RCAR_VIN=3Dy
 +# CONFIG_MEDIA_SUBDRV_AUTOSELECT is not set
 +CONFIG_VIDEO_ADV7180=3Dy
+ CONFIG_DRM=3Dy
+ CONFIG_DRM_RCAR_DU=3Dy
  CONFIG_USB=3Dy
  CONFIG_USB_RCAR_PHY=3Dy
  CONFIG_MMC=3Dy

--Signature=_Thu__29_Aug_2013_18_18_54_+1000_.AiSYS=Q4akC=Tt5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJSHwPyAAoJEECxmPOUX5FEAdAP/RcCvb9qZW1IpAXvYcDYzBX5
vTxHVXVG1ZBbNgwD7Na9PZ0KG+JvyVNrrAOrZpyW5R9rGvXu2kvDu6dVM/NDaVi5
uOpiynnrIBA8RE2iv8BFCf19hgPzXUMSgcK56dwyv7YyyPhbyC8H9OLt0ubRu3Nq
XBML1hlshMqch6bMz4Noxd56tx/X1mBRB7toa4OxUcpx7InVOKwT4qMRAW5CPgas
EyfVplSbPqwsbIcSDxGcfrbCFh29KK8La+hgTvmZjq3sdUrK/nb5Kn1z+zRB9TOX
hiSQOTe3zCprBketfBW4h2ZxeAfABMoXaMVzxR10tm4pLjw0++MHM2p59DJQ6cv4
ogrpMfhXQvE2UNQpAFXoNTCV21bLecY0S/4OfBHbDNgAzW9BtVAK4l6WgYVP5lCk
ZwPJiBj5fSCkqUDHSG3rZ5qmaHAYgAx7/xT8sr4IVTQXx7xiVy9YqxfIaVvV1mRR
FNTjSa86lcP0MAPAFbADMNI2f/IrzDtaSuBfA7jvhLtW1j+RCEX9a3GyG0xXjkhj
N2DSaeFJVz17PPRwM/PycEQgByA+V/4mdA3Fg6wPi+mTf/ISSm21//f/sVby4mli
7l2GcpGhMNFbiJhrxs/JIlCjXjQzHpExsl/fJiF+VDbbj4QZoBr2DEzcgd6q4vga
NdscWte1bx7w7FKQIcfD
=eoig
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Aug_2013_18_18_54_+1000_.AiSYS=Q4akC=Tt5--
