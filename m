Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3LSB7U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 20:59:20 -0500
Received: from ozlabs.org ([203.10.76.45]:54435 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872Ab3LSB7T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 20:59:19 -0500
Date: Thu, 19 Dec 2013 12:59:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20131219125913.421629bb84b8fde532c2150f@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Dec_2013_12_59_13_+1100_PuGxH=jti8qxLK1T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Dec_2013_12_59_13_+1100_PuGxH=jti8qxLK1T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/drm_stub.c between commit 0f58411d4fd7 ("drm: don't
double-free on driver load error") from Linus' tree and commit
2c695fa04442 ("drm: remove agp_init() bus callback") from the drm tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/drm_stub.c
index 66dd3a001cf1,a4a5c6ac110a..000000000000
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@@ -566,14 -564,11 +564,11 @@@ err_unload
  	if (dev->driver->unload)
  		dev->driver->unload(dev);
  err_primary_node:
 -	drm_put_minor(dev->primary);
 +	drm_unplug_minor(dev->primary);
  err_render_node:
 -	drm_put_minor(dev->render);
 +	drm_unplug_minor(dev->render);
  err_control_node:
 -	drm_put_minor(dev->control);
 +	drm_unplug_minor(dev->control);
- err_agp:
- 	if (dev->driver->bus->agp_destroy)
- 		dev->driver->bus->agp_destroy(dev);
  out_unlock:
  	mutex_unlock(&drm_global_mutex);
  	return ret;

--Signature=_Thu__19_Dec_2013_12_59_13_+1100_PuGxH=jti8qxLK1T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSslL1AAoJEMDTa8Ir7ZwVJEcP/j0CSaW58b1C44AZBV0W9YJj
3rqpEq6ETCGVgn2wUtdbZgg3IrK4iIMbGWIl2gIy9E62ugDEgyrKQjBZYfS2IcOO
kY21BoRSIsZRU9OrQ8BSAuGxdF8Qcx/EGJXcd9cXO/LgWX+HnQiucB/yKsemNjPP
60XuW5ZdWG84BylFkMlR5DuIwyC1x4IHj7Qh4WD61Qd8NUU8olL4nQS6l+daaGbI
jQ1MVCMpc0NR81/rc9vyJ9gzrJJ8qv2mx4el02Wto+G9sBwsEb5JZK1KDjQFqDTT
aj/jShYXnh6+kzh89G8L5QXMaMDIiiW8zHLvatAyHCrDdZUjjN4mCre3HVvrVGuE
eNaOTFMFvxdK3uqSgKCFvMcoxNueS2Ywuln8B34mHrCN1QLRjol6x7QNHG78LAct
sxQTSwoDmeFopqNq0zH6htLrwcG44Lhsk5jDBQVFc+SClNEqPitQWBDF25QubQh0
3UNYXSKsm/UgEypq43+jE+LPtVaEWUi72/P5mGFoAI+/zyheEqDnHn8Qf981/hNT
ob4VAHRBawuMH7Oo7l8DVeJKCikyJxyfgwGv1lds1K7cFQYU59A3Z8/i5mIqe+wT
tg/eC/cVJJWXMGBNpmiIJdvp7bMoK25KIPcd/jlxzvDQ+tviFXpyrNArxvFz3n3d
OhEibh7s7bmIrLpjxHFy
=2APY
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Dec_2013_12_59_13_+1100_PuGxH=jti8qxLK1T--
