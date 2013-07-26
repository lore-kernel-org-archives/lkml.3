Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3GZDBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 23:01:52 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46666 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758292Ab3GZDBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 23:01:48 -0400
Date: Fri, 26 Jul 2013 13:01:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20130726130129.b10066a83ebf9c59ec345ce9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Jul_2013_13_01_29_+1000_X3kn7WnTJdqgsV+i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Jul_2013_13_01_29_+1000_X3kn7WnTJdqgsV+i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_dma.c between commit 7dcd2677ea91 ("drm/i915:
fix long-standing SNB regression in power consumption after resume v2")
from Linus' tree and commit 59cdb63d529c ("drm/i915: kill
dev_priv->rps.lock") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_dma.c
index 66c6380,6ce9033..0000000
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@@ -1495,15 -1490,6 +1490,14 @@@ int i915_driver_load(struct drm_device=20
  	dev_priv->dev =3D dev;
  	dev_priv->info =3D info;
 =20
 +	spin_lock_init(&dev_priv->irq_lock);
 +	spin_lock_init(&dev_priv->gpu_error.lock);
- 	spin_lock_init(&dev_priv->rps.lock);
 +	spin_lock_init(&dev_priv->gt_lock);
 +	spin_lock_init(&dev_priv->backlight.lock);
 +	mutex_init(&dev_priv->dpio_lock);
 +	mutex_init(&dev_priv->rps.hw_lock);
 +	mutex_init(&dev_priv->modeset_restore_lock);
 +
  	i915_dump_device_info(dev_priv);
 =20
  	if (i915_get_bridge_dev(dev)) {

--Signature=_Fri__26_Jul_2013_13_01_29_+1000_X3kn7WnTJdqgsV+i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR8eaNAAoJEECxmPOUX5FEd+oP/2XbDbAU0noGwE0i7cNvtl4k
VcI7WyrxIAEq4meORoMXRFRW4K16H8xI1O3/hjvJEr+if6Iz98MifVhavl0VELLR
nw9p66M+FKIhn26oxZDyjsP3SLgBr6GhCm2fC67eAKggLGBaicE00/Nyke2bS6gm
V+7/rVMQHG1AKU/vV8PG692/G5mP9CdTwFBPT2Kwiob0FkEj8itn8Rnr3xHgIuL/
NS4kW+eHsoSmK1NpTOkzybHklIPK251TDl8K2Q/R2tkg5jCv0aYzkRx81hnIym2J
OxRLg/c53ZO56IBnAx9YX8bkvX2kwMfJDsWSkBpii0Er3Z+Cnyu0wX/glPHcgjsE
Mfh3tYC5llbV5q6ptLdAnwkVBaMkidRNZmOCG/JmE6iwDMfGn9D+WzK4V/iq5knE
GQCnRCPfmfE7E56F5ElZCscAFBWPDeP7pZyCcqikBOMGkHr32cctNP7tcGkZabhj
xBOqvFDlJIvdMp6G3LgbDc2jy1ywBJnufV8Y9qaGqYt2GZB5Fed/Xu6+dZOD+nau
gpLmcOlYS6Glv3Hf2aqa2pKOA1+Y2RF6MgKDlPG4MFt6CVifqYWI73YTO4nPGR/S
G8Yr9aQ3DFcOhSFpHjf3fg+bYRIbkQi3HswUeIPHCCgydnFJFPfcGY4XexxhmL3F
NvavV9AwgsbLepQ51GbP
=rmy3
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Jul_2013_13_01_29_+1000_X3kn7WnTJdqgsV+i--
