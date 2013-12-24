Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180Ab3LXCt2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 21:49:28 -0500
Received: from ozlabs.org ([203.10.76.45]:37938 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802Ab3LXCt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 21:49:26 -0500
Date: Tue, 24 Dec 2013 13:49:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>, Dave Airlie <airlied@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Antonio Ospite <ospite@studenti.unina.it>
Subject: linux-next: manual merge of the trivial tree with Linus' tree
Message-Id: <20131224134919.716fbdab67caccfb9ebb7450@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__24_Dec_2013_13_49_19_+1100_yzXLK0g/zsz4=4jN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__24_Dec_2013_13_49_19_+1100_yzXLK0g/zsz4=4jN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
drivers/gpu/drm/qxl/Kconfig between commit 488574dbc47e ("gpu: fix qxl
missing crc32_le") from Linus' tree and commit 949b6183412c
("drivers/gpu/drm/qxl/Kconfig: reformat the help text") from the trivial
tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/qxl/Kconfig
index 66ac0ff95f5a,b5be757062b2..000000000000
--- a/drivers/gpu/drm/qxl/Kconfig
+++ b/drivers/gpu/drm/qxl/Kconfig
@@@ -5,9 -5,10 +5,11 @@@ config DRM_QX
  	select FB_SYS_COPYAREA
  	select FB_SYS_IMAGEBLIT
  	select FB_DEFERRED_IO
-         select DRM_KMS_HELPER
+ 	select DRM_KMS_HELPER
  	select DRM_KMS_FB_HELPER
-         select DRM_TTM
+ 	select DRM_TTM
 +	select CRC32
  	help
- 		QXL virtual GPU for Spice virtualization desktop integration. Do not en=
able this driver unless your distro ships a corresponding X.org QXL driver =
that can handle kernel modesetting.
+ 	  QXL virtual GPU for Spice virtualization desktop integration.
+ 	  Do not enable this driver unless your distro ships a corresponding
+ 	  X.org QXL driver that can handle kernel modesetting.

--Signature=_Tue__24_Dec_2013_13_49_19_+1100_yzXLK0g/zsz4=4jN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBCAAGBQJSuPYzAAoJEMDTa8Ir7ZwV7yYP+MqXWR/pU4q+7Fd45bQ/ROjY
pGM9fMtjBgZi2+rfdF4ZEdz2mVyEnCtdfEIssDUr74JebhM74mbwM6rMg3DGLEuY
0xaiePRE3nprH9CGXjQhnDrjXFfxvPmeWhqMp2YwHrE2h4kxF+2qEokvWXQ9NJmF
/UpMKc4QeOyF+LVxqlEha/ZhDuPk0SDtg1NqWoumCqM5wxewI0dIJFucrEX7wit8
waPBgnbgbNsYGdHxVUI6hnn1n/wJXapJFqCRoYE308iL0HO2VyfStBk3PPOhZ1CX
NA5Q4g/cYu5ho3J6RE07TdHeGDB3dagUB0yv9heA0htZB/Rp4A17ZyBI0dJ+79Fx
WCNyX0zg5X8sSVF7fP63Ypd3YTfQywnEoOkX1zDotTiLcIEp7XHzf75gFVU7I8rr
xXR2lIaQEEf9Hz3VdZ8fyxMmiIhq3gZ/51oY+hl+vkZVDNdd335JzGs7muOFLe7Y
pOVAtMrL9z3l0Eic9ZOdN2Npw2GrCm3/GGd4Mi0NVTuLApXl2bhQdHWLi36PS9UB
4HsePQMErSu6nV8h2xChTSkx1SxstCitUXR33vjihEcqP7x2wVzijYAvGUKwoM3L
QgFqiK8KR6ruCCAVLuD3zXv7t7h72NkYxEoVCy80fp8q+8+6MmnRojWkg37z+uM/
RSsJo7qEcprf+fojlE8=
=O7d6
-----END PGP SIGNATURE-----

--Signature=_Tue__24_Dec_2013_13_49_19_+1100_yzXLK0g/zsz4=4jN--
