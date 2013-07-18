Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934198Ab3GRBol (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 21:44:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42028 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3GRBok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 21:44:40 -0400
Date: Thu, 18 Jul 2013 11:44:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>, <intel-gfx@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: linux-next: manual merge of the drm-intel tree with the
 drm-intel-fixes tree
Message-Id: <20130718114427.cbdcf6a802f2a8d99f15bce9@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__18_Jul_2013_11_44_27_+1000_/+UjM_+Z8pHGdsGg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__18_Jul_2013_11_44_27_+1000_/+UjM_+Z8pHGdsGg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the drm-intel tree got a conflict in
drivers/gpu/drm/i915/i915_dma.c between commit 7dcd2677ea91 ("drm/i915:
fix long-standing SNB regression in power consumption after resume v2")
from the drm-intel-fixes tree and commit 59cdb63d529c ("drm/i915: kill
dev_priv->rps.lock") from the drm-intel tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_dma.c
index 095e3db,fd52de7..0000000
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@@ -1495,16 -1490,12 +1490,19 @@@ int i915_driver_load(struct drm_device=20
  	dev_priv->dev =3D dev;
  	dev_priv->info =3D info;
 =20
 +	spin_lock_init(&dev_priv->irq_lock);
 +	spin_lock_init(&dev_priv->gpu_error.lock);
- 	spin_lock_init(&dev_priv->rps.lock);
 +	spin_lock_init(&dev_priv->backlight.lock);
 +	mutex_init(&dev_priv->dpio_lock);
 +	mutex_init(&dev_priv->rps.hw_lock);
 +	mutex_init(&dev_priv->modeset_restore_lock);
 +
  	i915_dump_device_info(dev_priv);
 =20
+ 	INIT_LIST_HEAD(&dev_priv->vm_list);
+ 	INIT_LIST_HEAD(&dev_priv->gtt.base.global_link);
+ 	list_add(&dev_priv->gtt.base.global_link, &dev_priv->vm_list);
+=20
  	if (i915_get_bridge_dev(dev)) {
  		ret =3D -EIO;
  		goto free_priv;

--Signature=_Thu__18_Jul_2013_11_44_27_+1000_/+UjM_+Z8pHGdsGg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR50h/AAoJEECxmPOUX5FEa8cP/104SpIh9dHBy1n+WgJbQaS/
qs8xaE6pHxSn9BRtg/u2bI/A8fU+6pjs5KQ6Jtmph25MkwZ2amACj1jn2m3GhAK4
YTQQRgzTcCmo/h+d+pS+UPaQErd/uH1MnNB3kO+RpmUst5gW/8TO9qdDVvJ/2i5v
EZPX7rGuR1N7KZxrCwJCnRZ4yA8NNiqW2vDWU8NRABTpgNioeCbtyAyHk9k1VQo8
tacrjdntCypKYqv7hqg51YVgMEVDYJwhDzHB7Fv808RbP8Qu/lRE7I2QliTqlLss
RU09sNrFp4Drhbon2zo34u7VnzYYUhlh2+iloFn6Lj/7VrmUf1PsCBOK4PN7BVzg
FD4D3gNnoN5LlUmebotFfdZHc6clbCs6jYn1zl71gLdctIASH4pO0gFMro0POrwq
TTIy6xUjO6pf/L5rHNsSqYm6izAUOpGzCPSrzjBymaOcSz19mMWPgFJ3FV/VdNXp
fdBEAjayZbg84jMVV6YhQHqQi5RW6rEsaAB+ynCrm4l+ETxXPYE1ndeiuJ3lZ+qU
svh/e/13Dw/VC0saDJv5tY/SyacYkiI90XkjOFqgjHuhlfLDoBszbcYcEzZuq1w3
GXoCWKYh7D5e+31o7OkmN+hUPmH9vI5muKuHmr/ayoHp+kdLGewIRvDe6hsB/kL5
wRPigkWhmh4T6TAbMnSq
=RSR5
-----END PGP SIGNATURE-----

--Signature=_Thu__18_Jul_2013_11_44_27_+1000_/+UjM_+Z8pHGdsGg--
