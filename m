Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbbA0CjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:39:15 -0500
Received: from ozlabs.org ([103.22.144.67]:54318 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbbA0CjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:39:12 -0500
Date: Tue, 27 Jan 2015 13:39:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@gmail.com>, Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Yan <andy.yan@rock-chips.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ajay Kumar <ajaykumar.rs@samsung.com>
Subject: linux-next: manual merge of the drm-panel tree with the drm tree
Message-ID: <20150127133905.6a2b75bc@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/6bHmvUqOvqDMBD.YXljqwPy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/6bHmvUqOvqDMBD.YXljqwPy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the drm-panel tree got a conflict in
drivers/gpu/drm/bridge/Kconfig between commit b21f4b658df8 ("drm: imx:
imx-hdmi: move imx-hdmi to bridge/dw_hdmi") from the drm tree and
commit c338dcdcc7b6 ("drm/bridge: ptn3460: Convert to I2C driver
model") from the drm-panel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/bridge/Kconfig
index b70f3c8d4e8a,146e67bb037b..000000000000
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@@ -1,10 -1,8 +1,13 @@@
  config DRM_PTN3460
  	tristate "PTN3460 DP/LVDS bridge"
  	depends on DRM
+ 	depends on OF
  	select DRM_KMS_HELPER
+ 	select DRM_PANEL
  	---help---
+ 	  ptn3460 eDP-LVDS bridge chip driver.
 +
 +config DRM_DW_HDMI
 +	tristate
 +	depends on DRM
 +	select DRM_KMS_HELPER

--Sig_/6bHmvUqOvqDMBD.YXljqwPy
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUxvpNAAoJEMDTa8Ir7ZwVFWUP/R0YrnrZB6r742jrgjJrHjGI
v1SlQS9SRQ0FKWLAW0WV9iasy6TYaoUC4PKkxaZ5KLeT2rUSIMW8B6KP4hUJP9Ix
by2GQuB3yd7EF+ZZGy4uoSSfXM2EyqTQwmSadBKsOTC/aBuMDM/F+/FxyaiD7aks
vFxYshbb582aq4g0IHRZqAhMWKzxDiUd1NLqA44DiJ99xcYQfHAiaMXGIttMV9zI
OZxu7uRGLSk9NnZHsx7kVo3RpgF1/drWh8pQLdORS+JpWSOiI3kQOS/yN7A4QCiV
SX2XhjBHvcdQigIG/JCVveiMVXJe5/emfyCXGObHdH652t6on85V5hBob0k7aT86
FD4mTDmcNawmYIpU6kqKvU0077XB9VFWjInZ4bQhl7w29kOiJhhgYOWSI1yRefc5
y3XYmBIcxQAcFdVUwG8Tq9s030UrcWAyFbqj8nJPpe+CpTP7IkWYcC2L5m+fCmHj
m8QTPZZZ7V5u1xioVqHuZzAwiZuC2z9dIOMCgQ/a/c4aBeCcPA+JlX+mi4mkdjNB
Ms0HcD02+0k490ZRVj/vZDpxy9QJc9piF3KP8dTYNa5zyjj72oHX18c2C7ih/3Wv
OxlBuqqWGeNDk0en45TNeQQ+f3esbExL+P9wgMxkQIZNKVDkuqrgLwCBXy5D9vey
QEzkutHH/rjs/PIjoXMl
=N/hk
-----END PGP SIGNATURE-----

--Sig_/6bHmvUqOvqDMBD.YXljqwPy--
