Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab3KGCiH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 21:38:07 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54874 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab3KGCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 21:38:04 -0500
Date: Thu, 7 Nov 2013 13:37:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dave Airlie <airlied@linux.ie>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: linux-next: manual merge of the drm-intel tree with the drm tree
Message-Id: <20131107133751.95ceeb3ddf512a0af6f78f2a@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__7_Nov_2013_13_37_51_+1100_cMYts=mQQgxRz=4R"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Nov_2013_13_37_51_+1100_cMYts=mQQgxRz=4R
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/intel_panel.c between commit 5bdebb183c97
("drm/sysfs: sort out minor and connector device object lifetimes") from
the drm tree and commit 752aa88a1e78 ("drm/i915: make backlight functions
take a connector") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/intel_panel.c
index 09b2994c9b37,cad41ac330e8..000000000000
--- a/drivers/gpu/drm/i915/intel_panel.c
+++ b/drivers/gpu/drm/i915/intel_panel.c
@@@ -726,7 -802,8 +802,8 @@@ int intel_panel_setup_backlight(struct=20
  	}
  	dev_priv->backlight.device =3D
  		backlight_device_register("intel_backlight",
- 					  connector->kdev, dev,
 -					  &connector->kdev,
++					  connector->kdev,
+ 					  to_intel_connector(connector),
  					  &intel_panel_bl_ops, &props);
 =20
  	if (IS_ERR(dev_priv->backlight.device)) {

--Signature=_Thu__7_Nov_2013_13_37_51_+1100_cMYts=mQQgxRz=4R
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSev0EAAoJEMDTa8Ir7ZwV38UP/iQx9XMRlFMmfJ4xEzWMhCbH
J+Lt7eRL0gQhTWTN5Pek5/eDe/Bj8QDg2O89JGERBddh8iVghxlV6SQIIfYN/XLY
R/I1Y399hb4/C1hNxCWt4L7guwL1yZGA/I83gl6LGf51O7Tx9Guuhi4sCUcJnWUk
nu3+vDw2eIBDwZTM0OYzSdbqDftqM2rRqia40jksBQ4as0iUfk+x0Tj8SW/F41zs
Kq2D8L68Huq8NtocZZsvO6Gq53nVicmfX3FpAVZ5nvdfcWozBQDvyY3PI/mppd10
J4C4PZ/bEqn8QFbaAlU7ToxP8XvRN0alqajeIpME7TgSyePk4IlFaL88yB/AZyTh
o4IXtnDz4zkEUMkkhMXBZ4PukGw1dvyngwlnC5pATHcCv7j9/w8/3XoVS14xRnUC
6MYVIxSyEoB9UHcc8qkZeGGxgrx0NdFLAhm0u6i2QpYuRLK2py0XarOVZIyUziUb
Syo1B4ud4mS0ucWgbJgKRtqlkpzBG9JRnRwrvrKOyXO9feC2tweTouJq5QJhPOfC
zB1xnRfSK2xKt+/QBK3OWtJsXJ03uJSHt8OuuphhOgXmbWbPExwDnE6l+gxpqbzf
WVlUckjO1CqNWXGqXGgiuvdQMJ98BAwxxvlY4b95UB5Zp/2Nn78vMB+Wd+a/yt0K
Fjq1LLceg0t/SEf6M7eV
=DQ8q
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Nov_2013_13_37_51_+1100_cMYts=mQQgxRz=4R--
